import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/WhitePaperButtonComponent.dart';
import '../../../../../framework/components/badgeComponent.dart';
import '../../../../../framework/components/buy_ecm_button.dart';
import '../../../../../framework/components/customInputField.dart';
import '../../../../../framework/components/custonButton.dart';
import '../../../../../framework/components/disconnectButton.dart';
import '../../../../../framework/components/loader.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/general_utls.dart';
import '../../../../../framework/utils/routes/route_names.dart';
import '../../../../presentation/screens/home/home_screen.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';



class ECMIcoScreen extends StatefulWidget {
  const ECMIcoScreen({super.key});

  @override
  State<ECMIcoScreen> createState() => _ECMIcoScreenState();
}

class _ECMIcoScreenState extends State<ECMIcoScreen> {




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

    return  Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,

        body: SafeArea(
          top: false,
          child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF01090B),
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
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.02,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: screenHeight * 0.02),


                            _buildTokenCard(),
                            SizedBox(height: screenHeight * 0.04),


                            /// Buy ECM section
                            _buildBuyEcmSection(),

                            SizedBox(height: screenHeight * 0.04),

                          ],
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
  Widget _buildTokenCard() {
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
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Color(0xff010219),
                  Color(0xff050A7F)],
                begin: Alignment(-1.0, 0.0),
                end: Alignment(1.0, 1.0),
                stops: [0.68, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x80FFFFFF),
                  offset: Offset(0, 1),
                  blurRadius: 1,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color(0x80010227),
                  offset: Offset(0, 0.75),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
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
                            // SizedBox(width: baseSize * 0.02),
                            _imageButton(
                              context,
                              'assets/icons/xIcon.svg',
                                  () {
                                debugPrint('Image button tapped!');
                              },
                            ),
                            SizedBox(width: baseSize * 0.02),
                            _imageButton(
                              context,
                              'assets/icons/teleImage.svg',
                                  () {
                                debugPrint('Image button tapped!');
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: baseSize * 0.02),

                      WhitePaperButtonComponent(
                        label: 'White Paper',
                        color: Colors.white,
                        onPressed: () {},
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.04,
                      ) ,
                      // SizedBox(width: baseSize * 0.02),

                      WhitePaperButtonComponent(
                        label: 'Official Website',
                        color: Colors.white,
                        onPressed: () {},
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.04,
                      )

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
  Widget _imageButton(BuildContext context, String imagePath, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.04; // 5% of screen width

    final isSvg = imagePath.toLowerCase().endsWith('.svg');

    return InkWell(
      onTap: onTap,
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

          Align(
            alignment: Alignment.center,
            child: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.transparent
                ),
                image:const DecorationImage(
                  image: AssetImage('assets/icons/buyEcmContainerImage.png'),
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


                    const Divider(
                      color: Colors.white12,
                      thickness: 1,
                      height: 20,
                    ),

                    /// Address Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
                          CustomLabeledInputField(
                            labelText: 'Your Address:',
                            hintText: '${walletVM.walletAddress}',
                            controller: readingMoreController,
                            isReadOnly: true,
                          ),
                          const SizedBox(height: 3),
                          // if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
                          CustomLabeledInputField(
                            labelText: 'Referral Link:',
                            hintText: ' https://mycoinpoll.com?ref=125482458661',
                            controller: referredController,
                            isReadOnly: true,
                            trailingIconAsset: 'assets/icons/copyImg.svg',
                            onTrailingIconTap: () {
                              debugPrint('Trailing icon tapped');
                            },
                          ),
                          const SizedBox(height: 3),
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
                    const Divider(
                      color: Colors.white12,
                      thickness: 1,
                      height: 20,
                    ),

                    ///Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 55.0 , vertical: 10),
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
                          const SizedBox(width: 8),
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
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        height: 0.6,
                      ),
                    ),

                    const SizedBox(height: 22),

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
                        debugPrint("ECM Purchase triggered");
                        try{
                          final inputEth = ecmController.text.trim();
                          debugPrint("User input: $inputEth");
                          final ethDouble = double.tryParse(inputEth);
                          debugPrint("Parsed double: $ethDouble");
                          if (ethDouble == null || ethDouble <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enter a valid ECM amount')),
                            );
                            return;
                          }

                          final ecmAmountInWeiETH = BigInt.from(ethDouble * 1e18);
                          // final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e16);
                          final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e6);
                          debugPrint("ETH in Wei: $ecmAmountInWeiETH");
                          debugPrint("USDT in smallest unit: $ecmAmountInWeiUSDT");

                          final isETH = isETHActive;
                          final amount = isETH ? ecmAmountInWeiETH : ecmAmountInWeiUSDT;
                          debugPrint("Calling ${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} with: $amount");
                          debugPrint("Purchase Button Pressed");

                          if (isETH) {
                            debugPrint("Calling buyECMWithETH with: $ecmAmountInWeiETH");
                            await walletVM.buyECMWithETH(EtherAmount.inWei(amount),context);
                          } else  {
                            debugPrint("Calling buyECMWithUSDT with: $ecmAmountInWeiUSDT");
                            await walletVM.buyECMWithUSDT(amount,context);
                          }
                          debugPrint("${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} completed");

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Purchase successful')),
                          );
                        }catch (e) {
                          debugPrint("Buy ECM failed: $e");
                        }
                      },
                      gradientColors: [
                        Color(0xFF2D8EFF),
                        Color(0xFF2EE4A4)
                      ],
                    ),
                    const SizedBox(height: 18),

                    // if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
                    //   isDisconnecting ? Center(child: CircularProgressIndicator())
                    //       :
                      DisconnectButton(
                        label: 'Disconnect',
                        color: Color(0xffE04043),
                        icon: 'assets/icons/disconnected.svg',
                        onPressed: () async {
                          setState(() {
                            isDisconnecting = true;
                          });
                          try {
                            await walletVM.disconnectWallet(context);
                            walletVM.reset();
                            // if (context.mounted && !walletVM.isConnected) {
                            //   Navigator.pushReplacementNamed(context, RoutesName.walletLogin);
                            // }

                          } catch (e) {
                            if (context.mounted) {
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
