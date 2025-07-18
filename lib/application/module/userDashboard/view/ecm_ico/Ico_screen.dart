import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/buy_Ecm.dart';
import '../../../../../framework/components/buy_ecm_button.dart';
import '../../../../../framework/components/customInputField.dart';
import '../../../../../framework/components/custonButton.dart';
import '../../../../../framework/components/disconnectButton.dart';
import '../../../../../framework/components/loader.dart';
import '../../../../../framework/utils/customToastMessage.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/toast_type.dart';
import '../../../../../framework/utils/general_utls.dart';
import '../../../../data/services/download_white_paper.dart';
import '../../../../presentation/models/token_model.dart';
import '../../../../presentation/screens/bottom_nav_bar.dart';
import '../../../../presentation/viewmodel/bottom_nav_provider.dart';
import '../../../../presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import '../../viewmodel/dashboard_nav_provider.dart';
import '../../viewmodel/kyc_navigation_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web3dart/web3dart.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/upload_image_provider.dart';



class ECMIcoScreen extends StatefulWidget {
  const ECMIcoScreen({super.key});

  @override
  State<ECMIcoScreen> createState() => _ECMIcoScreenState();
}

class _ECMIcoScreenState extends State<ECMIcoScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final usdtController = TextEditingController();
  final ecmController = TextEditingController();
  final readingMoreController = TextEditingController();
  final referredController = TextEditingController();
  final String defaultReferrerAddress = '0x0000000000000000000000000000000000000000';

  bool isETHActive = true;
  bool isUSDTActive = false;

  double _ethPrice = 0.0;
  double _usdtPrice = 0.0;

  int  _stageIndex = 0;
  double _currentECM = 0.0;
  double _maxECM = 0.0;
  bool isDisconnecting = false;

  List<TokenModel> tokens = [];

  @override
  void initState() {
    super.initState();
    ecmController.addListener(_updatePayableAmount);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      try {
        final stageInfo = await walletVM.getCurrentStageInfo();
        final ethPrice = stageInfo['ethPrice'];
        final usdtPrice = stageInfo['usdtPrice'];
        final currentECM = stageInfo['ecmSold'];
        final maxECM = stageInfo['target'];
        final stageIndex = stageInfo['stageIndex'];

        setState(() {
          _stageIndex = stageIndex;
          _currentECM = currentECM;
          _maxECM = maxECM;
          _ethPrice = ethPrice;
          _usdtPrice = usdtPrice;

        });
      } catch (e) {
        if (mounted) {
          Utils.flushBarErrorMessage("Please connect your wallet", context);

        }
      }
    });
  }


  void _updatePayableAmount() {
    final ecmAmount = double.tryParse(ecmController.text) ?? 0.0;
    double result = isETHActive ? ecmAmount * _ethPrice : ecmAmount * _usdtPrice;

    // Display converted amount in the usdtController
    usdtController.text =  isETHActive ? result.toStringAsFixed(5) : result.toStringAsFixed(1);

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;

    return  Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 80,
        drawer: SideNavBar(
          currentScreenId: currentScreenId,
          navItems: navItems,
          onScreenSelected: (id) => navProvider.setScreen(id),
          onLogoutTapped: () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logout Pressed")));
          },
        ),

        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,

        body: SafeArea(
          top: false,
          child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                color: Color(0xFF01090B),
                image: DecorationImage(
                  image: AssetImage('assets/icons/starGradientBg.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topRight,
                ),
              ),
              child:Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: Alignment.topCenter,
                    child:  Text(
                      'ECM ICO',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        // fontSize: 20
                        fontSize: screenWidth * 0.05,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.02,
                      ),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: screenHeight * 0.02),


                              _buildTokenCard(context),

                              SizedBox(height: screenHeight * 0.04),


                              /// Buy ECM section
                              _buildBuyEcmSection(),

                              SizedBox(height: screenHeight * 0.04),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        )
    );
  }

  /// White Paper section With timer
  Widget _buildTokenCard(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;
    // final socialMedia = tokens.first.socialMedia;

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Token Card
          Container(
            width: screenWidth,
             decoration: BoxDecoration(
               border: Border.all(
                   color: Colors.transparent
               ),
               image:const DecorationImage(
                 image: AssetImage('assets/icons/viewTokenFrameBg.png'),
                 fit: BoxFit.fill,

               ),
            ),
            child: Padding(
              padding: EdgeInsets.all(baseSize * 0.030),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: baseSize * 0.01),


                  Text(
                    'Unlocking eCommerce Potential with Digital Coin Solutions',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: getResponsiveFontSize(context, 16),
                      height: 1.3,
                      color: Colors.white,
                    ),
                  ),


                  SizedBox(height: baseSize * 0.04),
                  Text(
                    'Explore the ECM Cloud for Seamless eCommerce Integration, Unlocking Innovative Tools to Elevate your Metaverse Experience.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: getResponsiveFontSize(context, 10),
                      height: 1.6,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: baseSize * 0.04),

                  CustomLabeledInputField(
                    labelText: 'ECM Address:',
                    hintText: ' https://mycoinpoll.com?ref=125482458661',
                    controller: referredController,
                    isReadOnly: true,

                  ),

                  SizedBox(height: baseSize * 0.04),

                  /// Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 9.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                              _imageButton(
                                context,
                                'assets/icons/xIcon.svg',
                                'https://x.com/ecmcoin'

                                // socialMedia!.twitter!,

                              ),
                            SizedBox(width: baseSize * 0.02),
                               _imageButton(
                                context,
                                'assets/icons/teleImage.svg',
                                'https://t.me/ecmcoin'
                                // socialMedia!.telegram!,
                              )
                          ],
                        ),
                      ),
                      SizedBox(width: baseSize * 0.02),


                      BlockButton(
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.04,
                        label: "White Paper",
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: getResponsiveFontSize(context, 12),
                        ),
                        gradientColors: const [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494),
                        ],
                        onTap: () async {
                          await DownloadService.downloadWhitepaperPdf(context);

                        },
                      ),

                      BlockButtonV2(
                        text: 'Official Website',
                         onPressed: () async{
                          debugPrint('Button tapped!');
                          const url = 'https://ecmcoin.com/';
                          if (await canLaunchUrl(Uri.parse(url))) {
                           await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                           } else {
                           debugPrint('Could not launch $url');
                           }
                        },
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: getResponsiveFontSize(context, 12),
                        ),
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.04,
                      ),


                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// _imageButton Widget
  Widget _imageButton(BuildContext context, String imagePath,  String url) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.04; // 5% of screen width

    final isSvg = imagePath.toLowerCase().endsWith('.svg');

    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ToastMessage.show(
            message: "Could not open the link",
            subtitle: "Invalid or inaccessible URL",
            type: MessageType.error,
            duration: CustomToastLength.SHORT,
            gravity: CustomToastGravity.BOTTOM,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(8),
        child: isSvg
            ? SvgPicture.asset(
          imagePath,
          width: imageSize,
          height: imageSize,
          color: Colors.white,
        )
            : Image.asset(
          imagePath,
          width: imageSize,
          height: imageSize,
          color: Colors.white,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// Buy ECM Section
  Widget _buildBuyEcmSection() {
     final Size screenSize = MediaQuery.of(context).size;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenSize.height > screenSize.width;
    final double textScale = isPortrait ? screenWidth / 400 : screenHeight / 400;
    final double paddingScale = screenWidth * 0.04;
    final baseSize = isPortrait ? screenWidth : screenHeight;
    return  Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [

          SizedBox(height: screenHeight * 0.02),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.transparent
                ),
                image:const DecorationImage(
                  image: AssetImage('assets/icons/buyEcmContainerImageV.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Consumer<WalletViewModel>(builder: (context, walletVM, child) {

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 9),
                    const SizedBox(height: 18),

                    // Stage &  MAx Section
                    ECMProgressIndicator(
                      stageIndex: _stageIndex,
                      currentECM: _currentECM,
                      maxECM: _maxECM,
                    ),


                    SizedBox(
                      width: screenWidth * 0.9,
                      child: const Divider(
                        color: Colors.white12,
                        thickness: 1,
                        height: 20,
                      ),
                    ),
                    /// Address Section
                if (walletVM.isConnected)...[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
                          CustomLabeledInputField(
                            labelText: 'Your Address:',
                            hintText: walletVM.walletAddress,
                            controller: readingMoreController,
                            isReadOnly: true,
                          ),
                           SizedBox(height: screenHeight * 0.02),
                          CustomLabeledInputField(
                            labelText: 'Referral Link:',
                            hintText: ' https://mycoinpoll.com?ref=125482458661',
                            controller: referredController,
                            isReadOnly: true,
                            trailingIconAsset: 'assets/icons/copyImg.svg',
                             onTrailingIconTap: () {
                              debugPrint('Trailing icon tapped');
                              const referralLink = 'https://mycoinpoll.com?ref=125482458661';

                              Clipboard.setData(const ClipboardData(text:referralLink));

                              ToastMessage.show(
                                message: "Referral link copied!",
                                subtitle: referralLink,
                                type: MessageType.success,
                                duration: CustomToastLength.SHORT,
                                gravity: CustomToastGravity.BOTTOM,
                              );

                            },

                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
                          CustomLabeledInputField(
                            labelText: 'Referred By:',
                            hintText: 'Show and Enter Referred id..',
                            controller: referredController,
                            isReadOnly:
                            false, // or false
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.9,
                      child: const Divider(
                        color: Colors.white12,
                        thickness: 1,
                        height: 20,
                      ),
                    ),
                ],
                    ///Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 18.0 , vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Buy with ETH Button
                          Expanded(
                            child: CustomButton(
                              text: 'Buy with ETH',
                              icon: 'assets/icons/eth.png',
                              isActive: isETHActive,
                              onPressed: ()async {
                                try {
                                  final stageInfo = await walletVM.getCurrentStageInfo();
                                  final ethPrice = stageInfo['ethPrice'];

                                  setState(() {
                                    _ethPrice = ethPrice;
                                    isETHActive = true;
                                    isUSDTActive = false;

                                  });
                                  _updatePayableAmount();

                                } catch (e) {

                                  if (context.mounted) {
                                    debugPrint('Error fetching stage info: ${e.toString()}');
                                    Utils.flushBarErrorMessage("We couldn't get the price details. Please connect your wallet and try again.", context);

                                  }
                                }

                              },

                            ),
                          ),
                          const SizedBox(width: 12),
                          //Buy with USDT Button
                          Expanded(
                            child:
                            CustomButton(
                              text: 'Buy with USDT',
                              icon: 'assets/icons/usdt.png',
                              isActive: isUSDTActive,
                              onPressed: ()async {
                                try {
                                  final stageInfo = await walletVM.getCurrentStageInfo(); // Get the stage info
                                  final usdtPrice = stageInfo['usdtPrice'];

                                  setState(() {
                                    _usdtPrice = usdtPrice;
                                    isETHActive = false;
                                    isUSDTActive = true;
                                  });
                                  _updatePayableAmount();
                                  debugPrint("Switched to USDT mode. USDT Price: $_usdtPrice");

                                } catch (e) {
                                  if (context.mounted) {
                                    debugPrint('Error fetching stage info: ${e.toString()}');

                                    Utils.flushBarErrorMessage("We couldn't get the price details. Please connect your wallet and try again.", context);

                                  }
                                }

                              },

                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),

                    Text(
                      isETHActive
                          ? "1 ECM = ${_ethPrice.toStringAsFixed(5)} ETH"
                          : "1 ECM = ${_usdtPrice.toStringAsFixed(1)} USDT",

                      style:  TextStyle(
                        color: Colors.white,
                        // fontSize: screenWidth * 0.032,
                        fontSize: getResponsiveFontSize(context, 13),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 18),


                    /// ECm AMount INput Section
                    CustomInputField(
                      hintText: 'ECM',
                      iconAssetPath: 'assets/icons/ecm.png',
                      controller: ecmController,
                    ),
                    const SizedBox(height: 12),
                    CustomInputField(
                      hintText: isETHActive ? 'ETH ' : 'USDT ',
                      iconAssetPath: isETHActive ? 'assets/icons/eth.png' : 'assets/icons/usdt.png',
                      controller: usdtController,

                    ),

                    const SizedBox(height: 18),
                    CustomGradientButton(
                      label: 'Buy ECM',
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.05,
                      leadingImagePath: 'assets/icons/buyEcmLeadingImg.svg',
                      onTap: () async {

                        if (!walletVM.isConnected) {
                          print("Wallet not connected. Prompting user to connect...");
                          try {
                            await walletVM.ensureModalWithValidContext(context);
                            await walletVM.appKitModal?.openModalView();
                          } catch (e) {
                            debugPrint("Failed to open wallet modal: $e");
                            return;
                          }

                          return;
                        }

                        try{
                          final inputEth = ecmController.text.trim();
                          debugPrint("User input: $inputEth");
                          final ethDouble = double.tryParse(inputEth);
                          debugPrint("Parsed double: $ethDouble");
                          if (ethDouble == null || ethDouble <= 0) {
                            ToastMessage.show(
                              message: "Invalid Amount",
                              subtitle: "Please enter a valid ECM amount.",
                              type: MessageType.info,
                              duration: CustomToastLength.SHORT,
                              gravity: CustomToastGravity.BOTTOM,
                            );

                            return;
                          }

                          final ecmAmountInWeiETH = BigInt.from(ethDouble * 1e18);
                          final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e6);
                          // final ecmAmountInWeiUSDT = EtherAmount.fromUnitAndValue(EtherUnit.wei, (ethDouble * 1e6).round()).getInWei;

                          debugPrint("ETH in Wei: $ecmAmountInWeiETH");
                          debugPrint("USDT in smallest unit: $ecmAmountInWeiUSDT");

                          final isETH = isETHActive;
                          final amount = isETH ? ecmAmountInWeiETH : ecmAmountInWeiUSDT;
                          debugPrint("Calling ${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} with: $amount");
                          debugPrint("Purchase Button Pressed");

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                          );

                          if (isETH) {
                            debugPrint("Calling buyECMWithETH with: $ecmAmountInWeiETH");
                            await walletVM.buyECMWithETH(EtherAmount.inWei(amount),context);

                          } else  {
                            debugPrint("Calling buyECMWithUSDT with: $ecmAmountInWeiUSDT");
                            await walletVM.buyECMWithUSDT(amount,context);
                            // await walletVM.buyECMWithUSDT(EtherAmount.inWei(amount),context);
                          }
                          Navigator.of(context).pop();
                          debugPrint("${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} completed");
                          ecmController.clear();

                        }catch (e) {
                          Navigator.of(context).pop();
                          debugPrint("Buy ECM failed: $e");
                        }
                      },
                      gradientColors: const [
                        Color(0xFF2D8EFF),
                        Color(0xFF2EE4A4)
                      ],
                    ),
                    const SizedBox(height: 18),

                    if (walletVM.isConnected)...[

                      DisconnectButton(
                    label: 'Disconnect',
                    color: const Color(0xffE04043),
                    icon: 'assets/icons/disconnected.svg',
                    onPressed: () async {
                      setState(() {
                        isDisconnecting = true;
                      });
                      try {
                        await walletVM.disconnectWallet(context);
                        Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);

                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(create: (context) => WalletViewModel(),),
                                  ChangeNotifierProvider(create: (_) => BottomNavProvider()),
                                  ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
                                  ChangeNotifierProvider(create: (_) => PersonalViewModel()),
                                  ChangeNotifierProvider(create: (_) => NavigationProvider()),
                                  ChangeNotifierProvider(create: (_) => KycNavigationProvider()),
                                  ChangeNotifierProvider(create: (_) => UploadProvider()),
                                ],
                                child: const BottomNavBar(),
                              ),
                            ),
                                (Route<dynamic> route) => false,
                          );
                        }
                      }catch (e) {
                        if (context.mounted) {
                          print('Error disconnecting: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error disconnecting: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }finally{
                        if (mounted) {
                          setState(() {
                            isDisconnecting = false;
                          });
                        }
                      }
                    },

                  ),

                    ],
                    const SizedBox(height: 18),

                  ],
                );
              }
              ),
            ),
          ),
        ],
      ),
    );
  }



}


