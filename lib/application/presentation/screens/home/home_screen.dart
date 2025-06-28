import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/apply_for_listing_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/learn_earn_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/view_token_screen.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:mycoinpoll_metamask/framework/utils/general_utls.dart';
import 'package:provider/provider.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import '../../../../framework/components/AddressFieldComponent.dart';
import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/badgeComponent.dart';
import '../../../../framework/components/buy_ecm_button.dart';
import '../../../../framework/components/customInputField.dart';
import '../../../../framework/components/custonButton.dart';
import '../../../../framework/components/loader.dart' show ECMProgressIndicator;
import '../../../../framework/widgets/animated_blockchain_images.dart';
import '../../../data/services/api_service.dart';
import '../../countdown_timer_helper.dart';
import '../../models/token_model.dart';
import '../../viewmodel/wallet_view_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}
///Stable
// class _HomeScreenState extends State<HomeScreen> {
//   String selectedBadge = 'AIRDROP';
//
//   void _onBadgeTap(String badge) {
//     setState(() {
//       selectedBadge = badge;
//     });
//   }
//
//   final usdtController = TextEditingController();
//   final ecmController = TextEditingController();
//   final readingMoreController = TextEditingController();
//   final referredController = TextEditingController();
//   final String defaultReferrerAddress = '0x0000000000000000000000000000000000000000';
//
//   bool isETHActive = true;
//   bool isUSDTActive = false;
//
//   double _ethPrice = 0.0;
//   double _usdtPrice = 0.0;
//
//   int  _stageIndex = 0;
//   double _currentECM = 0.0;
//   double _maxECM = 0.0;
//   bool isDisconnecting = false;
//
//   Future<void> _fetchAndSetStageData() async {
//     if (!mounted) return;
//
//     final walletVM = Provider.of<WalletViewModel>(context, listen: false);
//
//     if (!walletVM.isConnected) {
//       print("Cannot fetch stage data: Wallet is not connected.");
//       return;
//     }
//
//     try {
//       final stageInfo = await walletVM.getCurrentStageInfo();
//
//       setState(() {
//         _stageIndex = stageInfo['stageIndex'];
//         _currentECM = (stageInfo['ecmSold'] as num).toDouble();
//         _maxECM = (stageInfo['target'] as num).toDouble();
//         _ethPrice = (stageInfo['ethPrice'] as num).toDouble();
//         _usdtPrice = (stageInfo['usdtPrice'] as num).toDouble();
//       });
//       _updatePayableAmount();
//     } catch (e,s) {
//       print('--- ERROR ON HOMESCREEN ---');
//       print('Exception details: ${e.toString()}');
//       print('Stack Trace: ${s.toString()}');
//       print('Error fetching stage data on HomeScreen: $e');
//       // if (mounted) {
//       //   Utils.flushBarErrorMessage("Could not load stage details. Please try again.", context);
//       // }
//     }
//   }
//   @override
//   void initState() {
//     super.initState();
//     ecmController.addListener(_updatePayableAmount);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final walletVM = Provider.of<WalletViewModel>(context, listen: false);
//
//       await walletVM.init(context);
//
//       if (walletVM.isConnected) {
//         print("Wallet already connected on start. Fetching data...");
//         await _fetchAndSetStageData();
//       }
//     });
//   }
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   ecmController.addListener(_updatePayableAmount);
//   //
//   //   WidgetsBinding.instance.addPostFrameCallback((_) async {
//   //     final walletVM = Provider.of<WalletViewModel>(context, listen: false);
//   //     walletVM.init(context);
//   //
//   //      try {
//   //       final stageInfo = await walletVM.getCurrentStageInfo();
//   //       final ethPrice = stageInfo['ethPrice'];
//   //       final usdtPrice = stageInfo['usdtPrice'];
//   //       final currentECM = stageInfo['ecmSold'];
//   //       final maxECM = stageInfo['target'];
//   //       final stageIndex = stageInfo['stageIndex'];
//   //
//   //       setState(() {
//   //         _stageIndex = stageIndex;
//   //         _currentECM = currentECM;
//   //         _maxECM = maxECM;
//   //         _ethPrice = ethPrice;
//   //         _usdtPrice = usdtPrice;
//   //
//   //       });
//   //     } catch (e) {
//   //       print('Error fetching chain data: $e');
//   //   //     if (mounted) {
//   //   //       Utils.flushBarErrorMessage("Please connect your wallet", context);
//   //   //
//   //   // }
//   //     }
//   //   });
//   // }
//
//
//
//   /// Helper function to fetch contract data and update the UI state.
//
//   void _updatePayableAmount() {
//     final ecmAmount = double.tryParse(ecmController.text) ?? 0.0;
//     double result = isETHActive ? ecmAmount * _ethPrice : ecmAmount * _usdtPrice;
//
//     // Display converted amount in the usdtController
//     usdtController.text =  isETHActive ? result.toStringAsFixed(5) : result.toStringAsFixed(1);
//
//   }
//
//   @override
//   void dispose() {
//     ecmController.removeListener(_updatePayableAmount);
//     ecmController.dispose();
//     usdtController.dispose();
//     readingMoreController.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     final isPortrait = screenHeight > screenWidth;
//
//     // Dynamic multipliers
//     final baseSize = isPortrait ? screenWidth : screenHeight;
//     return Scaffold(
//
//       extendBodyBehindAppBar: true,
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: Container(
//           width: screenWidth,
//           height: screenHeight,
//           decoration: const BoxDecoration(
//             // color: const Color(0xFF0B0A1E),
//             // color: const Color(0xFF01090B),
//             image: DecorationImage(
//               // image: AssetImage('assets/icons/gradientBgImage.png'),
//               image: AssetImage('assets/icons/starGradientBg.png'),
//               fit: BoxFit.cover,
//               alignment: Alignment.topRight,
//               filterQuality: FilterQuality.medium,
//
//             ),
//           ),
//           child: ScrollConfiguration(
//             behavior: const ScrollBehavior().copyWith(overscroll: false),
//
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: screenWidth * 0.01,
//                   vertical: screenHeight * 0.02,
//                 ),
//                 child: Column(
//                   children: [
//
//                     ///MyCoinPoll & Connected Wallet Button
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//                         Padding(
//                           padding: EdgeInsets.only(
//                               top: screenHeight * 0.01,
//                               right: screenWidth * 0.02
//                           ),
//                           child: Image.asset(
//                             'assets/icons/mycoinpolllogo.png',
//                             width: screenWidth * 0.40,
//                             height: screenHeight * 0.040,
//                             fit: BoxFit.contain,
//                             filterQuality: FilterQuality.medium,
//
//                           ),
//                         ),
//
//                         /// Connected Wallet Button
//                         Padding(
//                           padding: EdgeInsets.only(
//                             top: screenHeight * 0.01,
//                             right: screenWidth * 0.02,
//                           ), // Padding to Button
//                           child: Consumer<WalletViewModel>(
//                               builder: (context, model, _){
//                                 // if (model.isConnected) return SizedBox.shrink(); // Hide if connected
//
//                                 return  BlockButton(
//                                   height: screenHeight * 0.040,
//                                   width: screenWidth * 0.3,
//                                   label: model.isConnected ? 'Wallet Connected' : "Connect Wallet",
//                                   textStyle:  TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.white,
//                                     fontSize: getResponsiveFontSize(context, 12),
//                                   ),
//                                   gradientColors: const [
//                                     Color(0xFF2680EF),
//                                     Color(0xFF1CD494)
//                                     // 1CD494
//                                   ],
//                                   // onTap: model.isLoading ? null : () async {
//                                   //
//                                   //   if (model.isConnected) {
//                                   //      if (context.mounted) {
//                                   //       Navigator.push(
//                                   //         context,
//                                   //         MaterialPageRoute(builder: (context) => const DashboardBottomNavBar()),
//                                   //       );
//                                   //     }
//                                   //   } else {
//                                   //      try {
//                                   //       final connected = await model.connectWallet(context); // Await the boolean result from WalletViewModel
//                                   //       if (context.mounted && connected){ // Use the direct result for navigation
//                                   //         Navigator.push(
//                                   //           context,
//                                   //           MaterialPageRoute(builder: (context) => const DashboardBottomNavBar()),
//                                   //         );
//                                   //       } else if (context.mounted && !connected) {
//                                   //          Utils.flushBarErrorMessage('Connection failed or user cancelled.', context);
//                                   //       }
//                                   //     } catch (e) {
//                                   //       if (context.mounted) {
//                                   //         Utils.flushBarErrorMessage('Connection error: ${e.toString()}', context);
//                                   //       }
//                                   //     }
//                                   //   }
//                                   // },
//                                   // onTap: ()async{
//                                   //   await model.connectWallet(context);
//                                   //   if (context.mounted && model.isConnected) {
//                                   //     Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
//                                   //   }
//                                   // },
//
//                                   onTap: model.isLoading ? null : () async {
//                                     if (model.isConnected) {
//
//                                       await _fetchAndSetStageData();
//                                       if (context.mounted) {
//                                         Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
//                                       }
//                                     } else {
//                                       final connected = await model.connectWallet(context);
//                                       if (connected) {
//
//                                         print("Wallet connected successfully. Fetching data...");
//                                         await _fetchAndSetStageData();
//
//                                         if (context.mounted) {
//                                           Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
//                                         }
//                                       } else {
//                                         if (context.mounted) {
//                                           // Utils.flushBarErrorMessage('Connection failed or was cancelled.', context);
//                                         }
//                                       }
//                                     }
//                                   },
//
//
//                                 );
//                               }
//                           ),
//                         ),
//
//
//                       ],
//                     ),
//                     SizedBox(height: screenHeight * 0.03),
//                     /// Apply For Lisign Button
//                     Container(
//                       width: screenWidth,
//                       height: screenHeight * 0.16,
//                       // height: screenHeight * 0.30,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: Colors.transparent
//                         ),
//                         image:const DecorationImage(
//                           image: AssetImage('assets/icons/applyForListingBG.png'),
//                           fit: BoxFit.fill,
//                           filterQuality: FilterQuality.medium,
//                         ),
//                       ),
//
//                       /// Apply For Lisign Button
//
//                       child: Stack(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: screenWidth * 0.035,
//                                 vertical: screenHeight * 0.015,
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Blockchain Innovation \nLaunchpad Hub',
//                                     style: TextStyle(
//                                       color: const Color(0xFFFFF5ED),
//                                       fontFamily: 'Poppins',
//                                       // fontSize: screenWidth * 0.04,
//                                       fontSize: getResponsiveFontSize(context, 17),
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     maxLines: 2,
//                                   ),
//                                   // SizedBox(height: screenHeight * 0.01), // Make this smaller the Space)
//
//                                   /// Apply For Lising Button
//                                   Padding(
//                                     padding:  EdgeInsets.only(left: screenWidth * 0.010, top: screenHeight * 0.014),
//                                     child: BlockButton(
//                                       height: screenHeight * 0.05,
//                                       width: screenWidth * 0.4,
//                                       label: 'Apply For Listing',
//                                       textStyle:  TextStyle(
//                                         fontWeight: FontWeight.w700,
//                                         color: Colors.white,
//                                         // fontSize: screenWidth * 0.030,
//                                         fontSize: getResponsiveFontSize(context, 12),
//
//                                       ),
//                                       gradientColors: const [
//                                         Color(0xFF2680EF),
//                                         Color(0xFF1CD494)
//                                         // 1CD494
//                                       ],
//                                       onTap: () {
//                                         debugPrint('Button tapped');
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(builder: (context) => const ApplyForListingScreen()),
//                                         );
//
//                                       },
//                                       iconPath: 'assets/icons/arrowIcon.svg',
//                                       iconSize : screenHeight * 0.009,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: screenWidth * 0.02),
//                                 child: RepaintBoundary(
//                                   child: AnimatedBlockchainImages(
//                                     containerWidth: screenWidth * 0.4,
//                                     containerHeight: screenHeight * 0.4,
//                                     imageAssets: const [
//                                       'assets/icons/animatedImg1.png',
//                                       'assets/icons/animatedImg2.png',
//                                       'assets/icons/animatedImg3.png',
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ]
//                       ),
//                     ),
//                     SizedBox(height: screenHeight * 0.03),
//                     RepaintBoundary(child: _buildTokenCard()),
//                     SizedBox(height: screenHeight * 0.05),
//                     _buildBuyEcmSection(),
//
//                     SizedBox(height: screenHeight * 0.03),
//                     RepaintBoundary(child: _learnAndEarnContainer()),
//
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildTokenCard() {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     final isPortrait = screenHeight > screenWidth;
//     final baseSize = isPortrait ? screenWidth : screenHeight;
//
//     return Padding(
//       padding: const EdgeInsets.all(1.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Header Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Running Tokens',
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w500,
//                   // fontSize: baseSize * 0.045,
//                   fontSize: getResponsiveFontSize(context, 16),
//                   height: 1.2,
//                   color: Colors.white,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   'View All',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w400,
//                     // fontSize: baseSize * 0.038,
//                     fontSize: getResponsiveFontSize(context, 14),
//                     height: 1.2,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           /// Token Card
//           Container(
//             width: screenWidth,
//             decoration: BoxDecoration(
//               border: Border.all(
//                   color: Colors.transparent
//               ),
//               image:const DecorationImage(
//                 image: AssetImage('assets/icons/viewTokenFrameBg.png'),
//                 fit: BoxFit.fill,
//                 filterQuality: FilterQuality.medium,
//
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(baseSize * 0.025),
//               child: Column(
//                 children: [
//                   /// Image and Info
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// Token image with badges
//                       Stack(
//                         children: [
//
//                           Image.asset(
//                             'assets/icons/tokens.png',
//                             width: screenWidth * 0.4,
//                             height: screenHeight * 0.15,
//                             fit: BoxFit.fitWidth,
//                           ),
//
//                           Positioned(
//                             top: screenHeight * 0.01,
//                             left: screenWidth * 0.02,
//                             right: screenWidth * 0.01,
//                             child: Row(
//                               children: [
//                                 BadgeComponent(
//                                   text: 'AIRDROP',
//                                   isSelected: selectedBadge == 'AIRDROP',
//                                   onTap: () => _onBadgeTap('AIRDROP'),
//                                 ),
//                                 SizedBox(width: screenWidth * 0.01),
//                                 BadgeComponent(
//                                   text: 'INITIAL',
//                                   isSelected: selectedBadge == 'INITIAL',
//                                   onTap: () => _onBadgeTap('INITIAL'),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                         ],
//                       ),
//                       SizedBox(width: baseSize * 0.02),
//
//                       /// Token details
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'eCommerce Coin (ECM)',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: getResponsiveFontSize(context, 14),
//                                 color: const Color(0xffFFF5ED),
//                                 height: 1.6,
//                               ),
//                             ),
//                             SizedBox(height: baseSize * 0.02),
//                             Text(
//                               'Join the ECM Token ICO to revolutionize e-commerce with blockchain.',
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w400,
//                                 // fontSize: baseSize * 0.028,
//                                 fontSize: getResponsiveFontSize(context, 13),
//                                 color: const Color(0xffFFF5ED),
//                                 height: null,
//                               ),
//                             ),
//                             SizedBox(height: baseSize * 0.01),
//
//                             /// Timer Section
//                             Padding(
//                               padding: EdgeInsets.all(baseSize * 0.01),
//                               child: Container(
//                                 // width: double.infinity,
//                                 width: screenWidth,
//                                 padding: EdgeInsets.symmetric(
//                                   // horizontal: baseSize * 0.01,
//                                   // vertical: baseSize * 0.015,
//                                   horizontal: baseSize * 0.02,
//                                   vertical: baseSize * 0.015,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0x4D1F1F1F),
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(
//                                     width: 0.3,
//                                     color: const Color(0x4DFFFFFF),
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.2),
//                                       blurRadius: 10,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: IntrinsicHeight(
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       _timeBlock(label: 'Days', value: '02'),
//                                       _timerColon(baseSize),
//                                       _timeBlock(label: 'Hours', value: '23'),
//                                       _timerColon(baseSize),
//                                       _timeBlock(label: 'Minutes', value: '05'),
//                                       _timerColon(baseSize),
//                                       _timeBlock(label: 'Seconds', value: '56'),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: baseSize * 0.025),
//
//                   /// Supporters and Raised
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Supporter: 726',
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w400,
//                           // fontSize: baseSize * 0.025,
//                           fontSize: getResponsiveFontSize(context, 12),
//                           color: const Color(0xffFFF5ED),
//                           height : 1.6,
//
//                         ),
//                       ),
//                       SizedBox(height: baseSize * 0.01),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Raised: 1.12%',
//                             style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.w400,
//                               // fontSize: baseSize * 0.025,
//                               fontSize: getResponsiveFontSize(context, 12),
//
//                               color: const Color(0xffFFF5ED),
//                               height : 1.6,
//
//                             ),
//                           ),
//                           Text(
//                             '1118527.50 / 10000000.00',
//                             style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.w400,
//                               // fontSize: baseSize * 0.025,
//                               fontSize: getResponsiveFontSize(context, 12),
//
//                               color: const Color(0xffFFF5ED),
//                               height : 1.6,
//
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: baseSize * 0.02),
//
//                   const LinearProgressIndicator(
//                     value: 0.5,
//                     minHeight: 2,
//                     backgroundColor: Colors.white24,
//                     color: Colors.cyanAccent,
//                   ),
//                   SizedBox(height: baseSize * 0.02),
//
//                   /// Action Buttons
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       // mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(width: baseSize * 0.02),
//                             _imageButton(
//                               context,
//                               'assets/icons/xIcon.svg',
//                                   () {
//                                 debugPrint('Image button tapped!');
//                               },
//                             ),
//                             SizedBox(width: baseSize * 0.02),
//                             _imageButton(
//                               context,
//                               'assets/icons/teleImage.svg',
//                                   () {
//                                 debugPrint('Image button tapped!');
//                               },
//                             )
//                           ],
//                         ),
//                         SizedBox(width: baseSize * 0.02),
//
//                         BlockButton(
//                           height: screenHeight * 0.045,
//                           width: screenWidth * 0.35,
//                           label: ' View Token',
//                           textStyle: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                             // fontSize: baseSize * 0.030,
//                             fontSize: getResponsiveFontSize(context, 12),
//
//                           ),
//                           gradientColors: const [
//                             Color(0xFF2680EF),
//                             Color(0xFF1CD494),
//                           ],
//                           onTap: () {
//                             // Navigate
//                             Navigator.of(context).push(
//                               MaterialPageRoute(builder: (context) => const ViewTokenScreen()),
//                             );
//
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(height: baseSize * 0.02),
//
//
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// _imageButton Widget
//   Widget _imageButton(BuildContext context, String imagePath, VoidCallback onTap) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final imageSize = screenWidth * 0.05; // 5% of screen width
//
//     final isSvg = imagePath.toLowerCase().endsWith('.svg');
//
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white12,
//           borderRadius: BorderRadius.circular(6),
//         ),
//         padding: const EdgeInsets.all(8),
//         child: isSvg
//             ? SvgPicture.asset(
//           imagePath,
//           width: imageSize,
//           height: imageSize,
//           color: Colors.white,
//         )
//             : Image.asset(
//           imagePath,
//           width: imageSize,
//           height: imageSize,
//           color: Colors.white,
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
//   /// Countdown Widget
//   Widget _timerColon(double baseSize) {
//     return Baseline(
//       baseline: baseSize * 0.01,
//       baselineType: TextBaseline.alphabetic,
//       child: Text(
//         ":",
//         style: TextStyle(
//           fontSize: baseSize * 0.045,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
//   Widget _timeBlock({required String label, required String value}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       // mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 4),
//
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.2),
//             border: Border.all(color: const Color(0xFF2B2D40), width: 0.25),
//             borderRadius: BorderRadius.circular(2),
//           ),
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w500,
//               fontSize: 18,
//               height: 0.2,
//               letterSpacing: 0.16,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         const SizedBox(height: 1),
//         Text(
//           label,
//           style: const TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w400,
//             fontSize: 8,
//             height: 1.2,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }
//
//
//   /// Buy ECM Section
//   Widget _buildBuyEcmSection() {
//     final Size screenSize = MediaQuery.of(context).size;
//
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final bool isPortrait = screenSize.height > screenSize.width;
//     final double textScale = isPortrait ? screenWidth / 400 : screenHeight / 400;
//     final double paddingScale = screenWidth * 0.04;
//     final baseSize = isPortrait ? screenWidth : screenHeight;
//     return  Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Initial Coin Offering',
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w500,
//                   // fontSize: baseSize * 0.045,
//                   fontSize: getResponsiveFontSize(context, 16),
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: screenHeight * 0.02),
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               width: screenWidth,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                     color: Colors.transparent
//                 ),
//                 image:const DecorationImage(
//                   image: AssetImage('assets/icons/buyEcmContainerImage.png'),
//                   fit: BoxFit.fill,
//                   filterQuality: FilterQuality.medium,
//                 ),
//               ),
//               child: Consumer<WalletViewModel>(builder: (context, walletVM, child) {
//
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // const SizedBox(height: 9),
//                     const SizedBox(height: 18),
//
//                     // Stage &  MAx Section
//                     ECMProgressIndicator(
//                       stageIndex: _stageIndex,
//                       currentECM: _currentECM,
//                       maxECM: _maxECM,
//                     ),
//
//
//                     SizedBox(
//                       width: screenWidth * 0.9,
//                       child: const Divider(
//                         color: Colors.white12,
//                         thickness: 1,
//                         height: 20,
//                       ),
//                     ),
//                     /// Address Section
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
//                           CustomLabeledInputField(
//                             labelText: 'Your Address:',
//                             hintText: walletVM.walletAddress,
//                             controller: readingMoreController,
//                             isReadOnly: true,
//                           ),
//                           SizedBox(height: screenHeight * 0.02),
//                           CustomLabeledInputField(
//                             labelText: 'Referral Link:',
//                             hintText: ' https://mycoinpoll.com?ref=125482458661',
//                             controller: referredController,
//                             isReadOnly: true,
//                             trailingIconAsset: 'assets/icons/copyImg.svg',
//                             onTrailingIconTap: () {
//                               debugPrint('Trailing icon tapped');
//                             },
//                           ),
//                           SizedBox(height: screenHeight * 0.02),
//                           // if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
//                           CustomLabeledInputField(
//                             labelText: 'Referred By:',
//                             hintText: 'Show and Enter Referred id..',
//                             controller: referredController,
//                             isReadOnly:
//                             false, // or false
//                           ),
//
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: screenWidth * 0.9,
//                       child: const Divider(
//                         color: Colors.white12,
//                         thickness: 1,
//                         height: 20,
//                       ),
//                     ),
//
//                     ///Action Buttons
//                     Padding(
//                       padding: const EdgeInsets.symmetric( horizontal: 18.0 , vertical: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           //Buy with ETH Button
//                           Expanded(
//                             child: CustomButton(
//                               text: 'Buy with ETH',
//                               icon: 'assets/icons/eth.png',
//                               isActive: isETHActive,
//                               onPressed: () {
//                                 if (isETHActive) return;
//                                 setState(() {
//                                   isETHActive = true;
//                                   isUSDTActive = false;
//                                 });
//                                 _updatePayableAmount();
//                               },
//                               // onPressed: ()async {
//                               //   try {
//                               //     final stageInfo = await walletVM.getCurrentStageInfo();
//                               //     final ethPrice = stageInfo['ethPrice'];
//                               //
//                               //     setState(() {
//                               //       _ethPrice = ethPrice;
//                               //       isETHActive = true;
//                               //       isUSDTActive = false;
//                               //
//                               //     });
//                               //     _updatePayableAmount();
//                               //
//                               //   } catch (e) {
//                               //
//                               //     if (context.mounted) {
//                               //       debugPrint('Error fetching stage info: ${e.toString()}');
//                               //       Utils.flushBarErrorMessage("We couldn't get the price details. Please connect your wallet and try again.", context);
//                               //
//                               //     }
//                               //   }
//                               //
//                               // },
//
//
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           //Buy with USDT Button
//                           Expanded(
//                             child:
//                             CustomButton(
//                               text: 'Buy with USDT',
//                               icon: 'assets/icons/usdt.png',
//                               isActive: isUSDTActive,
//                               onPressed: () {
//                                 if (isUSDTActive) return;
//                                 setState(() {
//                                   isUSDTActive = true;
//                                   isETHActive = false;
//                                 });
//                                 _updatePayableAmount();
//                               },
//                               // onPressed: ()async {
//                               //   try {
//                               //     final stageInfo = await walletVM.getCurrentStageInfo(); // Get the stage info
//                               //     final usdtPrice = stageInfo['usdtPrice'];
//                               //
//                               //     setState(() {
//                               //       _usdtPrice = usdtPrice;
//                               //       isUSDTActive = true;
//                               //       isETHActive = false;
//                               //     });
//                               //     _updatePayableAmount();
//                               //     debugPrint("Switched to USDT mode. USDT Price: $_usdtPrice");
//                               //
//                               //   } catch (e) {
//                               //     if (context.mounted) {
//                               //       debugPrint('Error fetching stage info: ${e.toString()}');
//                               //
//                               //       Utils.flushBarErrorMessage("We couldn't get the price details. Please connect your wallet and try again.", context);
//                               //
//                               //     }
//                               //   }
//                               //
//                               // },
//
//
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//
//                     Text(
//                       isETHActive
//                       // ? "1 ECM = ${_ethPrice > 0 ? _ethPrice.toStringAsFixed(5) : '...'} ETH"
//                       // : "1 ECM = ${_usdtPrice > 0 ? _usdtPrice.toStringAsFixed(1) : '...'} USDT",
//                           ? "1 ECM = ${_ethPrice.toStringAsFixed(5)} ETH"
//                           : "1 ECM = ${_usdtPrice.toStringAsFixed(1)} USDT",
//
//                       style:  TextStyle(
//                         color: Colors.white,
//                         // fontSize: screenWidth * 0.032,
//                         fontSize: getResponsiveFontSize(context, 13),
//                         fontWeight: FontWeight.w400,
//                         fontFamily: 'Poppins',
//                         height: 1.6,
//                       ),
//                     ),
//
//                     const SizedBox(height: 18),
//
//
//                     /// ECm AMount INput Section
//                     CustomInputField(
//                       hintText: 'ECM',
//                       iconAssetPath: 'assets/icons/ecm.png',
//                       controller: ecmController,
//                     ),
//                     const SizedBox(height: 12),
//                     CustomInputField(
//                       hintText: isETHActive ? 'ETH ' : 'USDT ',
//                       iconAssetPath: isETHActive ? 'assets/icons/eth.png' : 'assets/icons/usdt.png',
//                       controller: usdtController,
//
//                     ),
//
//                     const SizedBox(height: 18),
//                     CustomGradientButton(
//                       label: 'Buy ECM',
//                       width: MediaQuery.of(context).size.width * 0.7,
//                       height: MediaQuery.of(context).size.height * 0.05,
//                       leadingImagePath: 'assets/icons/buyEcmLeadingImg.svg',
//                       onTap: () async {
//                         debugPrint("ECM Purchase triggered");
//                         try{
//                           final inputEth = ecmController.text.trim();
//                           debugPrint("User input: $inputEth");
//                           final ethDouble = double.tryParse(inputEth);
//                           debugPrint("Parsed double: $ethDouble");
//                           if (ethDouble == null || ethDouble <= 0) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Enter a valid ECM amount')),
//                             );
//                             return;
//                           }
//
//                           final ecmAmountInWeiETH = BigInt.from(ethDouble * 1e18);
//                           // final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e16);
//                           final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e6);
//                           debugPrint("ETH in Wei: $ecmAmountInWeiETH");
//                           debugPrint("USDT in smallest unit: $ecmAmountInWeiUSDT");
//
//                           final isETH = isETHActive;
//                           final amount = isETH ? ecmAmountInWeiETH : ecmAmountInWeiUSDT;
//                           debugPrint("Calling ${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} with: $amount");
//                           debugPrint("Purchase Button Pressed");
//
//                           if (isETH) {
//                             debugPrint("Calling buyECMWithETH with: $ecmAmountInWeiETH");
//                             await walletVM.buyECMWithETH(EtherAmount.inWei(amount),context);
//                           } else  {
//                             debugPrint("Calling buyECMWithUSDT with: $ecmAmountInWeiUSDT");
//                             await walletVM.buyECMWithUSDT(amount,context);
//                             // await walletVM.buyECMWithUSDT(EtherAmount.inWei(amount),context);
//                           }
//                           debugPrint("${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} completed");
//
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('Purchase successful')),
//                           );
//                         }catch (e) {
//                           debugPrint("Buy ECM failed: $e");
//                         }
//                       },
//                       gradientColors: const [
//                         Color(0xFF2D8EFF),
//                         Color(0xFF2EE4A4)
//                       ],
//                     ),
//                     const SizedBox(height: 18),
//
//
//                   ],
//                 );
//               }
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _learnAndEarnContainer(){
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     final isPortrait = screenHeight > screenWidth;
//     final baseSize = isPortrait ? screenWidth : screenHeight;
//
//     return Container(
//       width: screenWidth,
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/icons/learnAndEarnFrame.png'),
//           fit: BoxFit.fill,
//           filterQuality: FilterQuality.medium,
//
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           vertical: baseSize * 0.02,
//           horizontal: baseSize * 0.02,
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               width: screenWidth * 0.28,
//               height: screenHeight * 0.14,
//               child: Image.asset('assets/icons/learnAndEarnImg.png',fit: BoxFit.fill,filterQuality: FilterQuality.medium,
//               ),
//             ),
//
//             // Right Side: Text and Button
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   vertical: baseSize * 0.015,
//                   horizontal: baseSize * 0.02,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: <Widget>[
//                     AutoSizeText(
//                       'Earn Crypto While You Learn',
//                       textAlign: TextAlign.right,
//
//                       style: TextStyle(
//                         color: const Color(0XFFFFF5ED),
//                         // fontSize: baseSize * 0.040,
//                         fontSize: getResponsiveFontSize(context, 14),
//                         fontWeight: FontWeight.w500,
//                         height: 1.3,
//
//                       ),
//                     ),
//                     SizedBox(height: baseSize * 0.01),
//                     AutoSizeText(
//                       'Boost your crypto knowledge and earn free tokens by learning blockchain basics.',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                         color: const Color(0XFFFFF5ED),
//                         // fontSize: baseSize * 0.030,
//                         fontSize: getResponsiveFontSize(context, 12),
//                         fontWeight: FontWeight.w400,
//                         height: 1.6,
//                       ),
//                     ),
//                     SizedBox(height: baseSize * 0.03),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: BlockButton(
//                         height: baseSize * 0.10,
//                         width: screenWidth * 0.4,
//                         label: "Get Started",
//                         textStyle: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                           fontSize: baseSize * 0.030,
//                         ),
//                         gradientColors: const [
//                           Color(0xFF2680EF),
//                           Color(0xFF1CD494),
//                         ],
//                         onTap: () {
//                           debugPrint('Button tapped');
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => const LearnEarnScreen()),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }

