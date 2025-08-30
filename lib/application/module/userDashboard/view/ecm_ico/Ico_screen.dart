
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/buy_Ecm.dart';
import '../../../../../framework/components/buy_ecm_button.dart';
import '../../../../../framework/components/customInputField.dart';
 import '../../../../../framework/components/disconnectButton.dart';
 import '../../../../../framework/utils/customToastMessage.dart';
import '../../../../../framework/utils/decimalFormat.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/toast_type.dart';
import '../../../../data/services/api_service.dart';
import '../../../../data/services/download_white_paper.dart';
import '../../../../presentation/models/eCommerce_model.dart';
import '../../../../presentation/models/token_model.dart';
import '../../../../presentation/screens/bottom_nav_bar.dart';
import '../../../../presentation/viewmodel/bottom_nav_provider.dart';
import '../../../../presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import '../../viewmodel/dashboard_nav_provider.dart';
 import '../../viewmodel/side_navigation_provider.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web3dart/web3dart.dart';
import '../../../side_nav_bar.dart';

class ECMIcoScreen extends StatefulWidget {
  const ECMIcoScreen({super.key});

  @override
  State<ECMIcoScreen> createState() => _ECMIcoScreenState();
}

class _ECMIcoScreenState extends State<ECMIcoScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final usdtController = TextEditingController();
  final ecmController = TextEditingController();
  final ethController = TextEditingController();
  final readingMoreController = TextEditingController();
  final referredController = TextEditingController();
  final String defaultReferrerAddress = '0x0000000000000000000000000000000000000000';


  bool isDisconnecting = false;

  List<TokenModel> tokens = [];
  String _referredByAddress = '';
  bool _isReferredByLoading = false;
  String _uniqueId = '';

  TokenDetails? _tokenDetails;
  bool _isLoadingToken = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    ecmController.addListener(_updateEthFromECM);
    ethController.addListener(_updateECMFromEth);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final uniqueIdFromPrefs = prefs.getString('unique_id');
      if(uniqueIdFromPrefs != null){
        setState(() {
          _uniqueId = uniqueIdFromPrefs;
        });
      }

      await _fetchReferredByAddress();
      await _fetchTokenData();


    });
  }

  Future<void> _fetchReferredByAddress() async {
    setState(() {
      _isReferredByLoading = true;
      _referredByAddress = '';
    });
    try {
      final address = await ApiService().fetchPurchaseReferral();
      setState(() {
        _referredByAddress = address;
      });
    } catch (e) {
      setState(() {
        _referredByAddress = 'Error fetching referral address';
      });
      print('Error fetching referral address: $e');
    }finally{
      setState(() {
        _isReferredByLoading = false;
      });
    }
  }
  Future<void> _fetchTokenData() async {
     if (mounted) {
      setState(() {
        _isLoadingToken = true;
      });
    }

    try {

      final details = await ApiService().fetchTokenDetails('e-commerce-coin');
      if (mounted) {
        setState(() {
          _tokenDetails = details;
          _isLoadingToken = false;
        });
      }
    } catch (e) {
       if (mounted) {
        setState(() {
          _isLoadingToken = false;
        });
        ToastMessage.show(
          message: "Could not load token info",
          subtitle: "Please check your connection.",
          type: MessageType.error,
        );
      }
    }
  }

  void _updateEthFromECM() {
    if (_isUpdating) return;
    _isUpdating = true;

    final ecmAmount = double.tryParse(ecmController.text) ?? 0.0;
    if (ecmAmount == null || ecmAmount == 0.0) {
      ethController.clear();
      _isUpdating = false;
      return;
    }



    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    final ethAmount = ecmAmount * walletVM.ethPrice;

    ethController.text = ethAmount.toStringAsFixed(6);

    _isUpdating = false;
  }
  void _updateECMFromEth() {
    if (_isUpdating) return;
    _isUpdating = true;

    final ethAmount = double.tryParse(ethController.text) ?? 0.0;
    if (ethAmount == null || ethAmount == 0.0) {
      ecmController.clear();
      _isUpdating = false;
      return;
    }
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    if (walletVM.ethPrice > 0) {
      final ecmAmount = ethAmount / walletVM.ethPrice;
      ecmController.text = ecmAmount.toStringAsFixed(6);
    }
    _isUpdating = false;
  }

  @override
  void dispose() {
    ecmController.dispose();
    ethController.dispose();
    ecmController.removeListener(_updateEthFromECM);
    ethController.removeListener(_updateECMFromEth);
    readingMoreController.dispose();
     super.dispose();
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
                    image: AssetImage('assets/images/starGradientBg.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topRight,
                    filterQuality : FilterQuality.low
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
                  image: AssetImage('assets/images/viewTokenFrameBg.png'),
                  fit: BoxFit.fill,
                  filterQuality : FilterQuality.low
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
                    hintText:  _isLoadingToken
                        ? 'Loading...'
                        : _tokenDetails?.contractAddress ?? 'Address not available',
                    isReadOnly: true,
                    trailingIconAsset: 'assets/icons/copyImg.svg',
                    onTrailingIconTap: () {
                      final ecmAddress =  _tokenDetails?.contractAddress;

                      if(ecmAddress != null && ecmAddress.isNotEmpty){
                        Clipboard.setData(ClipboardData(text:ecmAddress));
                        ToastMessage.show(
                          message: "ECM Address copied!",
                          subtitle: ecmAddress,
                          type: MessageType.success,
                          duration: CustomToastLength.SHORT,
                          gravity: CustomToastGravity.BOTTOM,
                        );
                      }
                    },


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


                            ),
                            SizedBox(width: baseSize * 0.02),
                            _imageButton(
                                context,
                                'assets/icons/teleImage.svg',
                                'https://t.me/ecmcoin'
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
            filterQuality : FilterQuality.low
        ),
      ),
    );
  }

  /// Buy ECM Section

  Widget _buildBuyEcmSection() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return  Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Initial Coin Offering',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  // fontSize: baseSize * 0.045,
                  fontSize: getResponsiveFontSize(context, 16),
                  color: Colors.white,
                ),
              ),
            ],
          ),
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
                  image: AssetImage('assets/images/buyEcmContainerImageV.png'),
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.low,
                ),
              ),
              child: Consumer<WalletViewModel>(builder: (context, walletVM, child) {

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 18),

                    /// Address Section
                    if (walletVM.isConnected)...[
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: const Divider(
                          color: Colors.white12,
                          thickness: 1,
                          height: 15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            CustomLabeledInputField(
                              labelText: 'Your Address:',
                              hintText: walletVM.isConnected && walletVM.walletAddress.isNotEmpty
                                  ? walletVM.walletAddress
                                  : 'Not connected',
                              controller: readingMoreController,
                              isReadOnly: true,
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            CustomLabeledInputField(
                              labelText: 'Referred By:',
                              hintText: _isReferredByLoading ?'Loading...'
                                  : (_referredByAddress.isNotEmpty ? _referredByAddress : 'Not found'),
                              controller: referredController,
                              isReadOnly: false,
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
                    const SizedBox(height: 5),
                    Text(
                      walletVM.ethPrice > 0
                          ? "1 ECM = ${walletVM.ethPrice.toStringAsFixed(6)} ETH"
                          : "Loading...",
                      style:  TextStyle(
                        color: Colors.white,
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
                      iconAssetPath: 'assets/images/ecm.png',
                      controller: ecmController,
                      // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),]
                      inputFormatters: [DecimalTextInputFormatter(),],

                    ),

                    const SizedBox(height: 12),
                    CustomInputField(
                      hintText:'ETH ',
                      iconAssetPath:'assets/images/eth.png',
                      controller: ethController,
                      // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),],
                      inputFormatters: [DecimalTextInputFormatter(),],

                    ),

                    const SizedBox(height: 18),
                    CustomGradientButton(
                      label: 'Buy ECM',
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.05,
                      leadingImagePath: 'assets/icons/buyEcmLeadingImg.svg',
                      onTap: () async {
                        final walletVM = Provider.of<WalletViewModel>(context, listen: false);
                        if (!walletVM.isConnected) {
                          final ok = await walletVM.connectWallet(context);
                          await walletVM.ensureModalWithValidContext(context);
                          if (!ok) return;
                        }
                        try {
                          final ecmAmount = double.tryParse(ecmController.text.trim());
                          if (ecmAmount == null || ecmAmount <= 0) {
                            ToastMessage.show(
                              message: "Invalid Amount",
                              subtitle: "Please enter a valid ECM amount.",
                              type: MessageType.info,
                              duration: CustomToastLength.SHORT,
                              gravity: CustomToastGravity.TOP,
                            );
                            return;
                          }

                          final ethPricePerECM = walletVM.ethPrice;
                          final requiredEth = Decimal.parse(ecmAmount.toString()) * Decimal.parse(ethPricePerECM.toString());
                          final ethAmountInWei = EtherAmount.fromBigInt(
                            EtherUnit.wei,
                            (requiredEth * Decimal.parse('1e18')).toBigInt(),
                          );


                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                          );

                          final referralInput = referredController.text.trim();
                          final referralAddress = referralInput.isNotEmpty &&
                              EthereumAddress.fromHex(referralInput).hex != defaultReferrerAddress
                              ? EthereumAddress.fromHex(referralInput)
                              : EthereumAddress.fromHex(defaultReferrerAddress);


                          final txHash = await walletVM.buyECMWithETH(
                            ethAmount: ethAmountInWei,
                            referralAddress: referralAddress,
                            context: context,
                          );
                          Navigator.of(context).pop();
                          ecmController.clear();
                          ethController.clear();
                          if (txHash != null) {
                            ToastMessage.show(
                              message: "Purchase Successful",
                              subtitle: "Transaction hash: $txHash",
                              type: MessageType.success,
                              duration: CustomToastLength.LONG,
                              gravity: CustomToastGravity.BOTTOM,
                            );
                          }
                        } catch (e) {
                          Navigator.of(context).pop();

                        }
                      },
                      gradientColors: const [
                        Color(0xFF2D8EFF),
                        Color(0xFF2EE4A4)
                      ],
                    ),

                    const SizedBox(height: 18),
                    DisconnectButton(
                      label: 'Disconnect',
                      color: const Color(0xffE04043),
                      icon: 'assets/icons/disconnected.svg',
                      onPressed: ()async {
                        setState(() {
                          isDisconnecting = true;
                        });
                        final walletVm = Provider.of<WalletViewModel>(context, listen: false);
                        try{
                          await walletVm.disconnectWallet(context);

                          walletVm.reset();
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();

                          Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);
                          if(context.mounted && !walletVm.isConnected){
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(create: (context) => WalletViewModel(),),
                                      ChangeNotifierProvider(create: (_) => BottomNavProvider()),
                                      ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
                                      ChangeNotifierProvider(create: (_) => PersonalViewModel()),
                                      ChangeNotifierProvider(create: (_) => NavigationProvider()),
                                    ],
                                    child: const BottomNavBar(),
                                  )
                              ),(Route<dynamic> route) => false,
                            );
                          }

                        }catch(e){
                          debugPrint("Error Wallet Disconnecting : $e");
                        }finally{
                          if(mounted){
                            setState(() {
                              isDisconnecting = false;
                            });
                          }
                        }
                      },

                    ),
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


