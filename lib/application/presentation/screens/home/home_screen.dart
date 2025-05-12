import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/apply_for_listing_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/view_token_screen.dart';
import 'package:mycoinpoll_metamask/framework/utils/general_utls.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../../../../framework/components/AddressFieldComponent.dart';
import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/badgeComponent.dart';
import '../../../../framework/components/buy_ecm_button.dart';
import '../../../../framework/components/customInputField.dart';
import '../../../../framework/components/custonButton.dart';
import '../../../../framework/components/loader.dart' show ECMProgressIndicator;
import '../../viewmodel/wallet_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedBadge = 'AIRDROP';

  void _onBadgeTap(String badge) {
    setState(() {
      selectedBadge = badge;
    });
  }

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
      walletVM.init(context);

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
  void dispose() {
    ecmController.removeListener(_updatePayableAmount);
    ecmController.dispose();
    usdtController.dispose();
    readingMoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    // Dynamic multipliers
    final baseSize = isPortrait ? screenWidth : screenHeight;
    return Scaffold(

      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
       body: SafeArea(
         child: Container(
           width: screenWidth,
           height: screenHeight,
           decoration: BoxDecoration(
             // color: const Color(0xFF0B0A1E),
             // color: const Color(0xFF01090B),
             image: DecorationImage(
               // image: AssetImage('assets/icons/gradientBgImage.png'),
               image: AssetImage('assets/icons/starGradientBg.png'),
               fit: BoxFit.cover,
               alignment: Alignment.topRight,
             ),
           ),
           child: SingleChildScrollView(
             child: Padding(
               padding: EdgeInsets.symmetric(
                 horizontal: screenWidth * 0.01,
                 vertical: screenHeight * 0.02,
               ),
               child: Column(
                 children: [

                   ///MyCoinPoll & Connected Wallet Button
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [

                       Padding(
                         padding: EdgeInsets.only(
                             top: screenHeight * 0.01,
                             right: screenWidth * 0.02
                         ),
                         child: Image.asset(
                           'assets/icons/mycoinpolllogo.png',
                           width: screenWidth * 0.40,
                           height: screenHeight * 0.040,
                           fit: BoxFit.contain,
                         ),
                       ),

                       /// Connected Wallet Button
                       Padding(
                         padding: EdgeInsets.only(
                           top: screenHeight * 0.01,
                           right: screenWidth * 0.02,
                         ), // Padding to Button
                         child: Consumer<WalletViewModel>(
                             builder: (context, model, _){
                               return  BlockButton(
                                 height: screenHeight * 0.040,
                                 width: screenWidth * 0.4,
                                 label: model.isConnected ? 'Wallet Connected' : "Connect Wallet",
                                 textStyle:  TextStyle(
                                   fontWeight: FontWeight.w700,
                                   color: Colors.white,
                                   fontSize: baseSize * 0.030,
                                 ),
                                 gradientColors: const [
                                   Color(0xFF2680EF),
                                   Color(0xFF1CD494)
                                   // 1CD494
                                 ],
                                 // onTap: () async {
                                 //   try {
                                 //     await model.connectWallet(context);
                                 //   } catch (e) {
                                 //     if (context.mounted) {
                                 //       ScaffoldMessenger.of(context).showSnackBar(
                                 //         SnackBar(
                                 //           content: Text('Connection error: ${e.toString()}'),
                                 //           backgroundColor: Colors.red,
                                 //         ),
                                 //       );
                                 //     }
                                 //   }
                                 // },
                                 onTap: model.isLoading ? null : () { () async {
                                   try {
                                     await model.connectWallet(context);
                                   } catch (e) {
                                     if (context.mounted) {
                                       Utils.flushBarErrorMessage('Connection error', context);
                                     }
                                   }
                                 }();
                                 },

                               );
                             }
                         ),
                       ),
                     ],
                   ),
                   SizedBox(height: screenHeight * 0.03),
                   /// Apply For Lisign Button
                   Container(
                     width: screenWidth,
                     height: screenHeight * 0.16,
                     decoration: BoxDecoration(
                       border: Border.all(
                           color: Colors.transparent
                       ),
                       image:const DecorationImage(
                         image: AssetImage('assets/icons/applyForListingBG.png'),
                         fit: BoxFit.fill,
                       ),
                     ),

                     /// Apply For Lisign Button

                     child: Stack(
                         children: [
                           Container(
                             padding: EdgeInsets.symmetric(
                               horizontal: screenWidth * 0.035,
                               vertical: screenHeight * 0.015,
                             ),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   'Blockchain Innovation \nLaunchpad Hub',
                                   style: TextStyle(
                                     color: Color(0xFFFFF5ED),
                                     fontFamily: 'Poppins',
                                     fontSize: screenWidth * 0.04,
                                     fontWeight: FontWeight.w400,
                                   ),
                                   maxLines: 2,
                                 ),
                                 // SizedBox(height: screenHeight * 0.01), // Make this smaller the Space)

                                 /// Apply For Lising Button
                                 Padding(
                                   padding:  EdgeInsets.only(left: screenWidth * 0.010, top: screenHeight * 0.020),
                                   child: BlockButton(
                                     height: screenHeight * 0.05,
                                     width: screenWidth * 0.4,
                                     label: 'Apply For Listing',
                                     textStyle:  TextStyle(
                                       fontWeight: FontWeight.w700,
                                       color: Colors.white,
                                       fontSize: screenWidth * 0.030,
                                     ),
                                     gradientColors: const [
                                       Color(0xFF2680EF),
                                       Color(0xFF1CD494)
                                       // 1CD494
                                     ],
                                     onTap: () {
                                       print('Button tapped');
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => ApplyForListingScreen()),
                                       );

                                     },
                                     iconPath: 'assets/icons/arrowIcon.png',
                                     iconSize : screenHeight * 0.028,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           Align(
                             alignment: Alignment.centerRight,
                             child: Padding(
                               padding: EdgeInsets.only(left: screenWidth * 0.02),
                               child: Image.asset(
                                 'assets/icons/frame.png',
                                 width: screenWidth * 0.4,
                                 height: screenHeight * 0.4,
                                 fit: BoxFit.fitWidth,
                               ),
                             ),
                           ),
                         ]
                     ),
                   ),
                   SizedBox(height: screenHeight * 0.03),
                   _buildTokenCard(),
                   SizedBox(height: screenHeight * 0.05),
                   _buildBuyEcmSection(),
                 ],
               ),
             ),
           ),
         ),
      ),
    );
  }


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
          /// Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Running Tokens',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: baseSize * 0.045,
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: baseSize * 0.038,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          /// Token Card
          Container(
            width: screenWidth,
            // constraints: BoxConstraints(maxWidth: screenWidth * 0.95),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Color(0xff010219), Color(0xff050A7F)],
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
              padding: EdgeInsets.all(baseSize * 0.025),
              child: Column(
                children: [
                  /// Image and Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Token image with badges
                      Stack(
                        children: [

                          ClipPath(
                            clipper: DiagonalCornerClipper(),
                            child: Image.asset(
                              'assets/icons/tokens.png',
                              width: screenWidth * 0.4,
                              height: screenHeight * 0.15,
                              fit: BoxFit.fitWidth,
                            ),
                          ),

                          Positioned(
                            top: screenHeight * 0.01,
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.01,
                            child: Row(
                              children: [
                                BadgeComponent(
                                  text: 'AIRDROP',
                                  isSelected: selectedBadge == 'AIRDROP',
                                  onTap: () => _onBadgeTap('AIRDROP'),
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                BadgeComponent(
                                  text: 'INITIAL',
                                  isSelected: selectedBadge == 'INITIAL',
                                  onTap: () => _onBadgeTap('INITIAL'),
                                ),
                               ],
                            ),
                          ),

                        ],
                      ),
                      SizedBox(width: baseSize * 0.02),

                      /// Token details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'eCommerce Coin (ECM)',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: baseSize * 0.035,
                                color: Color(0xffFFF5ED),
                              ),
                            ),
                            SizedBox(height: baseSize * 0.01),
                            Text(
                              'Join the ECM Token ICO to revolutionize e-commerce with blockchain.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: baseSize * 0.028,
                                color: Color(0xffFFF5ED),
                              ),
                            ),
                            SizedBox(height: baseSize * 0.01),

                            /// Timer Section
                            Padding(
                              padding: EdgeInsets.all(baseSize * 0.01),
                              child: Container(
                                // width: double.infinity,
                                width: screenWidth,
                                padding: EdgeInsets.symmetric(
                                  // horizontal: baseSize * 0.01,
                                  // vertical: baseSize * 0.015,
                                  horizontal: baseSize * 0.02,
                                  vertical: baseSize * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0x4D1F1F1F),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 0.3,
                                    color: const Color(0x4DFFFFFF),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _timeBlock(label: 'Days', value: '02'),
                                      _timerColon(baseSize),
                                      _timeBlock(label: 'Hours', value: '23'),
                                      _timerColon(baseSize),
                                      _timeBlock(label: 'Minutes', value: '05'),
                                      _timerColon(baseSize),
                                      _timeBlock(label: 'Seconds', value: '56'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: baseSize * 0.025),

                  /// Supporters and Raised
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Supporter: 726',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: baseSize * 0.025,
                          color: Color(0xffFFF5ED),
                        ),
                      ),
                      SizedBox(height: baseSize * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Raised: 1.12%',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: baseSize * 0.025,
                              color: Color(0xffFFF5ED),
                            ),
                          ),
                          Text(
                            '1118527.50 / 10000000.00',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: baseSize * 0.025,
                              color: Color(0xffFFF5ED),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: baseSize * 0.02),

                  LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 2,
                    backgroundColor: Colors.white24,
                    color: Colors.cyanAccent,
                  ),
                  SizedBox(height: baseSize * 0.02),

                  /// Action Buttons
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: baseSize * 0.02),
                            _imageButton(
                              context,
                              'assets/icons/xIcon.svg',
                              () {
                                print('Image button tapped!');
                               },
                            ),
                            SizedBox(width: baseSize * 0.02),
                            _imageButton(
                              context,
                              'assets/icons/teleImage.svg',
                                  () {
                                print('Image button tapped!');
                              },
                            )
                          ],
                        ),
                        SizedBox(width: baseSize * 0.02),

                        BlockButton(
                          height: screenHeight * 0.045,
                          width: screenWidth * 0.35,
                          label: ' View Token',
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: baseSize * 0.030,
                          ),
                          gradientColors: const [
                            Color(0xFF2680EF),
                            Color(0xFF1CD494),
                          ],
                          onTap: () {
                            // Navigate
                            Navigator.of(context).push(
                               MaterialPageRoute(builder: (context) => ViewTokenScreen()),
                            );

                          },
                        ),
                      ],
                    ),
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
    final imageSize = screenWidth * 0.05; // 5% of screen width

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
  /// Countdown Widget
  Widget _timerColon(double baseSize) {
    return Baseline(
      baseline: baseSize * 0.01,
      baselineType: TextBaseline.alphabetic,
      child: Text(
        ":",
        style: TextStyle(
          fontSize: baseSize * 0.045,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
  Widget _timeBlock({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisAlignment: MainAxisAlignment.center,
       // mainAxisSize: MainAxisSize.min,
      children: [
        Container(
           padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 4),

          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            border: Border.all(color: const Color(0xFF2B2D40), width: 0.25),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              height: 0.2,
              letterSpacing: 0.16,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 8,
            height: 1.2,
            color: Colors.grey,
          ),
        ),
      ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Initial Coin Offering',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: baseSize * 0.045,
                  height: 1.2,
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
                           CustomLabeledInputField(
                             labelText: 'Referral Link:',
                             hintText: ' https://mycoinpoll.com?ref=125482458661',
                             controller: referredController,
                             isReadOnly: true,
                             trailingIconAsset: 'assets/icons/copyImg.svg',
                             onTrailingIconTap: () {
                               print('Trailing icon tapped');
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
                                    print('Error fetching stage info: ${e.toString()}');
                                    Utils.flushBarErrorMessage("We couldn't get the price details. Please connect your wallet and try again.", context);

                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(
                                    //     content: Text('Error fetching stage info: ${e.toString()}'),
                                    //     backgroundColor: Colors.red,
                                    //   ),
                                    // );
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
                                  print("Switched to USDT mode. USDT Price: $_usdtPrice");

                                } catch (e) {
                                  if (context.mounted) {
                                    print('Error fetching stage info: ${e.toString()}');

                                    Utils.flushBarErrorMessage("We couldn't get the price details. Please connect your wallet and try again.", context);

                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(
                                    //     content: Text('Error fetching stage info: ${e.toString()}'),
                                    //     backgroundColor: Colors.red,
                                    //   ),
                                    // );
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
                        print("ECM Purchase triggered");
                        try{
                          final inputEth = ecmController.text.trim();
                          print("User input: $inputEth");
                          final ethDouble = double.tryParse(inputEth);
                          print("Parsed double: $ethDouble");
                          if (ethDouble == null || ethDouble <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enter a valid ECM amount')),
                            );
                            return;
                          }

                          final ecmAmountInWeiETH = BigInt.from(ethDouble * 1e18);
                          // final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e16);
                          final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e6);
                          print("ETH in Wei: $ecmAmountInWeiETH");
                          print("USDT in smallest unit: $ecmAmountInWeiUSDT");

                          final isETH = isETHActive;
                          final amount = isETH ? ecmAmountInWeiETH : ecmAmountInWeiUSDT;
                          print("Calling ${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} with: $amount");
                          print("Purchase Button Pressed");

                          if (isETH) {
                            print("Calling buyECMWithETH with: $ecmAmountInWeiETH");
                            await walletVM.buyECMWithETH(EtherAmount.inWei(amount),context);
                          } else  {
                            print("Calling buyECMWithUSDT with: $ecmAmountInWeiUSDT");
                            await walletVM.buyECMWithUSDT(amount,context);
                          }
                          print("${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} completed");

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
                    //   DisconnectButton(
                    //     label: 'Disconnect',
                    //     color: Colors.redAccent,
                    //     icon: Icons.visibility_off_rounded,
                    //     onPressed: () async {
                    //       setState(() {
                    //         isDisconnecting = true;
                    //       });
                    //       try {
                    //         await walletVM.disconnectWallet(context);
                    //         walletVM.reset();
                    //         if (context.mounted && !walletVM.isConnected) {
                    //           Navigator.pushReplacementNamed(context, RoutesName.walletLogin);
                    //         }
                    //
                    //       } catch (e) {
                    //         if (context.mounted) {
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //             SnackBar(
                    //               content: Text('Error disconnecting: ${e.toString()}'),
                    //               backgroundColor: Colors.red,
                    //             ),
                    //           );
                    //         }
                    //       }finally{
                    //         if (mounted) {
                    //           setState(() {
                    //             isDisconnecting = false;
                    //           });
                    //         }
                    //       }
                    //     },
                    //
                    //   ),
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

class DiagonalCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double cutSize = 20;

    // Start from top left corner, move down a bit to cut the corner
    path.moveTo(0, cutSize);
    path.lineTo(cutSize, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cutSize);
    path.lineTo(size.width - cutSize, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