/// Beta V6
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
  bool isDisconnecting = false;

  List<TokenModel> tokens = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTokens();
    ecmController.addListener(_updatePayableAmount);
     WidgetsBinding.instance.addPostFrameCallback((_) async {
       final walletVM = Provider.of<WalletViewModel>(context, listen: false);
       // await walletVM.forceReinitModal(context);

       final prefs = await SharedPreferences.getInstance();
       final wasConnected = prefs.getBool('isConnected') ?? false;
       print("WalletViewModel.isConnected: ${walletVM.isConnected}, SharedPref: $wasConnected");


       // if (!walletVM.isConnected && wasConnected && walletVM.appKitModal==null) {
       if (!walletVM.isConnected && wasConnected) {
         debugPrint("Attempting silent reconnect...");
         await walletVM.init(context);
       }

       await _initializeWalletData();

    });
  }
  Future<void> fetchTokens() async {
    try {
      final response = await ApiService().fetchTokens();
      setState(() {
        tokens = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tokens: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _initializeWalletData() async {
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    // Step 1: Ensure the wallet modal is initialized
    if (walletVM.appKitModal == null) {
      debugPrint("AppKitModal is null. Initializing...");
      await walletVM.init(context);
    }

    // Step 2: Check if user was previously connected (using shared prefs)
    final prefs = await SharedPreferences.getInstance();
    final wasConnected = prefs.getBool('isConnected') ?? false;
    debugPrint("wasConnected (from prefs): $wasConnected");
    debugPrint("walletVM.isConnected: ${walletVM.isConnected}");

    // Step 3: Reconnect silently if needed
    if (!walletVM.isConnected && wasConnected) {
      debugPrint("Attempting silent reconnect...");
      try {
        await walletVM.fetchConnectedWalletData(isReconnecting: true);
        await walletVM.getCurrentStageInfo();
        _updatePayableAmount();
      } catch (e) {
        debugPrint("Silent reconnect failed: $e");
      }
      return;
    }

    // Step 4: If already connected, fetch wallet info and stage data
    if (walletVM.isConnected) {
      try {
        await walletVM.fetchConnectedWalletData();
        await walletVM.getCurrentStageInfo();
        _updatePayableAmount();
      } catch (e) {
        debugPrint("Error fetching wallet data after connection: $e");
        if (mounted) {
          Utils.flushBarErrorMessage("Failed to fetch wallet data or stage info", context);
        }
      }
    } else {
      await walletVM.getCurrentStageInfo();
      debugPrint("Wallet is not connected. Skipping wallet data fetch.");
    }
  }


  /// Helper function to fetch contract data and update the UI state.

  void _updatePayableAmount() {
    final ecmAmount = double.tryParse(ecmController.text) ?? 0.0;
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    double result = isETHActive ? ecmAmount * walletVM.ethPrice : ecmAmount * walletVM.usdtPrice;
    // double result = isETHActive ? ecmAmount * _ethPrice : ecmAmount * _usdtPrice;

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
    bool canOpenModal = false;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(

            image: DecorationImage(
               image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
              filterQuality: FilterQuality.medium,

            ),
          ),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

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
                            filterQuality: FilterQuality.medium,

                          ),
                        ),

                        /// Connected Wallet Button
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenHeight * 0.01,
                            right: screenWidth * 0.02,
                          ),
                          child: Consumer<WalletViewModel>(
                              builder: (context, walletVM, _){
                                if (walletVM.isLoading) {
                                   return SizedBox(
                                    height: screenHeight * 0.040,
                                    width: screenWidth * 0.3,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  );
                                }
                                 return  BlockButton(
                                  height: screenHeight * 0.040,
                                  width: screenWidth * 0.3,
                                  label: walletVM.isConnected ? 'Wallet Connected' : "Connect Wallet",
                                  textStyle:  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: getResponsiveFontSize(context, 12),
                                  ),
                                  gradientColors: const [
                                    Color(0xFF2680EF),
                                    Color(0xFF1CD494)
                                  ],
                                    onTap: walletVM.isLoading ? null : () async {
                                     try {
                                       if (!walletVM.isConnected) {
                                         await walletVM.connectWallet(context);
                                       } else {
                                         if (walletVM.appKitModal != null) {
                                           try {
                                             canOpenModal = walletVM.appKitModal!.selectedChain != null;
                                           } catch (e) {
                                             debugPrint("Error accessing selectedChain: $e");
                                             canOpenModal = false;
                                           }

                                           if (!canOpenModal) {
                                             Utils.flushBarErrorMessage("Wallet network not selected or invalid. Please reconnect your wallet.", context);
                                             await walletVM.connectWallet(context);
                                             return;
                                           }

                                           await walletVM.ensureModalWithValidContext(context);
                                           await Future.delayed(const Duration(milliseconds: 200));
                                           await walletVM.appKitModal!.openModalView();
                                         } else {
                                           Utils.flushBarErrorMessage("Wallet modal not ready", context);
                                         }
                                       }
                                     } catch (e, stack) {
                                       debugPrint('Wallet Error: $e\n$stack');
                                       if (context.mounted) {
                                         Utils.flushBarErrorMessage("Error: ${e.toString()}", context);
                                       }
                                     }
                                   },

                                 );}
                          ),


                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    /// Apply For Lisign Button


                    Container(
                      width: screenWidth,
                      // height: screenHeight * 0.16,
                      height: screenHeight * 0.17,
                      // height: screenHeight * 0.30,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.transparent
                        ),
                        image:const DecorationImage(
                          image: AssetImage('assets/icons/applyForListingBG.png'),
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.medium,
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
                                      color: const Color(0xFFFFF5ED),
                                      fontFamily: 'Poppins',
                                      // fontSize: screenWidth * 0.04,
                                      fontSize: getResponsiveFontSize(context, 17),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                  ),
                                  // SizedBox(height: screenHeight * 0.01), // Make this smaller the Space)

                                  /// Apply For Lising Button
                                  Padding(
                                    padding:  EdgeInsets.only(left: screenWidth * 0.010, top: screenHeight * 0.014),
                                    child: BlockButton(
                                      height: screenHeight * 0.05,
                                      width: screenWidth * 0.4,
                                      label: 'Apply For Listing',
                                      textStyle:  TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        // fontSize: screenWidth * 0.030,
                                        fontSize: getResponsiveFontSize(context, 12),

                                      ),
                                      gradientColors: const [
                                        Color(0xFF2680EF),
                                        Color(0xFF1CD494)
                                        // 1CD494
                                      ],
                                      onTap: () {
                                        debugPrint('Button tapped');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const ApplyForListingScreen()),
                                        );

                                      },
                                      iconPath: 'assets/icons/arrowIcon.svg',
                                      iconSize : screenHeight * 0.009,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(left: screenWidth * 0.02),
                                child: RepaintBoundary(
                                  child: AnimatedBlockchainImages(
                                    containerWidth: screenWidth * 0.4,
                                    containerHeight: screenHeight * 0.4,
                                    imageAssets: const [
                                      'assets/icons/animatedImg1.png',
                                      'assets/icons/animatedImg2.png',
                                      'assets/icons/animatedImg3.png',
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // _buildTokenCard(),
                    ...tokens.map((token) => _buildTokenCard(context, token)).toList(),

                    SizedBox(height: screenHeight * 0.05),

                    _buildBuyEcmSection(),


                    SizedBox(height: screenHeight * 0.03),

                    RepaintBoundary(child: _learnAndEarnContainer()),


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTokenCard(BuildContext context, TokenModel token) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    const baseWidth = 375.0;
    const baseHeight = 812.0;
    double scaleWidth(double size) => size * screenWidth / baseWidth;
    double scaleHeight(double size) => size * screenHeight / baseHeight;
    double scaleText(double size) => size * screenWidth / baseWidth;


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
                  // fontSize: baseSize * 0.045,
                  fontSize: getResponsiveFontSize(context, 16),
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ViewTokenScreen()),
                  );

                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    // fontSize: baseSize * 0.038,
                    fontSize: getResponsiveFontSize(context, 14),
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
                          // Image.asset(
                          //   'assets/icons/tokens.png',
                          //   width: screenWidth * 0.4,
                          //   height: screenHeight * 0.15,
                          //   fit: BoxFit.fitWidth,
                          //   filterQuality: FilterQuality.high,
                          // ),
                          Image.network(
                            token.featureImage,
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.15,
                            fit: BoxFit.cover,
                          ),

                          Positioned(
                            top: screenHeight * 0.01,
                            left: screenWidth * 0.02,
                            right: screenWidth * 0.01,
                            child: Row(
                              children: token.tags.map((tag) {
                                final normalizedTag = tag.toUpperCase();
                                return Padding(
                                  padding: EdgeInsets.only(right: screenWidth * 0.01),
                                  child: BadgeComponent(
                                    text: normalizedTag,
                                    isSelected: selectedBadge == normalizedTag,
                                    onTap: () => _onBadgeTap(normalizedTag),
                                  ),
                                );
                              }).toList(),
                              // children: [
                              //   BadgeComponent(
                              //     text: 'AIRDROP',
                              //     isSelected: selectedBadge == 'AIRDROP',
                              //     onTap: () => _onBadgeTap('AIRDROP'),
                              //   ),
                              //   SizedBox(width: screenWidth * 0.01),
                              //   BadgeComponent(
                              //     text: 'INITIAL',
                              //     isSelected: selectedBadge == 'INITIAL',
                              //     onTap: () => _onBadgeTap('INITIAL'),
                              //   ),
                              // ],
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
                              // 'eCommerce Coin (ECM)',
                              token.fullName,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: getResponsiveFontSize(context, 14),
                                color: const Color(0xffFFF5ED),
                                height: 1.6,
                              ),
                            ),
                            SizedBox(height: baseSize * 0.02),
                            Text(
                              token.shortDescription,
                               style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                // fontSize: baseSize * 0.028,
                                fontSize: getResponsiveFontSize(context, 13),
                                color: const Color(0xffFFF5ED),
                                height: null,
                              ),
                            ),
                            SizedBox(height: baseSize * 0.01),


                            /// Timer Section
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal:baseSize * 0.02, vertical: baseSize * 0.01),
                              child: CountdownTimer(
                                scaleWidth: scaleWidth,
                                scaleHeight: scaleHeight,
                                scaleText: scaleText,
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
                         'Supporters: ${token.supporter}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          // fontSize: baseSize * 0.025,
                          fontSize: getResponsiveFontSize(context, 12),
                          color: const Color(0xffFFF5ED),
                          height : 1.6,

                        ),
                      ),
                      SizedBox(height: baseSize * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Raised: ${token.sellPercentage.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              // fontSize: baseSize * 0.025,
                              fontSize: getResponsiveFontSize(context, 12),

                              color: const Color(0xffFFF5ED),
                              height : 1.6,

                            ),
                          ),
                          Text(
                            // '1118527.50 / 10000000.00',
                            '${token.alreadySell} / ${token.sellTarget}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              // fontSize: baseSize * 0.025,
                              fontSize: getResponsiveFontSize(context, 12),

                              color: const Color(0xffFFF5ED),
                              height : 1.6,

                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: baseSize * 0.02),

                  LinearProgressIndicator(
                    // value: 0.5,
                    value: token.sellPercentage / 100,
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
                            if (token.socialMedia?.twitter != null && token.socialMedia!.twitter!.isNotEmpty)
                              _imageButton(
                              context,
                              'assets/icons/xIcon.svg',
                                token.socialMedia!.twitter!,

                              ),
                            SizedBox(width: baseSize * 0.02),
                            if (token.socialMedia?.telegram != null && token.socialMedia!.telegram!.isNotEmpty)
                              _imageButton(
                              context,
                              'assets/icons/teleImage.svg',
                                token.socialMedia!.telegram!,
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
                            // fontSize: baseSize * 0.030,
                            fontSize: getResponsiveFontSize(context, 12),

                          ),
                          gradientColors: const [
                            Color(0xFF2680EF),
                            Color(0xFF1CD494),
                          ],
                          onTap: () {
                            // Navigate
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const ViewTokenScreen()),
                            );

                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: baseSize * 0.02),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// _imageButton Widget
  Widget _imageButton(BuildContext context, String imagePath, String url) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.05; // 5% of screen width

    final isSvg = imagePath.toLowerCase().endsWith('.svg');

    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open the link')),
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
                  // image: AssetImage('assets/icons/buyEcmContainerImage.png'),
                  image: AssetImage('assets/icons/buyEcmContainerImageV.png'),
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.medium,
                ),
              ),
              child: Consumer<WalletViewModel>(builder: (context, walletVM, child) {

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 9),
                    const SizedBox(height: 18),

                    ECMProgressIndicator(
                      stageIndex: walletVM.stageIndex,
                      currentECM: walletVM.currentECM,
                      maxECM:  walletVM.maxECM,
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
                              // hintText: walletVM.walletAddress,
                              hintText: walletVM.isConnected && walletVM.walletAddress.isNotEmpty
                                  ? walletVM.walletAddress
                                  : 'Not connected',
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
                                Clipboard.setData(const ClipboardData(text:'https://mycoinpoll.com?ref=125482458661'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('TxnHash copied to clipboard'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            CustomLabeledInputField(
                              labelText: 'Referred By:',
                              hintText: '0x0000000000000000000000000000000000000000',
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
                              onPressed: () {
                                if (isETHActive) return;
                                setState(() {
                                  isETHActive = true;
                                  isUSDTActive = false;
                                });
                                _updatePayableAmount();
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
                              onPressed: () {
                                if (isUSDTActive) return;
                                setState(() {
                                  isUSDTActive = true;
                                  isETHActive = false;
                                });
                                _updatePayableAmount();
                              },



                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),

                    Text(
                      isETHActive
                          ? "1 ECM = ${walletVM.ethPrice.toStringAsFixed(5)} ETH"
                          : "1 ECM = ${walletVM.usdtPrice.toStringAsFixed(1)} USDT",
                      // ? "1 ECM = ${_ethPrice.toStringAsFixed(5)} ETH"
                      // : "1 ECM = ${_usdtPrice.toStringAsFixed(1)} USDT",

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
                        debugPrint("ECM Purchase triggered");
                        try{
                          final inputEth = ecmController.text.trim();
                          debugPrint("User input: $inputEth");
                          final ethDouble = double.tryParse(inputEth);
                          debugPrint("Parsed double: $ethDouble");
                          if (ethDouble == null || ethDouble <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter a valid ECM amount')),
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
                            // await walletVM.buyECMWithUSDT(EtherAmount.inWei(amount),context);
                          }
                          debugPrint("${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} completed");

                        }catch (e) {
                          debugPrint("Buy ECM failed: $e");
                          Fluttertoast.showToast(
                            msg: "Wallet not Connected",
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                      gradientColors: const [
                        Color(0xFF2D8EFF),
                        Color(0xFF2EE4A4)
                      ],
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

  Widget _learnAndEarnContainer(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Container(
      width: screenWidth,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/learnAndEarnFrame.png'),
          fit: BoxFit.fill,
          filterQuality: FilterQuality.medium,

        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: baseSize * 0.02,
          horizontal: baseSize * 0.02,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: screenWidth * 0.28,
              height: screenHeight * 0.14,
              child: Image.asset('assets/icons/learnAndEarnImg.png',fit: BoxFit.fill,filterQuality: FilterQuality.medium,
              ),
            ),

            // Right Side: Text and Button
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: baseSize * 0.015,
                  horizontal: baseSize * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    AutoSizeText(
                      'Earn Crypto While You Learn',
                      textAlign: TextAlign.right,

                      style: TextStyle(
                        color: const Color(0XFFFFF5ED),
                        // fontSize: baseSize * 0.040,
                        fontSize: getResponsiveFontSize(context, 14),
                        fontWeight: FontWeight.w500,
                        height: 1.3,

                      ),
                    ),
                    SizedBox(height: baseSize * 0.01),
                    AutoSizeText(
                      'Boost your crypto knowledge and earn free tokens by learning blockchain basics.',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0XFFFFF5ED),
                        // fontSize: baseSize * 0.030,
                        fontSize: getResponsiveFontSize(context, 12),
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: baseSize * 0.03),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlockButton(
                        height: baseSize * 0.10,
                        width: screenWidth * 0.4,
                        label: "Get Started",
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
                          debugPrint('Button tapped');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LearnEarnScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
