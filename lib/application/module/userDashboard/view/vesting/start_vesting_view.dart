// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//  import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../../framework/components/AddressFieldComponent.dart';
// import '../../../../../framework/components/BlockButton.dart';
// import '../../../../../framework/components/ListingFields.dart';
// import '../../../../../framework/components/VestingContainer.dart';
// import '../../../../../framework/components/VestingSummaryRow.dart';
// import '../../../../../framework/components/buy_Ecm.dart';
// import '../../../../../framework/components/claimHistoryCard.dart';
// import '../../../../../framework/components/loader.dart';
// import '../../../../../framework/components/vestingDetailRow.dart';
// import '../../../../../framework/utils/customToastMessage.dart';
// import '../../../../../framework/utils/dynamicFontSize.dart';
// import '../../../../../framework/utils/enums/toast_type.dart';
// import '../../../../data/services/api_service.dart';
// import '../../../../presentation/countdown_timer_helper.dart';
// import '../../../../presentation/viewmodel/countdown_provider.dart';
// import '../../../../presentation/viewmodel/user_auth_provider.dart';
// import '../../../../presentation/viewmodel/wallet_view_model.dart';
// import '../../../side_nav_bar.dart';
// import '../../viewmodel/side_navigation_provider.dart';
// import '../../viewmodel/vesting_status_provider.dart';
// import 'package:intl/intl.dart';
//
// import 'helper/claim.dart';
//
// class StartVestingView extends StatefulWidget {
//   const StartVestingView({super.key});
//
//   @override
//   State<StartVestingView> createState() => _StartVestingViewState();
// }
//
// class _StartVestingViewState extends State<StartVestingView> {
//   String balanceText = '...';
//   bool _isStartingVesting = false;
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final walletVM = Provider.of<WalletViewModel>(context, listen: false);
//       await walletVM.ensureModalWithValidContext(context);
//       await walletVM.rehydrate();
//       await walletVM.getBalance();
//
//       // final vestingProvider = Provider.of<VestingStatusProvider>(context, listen: false);
//       // await vestingProvider.loadFromBackend();
//      });
//   }
//
//   Future<String> resolveBalance() async {
//
//     try{
//
//       final prefs = await SharedPreferences.getInstance();
//       final authMethod = prefs.getString('auth_method') ?? '';
//       String contract = prefs.getString('dashboard_contract_address') ?? '';
//
//       if(contract.isEmpty){
//         final details = await ApiService().fetchTokenDetails('e-commerce-coin');
//         final contract = (details.contractAddress ?? '').trim();
//         if(contract.isNotEmpty && contract.length == 42 && contract.startsWith('0x')){
//           await prefs.setString('dashboard_contract_address', contract);
//         }else{
//           return '0';
//         }
//       }
//
//
//       if (authMethod == 'password') {
//         final userAuth = Provider.of<UserAuthProvider>(context, listen: false);
//
//         final providerAddr = (userAuth.user?.ethAddress ?? '').trim().toLowerCase();
//         final prefsAddr = (prefs.getString('ethAddress') ?? '').trim().toLowerCase();
//         final userAddress = providerAddr.isNotEmpty ? providerAddr : prefsAddr;
//
//         if (userAddress.isEmpty || userAddress.length != 42 || !userAddress.startsWith('0x')) return '0';
//
//         try {
//           final human = await ApiService().fetchTokenBalanceHuman(contract, userAddress, decimals: 18);
//           return human;
//         } catch (_) {
//           return '0';
//         }
//       }
//
//       // Web3 path (on-chain)
//       final walletVM = Provider.of<WalletViewModel>(context, listen: false);
//       try {
//         return await walletVM.getBalance();
//       } catch (_) {
//         return '0';
//       }
//
//
//     }catch(e){
//       return '0';
//     }
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     final walletVM = Provider.of<WalletViewModel>(context, listen: false);
//     final navProvider = Provider.of<NavigationProvider>(context);
//     final currentScreenId = navProvider.currentScreenId;
//     final navItems = navProvider.drawerNavItems;
//     final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//     // final vestingStatus = Provider.of<VestingStatusProvider>(context);
//
//     if (vestingStatus.isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//
//     // if (vestingStatus.hasUserStartedVestingSleepPeriod) {
//     //   return WillPopScope(
//     //     onWillPop: () async => false,
//     //     child: const SleepPeriodScreen(),
//     //   );
//     // }
//
//
//     return  Scaffold(
//         key: _scaffoldKey,
//         drawerEnableOpenDragGesture: true,
//         drawerEdgeDragWidth: 80,
//         drawer: SideNavBar(
//           currentScreenId: currentScreenId,
//           navItems: navItems,
//           onScreenSelected: (id) => navProvider.setScreen(id),
//           onLogoutTapped: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Logout Pressed")));
//           },
//         ),
//         extendBodyBehindAppBar: true,
//         backgroundColor: Colors.transparent,
//
//         body: SafeArea(
//           top: false,
//           child: Container(
//               width: screenWidth,
//               height: screenHeight,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF01090B),
//                 image: DecorationImage(
//                     image: AssetImage('assets/images/starGradientBg.png'),
//                     fit: BoxFit.cover,
//                     alignment: Alignment.topRight,
//                     filterQuality : FilterQuality.low
//                 ),
//               ),
//               child:
//               Column(
//                 children: [
//                   SizedBox(height: screenHeight * 0.02),
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child:  Text(
//                       'ECM Vesting',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         // fontSize: 20
//                         fontSize: screenWidth * 0.05,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: screenWidth * 0.01,
//                         vertical: screenHeight * 0.02,
//                       ),
//                       child: ScrollConfiguration(
//                         behavior: const ScrollBehavior().copyWith(overscroll: false),
//
//                         child: RefreshIndicator(
//                           onRefresh: () async {
//                             final walletVM = Provider.of<WalletViewModel>(context, listen: false);
//                             await walletVM.ensureModalWithValidContext(context);
//                             await walletVM.rehydrate();
//                             await walletVM.getBalance();
//                             if (mounted) {
//                               setState(() {});
//                             }
//                           },
//                           child: SingleChildScrollView(
//                             physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
//
//
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//
//                                 totalBalance(screenHeight, screenWidth, context,walletVM),
//
//                                 SizedBox(height: screenHeight * 0.02),
//
//                                 vestingInfo(screenHeight, screenWidth, context),
//
//                                 SizedBox(height: screenHeight * 0.09),
//
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//           ),
//         )
//     );
//   }
//
//   Widget totalBalance(screenHeight, screenWidth, context ,WalletViewModel walletVm){
//
//     return FutureBuilder<String>(
//         future: resolveBalance(),
//         builder: (context,snapshot) {
//
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.hasData) {
//               balanceText = snapshot.data!;
//             } else if (snapshot.hasError) {
//               balanceText = "0";
//             }
//           }
//           return VestingContainer(
//             width: screenWidth * 0.9,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//
//                 SizedBox(height: screenHeight * 0.02),
//
//                 Text(
//                   'Total Balance',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Color(0XFFFFF5ED),
//                     fontSize: getResponsiveFontSize(context, 12),
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.001),
//                 ShaderMask(
//                   blendMode: BlendMode.srcIn,
//                   shaderCallback: (Rect bounds) {
//                     return LinearGradient(
//                       colors: const [
//                         Color(0xFF2680EF),
//                         Color(0xFF1CD494),
//                       ],
//                     ).createShader(bounds);
//                   },
//                   child: Text(
//                     'ECM ${_formatBalance(balanceText)}',
//                      // "${walletVm.walletAddress.substring(0, 6)}...${walletVm.walletAddress.substring(walletVm.walletAddress.length - 4)}",
//
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: getResponsiveFontSize(context, 22),
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//
//               ],
//             ),
//           );
//         }
//     );
//
//   }
//
//   Widget vestingInfo(screenHeight, screenWidth, context){
//
//     return VestingContainer(
//       width: screenWidth * 0.9,
//       borderColor: const Color(0XFF2C2E41),
//       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Text(
//               'Vesting info',
//               style: TextStyle(
//                 color: Color(0XFFFFF5ED),
//                 fontSize: getResponsiveFontSize(context, 16),
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w500,
//               ),
//              ),
//           ),
//
//           SizedBox(height: screenHeight * 0.04),
//           Text(
//             'ECM Amount',
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w500,
//               fontSize: getResponsiveFontSize(context, 14),
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.01),
//           ListingField(
//             controller: TextEditingController(),
//             labelText: '${_formatBalance(balanceText)} ECM',
//             height: screenHeight * 0.05,
//             width: screenWidth* 0.88,
//             expandable: false,
//             readOnly: true,
//             keyboard: TextInputType.name,
//           ), ///
//
//           SizedBox(height: screenHeight * 0.03),
//
//
//
//           Text(
//             'Vesting Period',
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w500,
//               fontSize: getResponsiveFontSize(context, 14),
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.01),
//           ListingField(
//             controller: TextEditingController(),
//             labelText: '3 months cliff',
//             height: screenHeight * 0.05,
//             width: screenWidth* 0.88,
//             expandable: false,
//             readOnly: true,
//             keyboard: TextInputType.name,
//           ),
//
//           SizedBox(height: screenHeight * 0.03),
//
//           Text(
//             'Vesting Start',
//             textAlign: TextAlign.start,
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w500,
//               fontSize: getResponsiveFontSize(context, 14),
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.01),
//           ListingField(
//             controller: TextEditingController(),
//             labelText: '20 January , 2026',
//             height: screenHeight * 0.05,
//             width: screenWidth* 0.88,
//             expandable: false,
//             readOnly: true,
//             keyboard: TextInputType.name,
//           ),
//           SizedBox(height: screenHeight * 0.04),
//
//
//           BlockButton(
//             height: screenHeight * 0.05,
//             width: screenWidth * 0.8,
//             label: _isStartingVesting ? "Starting.." : "Start Vesting",
//             textStyle:  TextStyle(
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//               fontSize: getResponsiveFontSize(context, 16),
//               height: 1.6,
//             ),
//             gradientColors: const [
//               Color(0xFF2680EF),
//               Color(0xFF1CD494)
//             ],
//             onTap: _isStartingVesting ? null : () async{
//               setState(() => _isStartingVesting = true);
//
//               final vestingProvider = Provider.of<VestingStatusProvider>(context, listen: false);
//               final success  = await vestingProvider.startVestingSleepPeriod();
//
//               if(success && mounted){
//                 setState(() {});
//               }
//               if(mounted){
//                 setState(() => _isStartingVesting = false);
//               }
//             },
//
//           ),
//
//         ],
//       ),
//     );
//   }
//
//
// }
//
//
//
//
// String _formatBalance(String balance) {
//   if (balance.length <= 6) return balance;
//   return '${balance.substring(0, 9)}';
// }
//
//
//
//
