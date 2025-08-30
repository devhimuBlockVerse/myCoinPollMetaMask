 import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/models/user_model.dart';
 import 'package:mycoinpoll_metamask/application/presentation/viewmodel/wallet_view_model.dart';
import 'package:mycoinpoll_metamask/framework/components/trasnactionStatusCompoent.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
 import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/userBadgeLevelCompoenet.dart';
import '../../../../../framework/components/walletAddressComponent.dart';
import '../../../../../framework/utils/customToastMessage.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/toast_type.dart';
 import '../../../../data/services/api_service.dart';
import '../../../../presentation/models/get_purchase_stats.dart';
 import '../../../../presentation/viewmodel/user_auth_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../../side_nav_bar.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

 class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {

   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    PurchaseStatsModel? _purchaseStats;

   String _uniqueId = '';
   bool _isBalanceLoading = true;
   String? _balance;
   @override
   void initState() {
     super.initState();
     _setGreeting();
      _loadPurchaseStats();
     _fetchBalance();

     WidgetsBinding.instance.addPostFrameCallback((_) async {
       final walletVM = Provider.of<WalletViewModel>(context, listen: false);

       await walletVM.ensureModalWithValidContext(context);

       await walletVM.rehydrate();

       // await walletVM.getBalance();

       final prefs = await SharedPreferences.getInstance();
       final uniqueIdFromPrefs = prefs.getString('unique_id');
       if(uniqueIdFromPrefs != null){
         setState(() {
           _uniqueId = uniqueIdFromPrefs;
         });
       }
     });

   }

   String greeting = "";

   void _setGreeting() {
     final hour = DateTime.now().hour;
     greeting = hour >= 5 && hour < 12
         ? "Good Morning"
         : hour >= 12 && hour < 17
         ? "Good Afternoon"
         : hour >= 17 && hour < 21
         ? "Good Evening"
         : "Good Night";
   }


   Future<void> _loadPurchaseStats() async {
     try {
       final stats = await ApiService().fetchPurchaseStats();
       setState(() {
         _purchaseStats = stats;
       });
     } catch (e) {
       debugPrint('Error fetching stats: $e');
     }
   }

   Future<String> resolveBalance() async {

     try{

       final prefs = await SharedPreferences.getInstance();
       final authMethod = prefs.getString('auth_method') ?? '';
       String contract = prefs.getString('dashboard_contract_address') ?? '';

       if(contract.isEmpty){
         final details = await ApiService().fetchTokenDetails('e-commerce-coin');
         final contract = (details.contractAddress ?? '').trim();
         if(contract.isNotEmpty && contract.length == 42 && contract.startsWith('0x')){
           await prefs.setString('dashboard_contract_address', contract);
         }else{
           return '0';
         }
       }


       if (authMethod == 'password') {
         final userAuth = Provider.of<UserAuthProvider>(context, listen: false);

         final providerAddr = (userAuth.user?.ethAddress ?? '').trim().toLowerCase();
         final prefsAddr = (prefs.getString('ethAddress') ?? '').trim().toLowerCase();
         final userAddress = providerAddr.isNotEmpty ? providerAddr : prefsAddr;

         if (userAddress.isEmpty || userAddress.length != 42 || !userAddress.startsWith('0x')) return '0';

         try {
           final human = await ApiService().fetchTokenBalanceHuman(contract, userAddress, decimals: 18);
           return human;
         } catch (_) {
           return '0';
         }
       }

       // Web3 path (on-chain)
       final walletVM = Provider.of<WalletViewModel>(context, listen: false);

       try {
         // return await walletVM.getBalance();
         debugPrint("DashboardScreen: resolveBalance() calling walletVM.getBalance()");
         final balanceResult = await walletVM.getBalance();
         debugPrint("DashboardScreen: walletVM.getBalance() returned: $balanceResult");
         return balanceResult;
       } catch (e,stack) {
         debugPrint("DashboardScreen: Error in walletVM.getBalance(): $e\n$stack");
         return '0';
       }


     }catch(e){
       debugPrint("resolveBalance error: $e");
       return '0';
     }

   }


   Future<void> _fetchBalance() async {
      if (!mounted) return;

     try {
       final balanceResult = await resolveBalance();
       if (mounted) {
         setState(() {
           _balance = balanceResult;
           _isBalanceLoading = false;
         });
       }
     } catch (e) {
       debugPrint("DashboardScreen: Failed to fetch balance: $e");
       if (mounted) {
         setState(() {
           _balance = "Error";
           _isBalanceLoading = false;
         });
       }
     }
   }

    @override
   Widget build(BuildContext context) {
     double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight = MediaQuery.of(context).size.height;

     final navProvider = Provider.of<NavigationProvider>(context);
     final currentScreenId = navProvider.currentScreenId;
     final navItems = navProvider.drawerNavItems;

      return WillPopScope(
       onWillPop: () async {
         return false;
       },
       child: Scaffold(
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
           child: Container(
             width: screenWidth,
             // height: screenHeight * 0.9,
             decoration: const BoxDecoration(
               image: DecorationImage(
                   image: AssetImage('assets/images/starGradientBg.png'),
                   fit: BoxFit.cover,
                   alignment: Alignment.topRight,
                   filterQuality : FilterQuality.low
               ),
             ),
             child: Padding(
               padding: EdgeInsets.symmetric(
                 horizontal: screenWidth * 0.01,
                 vertical: screenHeight * 0.02,
               ),
               child: RefreshIndicator(
                 onRefresh: () async {

                   setState(() {
                     _isBalanceLoading = true;
                   });
                   await _loadPurchaseStats();
                   await _fetchBalance();


                   final userAuth = Provider.of<UserAuthProvider>(context, listen: false);
                   await userAuth.loadUserFromPrefs();

                   final walletModel = Provider.of<WalletViewModel>(context, listen: false);
                   if (walletModel.isConnected) {
                     await walletModel.fetchConnectedWalletData(isReconnecting: true);
                   } else {
                     await walletModel.init(context);
                   }
                 },

                 child: ScrollConfiguration(
                   behavior: const ScrollBehavior().copyWith(overscroll: false),
                   child: Consumer<WalletViewModel>(
                     builder: (context, walletModel, _) {

                       return  SingleChildScrollView(
                         physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),

                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [


                             /// User Name Data & Wallet Address

                              Consumer<UserAuthProvider>(
                               builder: (context, userAuth, child) {
                                 return _headerSection(_scaffoldKey, walletModel, userAuth);
                               },
                             ),
                             SizedBox(height: screenHeight * 0.02),

                             /// User Graph Chart and Level
                             _EcmWithGraphChart(),
                             SizedBox(height: screenHeight * 0.03),


                             /// Referral Link
                             Container(
                               width: double.infinity,
                               decoration: BoxDecoration(
                                   color: const Color(0xff040C16),
                                   borderRadius: BorderRadius.circular(12)
                               ),

                               child: ClipRRect(
                                 child: Padding(
                                   padding: const EdgeInsets.all(12.0),

                                  child: CustomLabeledInputField(
                                     labelText: 'Referral Link:',
                                     hintText: _uniqueId.isNotEmpty ? 'https://mycoinpoll.com?ref=$_uniqueId'
                                     : 'Loading...',
                                      isReadOnly: true,
                                     trailingIconAsset: 'assets/icons/copyImg.svg',
                                     onTrailingIconTap: () {
                                       final referralLink =  _uniqueId.isNotEmpty
                                           ? 'https://mycoinpoll.com?ref=$_uniqueId'
                                           : '';
                                       if(referralLink.isNotEmpty){
                                         Clipboard.setData(ClipboardData(text:referralLink));
                                         ToastMessage.show(
                                           message: "Referral link copied!",
                                           subtitle: referralLink,
                                           type: MessageType.success,
                                           duration: CustomToastLength.SHORT,
                                           gravity: CustomToastGravity.BOTTOM,
                                         );
                                       }
                                     },
                                   ),

                                 ),
                               ),
                             ),
                             SizedBox(height: screenHeight * 0.03),


                             _transactionsReferral(),

                             SizedBox(height: screenHeight * 0.1),


                           ],
                         ),
                       );
                     },

                   ),
                 ),
               ),
             ),
           ),
         ),
       ),
     );
   }



   Widget _headerSection(GlobalKey<ScaffoldState> scaffoldKey,WalletViewModel model,UserAuthProvider userAuthModel){
     double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight = MediaQuery.of(context).size.height;

     final currentUser = userAuthModel.user;

     return Container(
       width: double.infinity,
       decoration: BoxDecoration(
         color: Colors.transparent.withOpacity(0.1),
       ),
       child: ClipRRect(
         child: BackdropFilter(
           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
           child: Padding(
             padding: EdgeInsets.symmetric(
               horizontal: screenWidth * 0.03,
               vertical: screenHeight * 0.015,
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [

                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     GestureDetector(
                       onTap: (){
                         scaffoldKey.currentState?.openDrawer();
                       },
                       child: SvgPicture.asset(
                         'assets/icons/drawerIcon.svg',
                         fit: BoxFit.contain,
                         height: getResponsiveFontSize(context, 16),
                       ),
                     ),
                     SizedBox(width: screenWidth * 0.03),
                     /// User Info & Ro Text + Notification
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           greeting,
                           style: TextStyle(
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w400,
                             fontSize: getResponsiveFontSize(context, 14),
                             height: 1.6,
                             color: const Color(0xffFFF5ED),
                           ),
                         ),
                         Text(
                           (currentUser?.name?.isNotEmpty ?? false) ? currentUser!.name! : 'Hi, Ethereum User!',

                           style: TextStyle(
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w600,
                             fontSize: getResponsiveFontSize(context, 18),
                             height: 1.3,
                             color: const Color(0xffFFF5ED),
                           ),
                         ),
                         const SizedBox(width: 8),

                       ],
                     ),
                   ],
                 ),



                 /// Wallet Address
                 Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                     Transform.translate(
                       offset: Offset(screenWidth * 0.025, 0),

                       child:WalletAddressComponent(
                         address: (currentUser?.ethAddress?.isNotEmpty ?? false)
                             ? formatAddress(currentUser!.ethAddress)
                             : formatAddress(model.walletAddress),
                         onTap: () async {
                           try {
                             await model.ensureModalWithValidContext(context);
                             await model.appKitModal?.openModalView();
                           } catch (e) {
                             print("Error opening wallet modal: $e");
                           }
                         },
                       ),

                     ),


                   ],
                 ),
               ],
             ),
           ),
         ),
       ),
     );
   }


   Widget _EcmWithGraphChart(){
     double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight = MediaQuery.of(context).size.height;

     // The widget now just renders based on the state variables _isBalanceLoading and _balance
     Widget balanceWidget;

     if (_isBalanceLoading) {
       // STATE 1: Data is loading
       balanceWidget = const SizedBox(
         height: 24,
         width: 24,
         child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
       );
     } else if (_balance == "Error") {
       // STATE 2: An error occurred
       balanceWidget = Text(
         "Error",
         style: TextStyle(
             color: Colors.redAccent,
             fontSize: getResponsiveFontSize(context, 24)),
       );
     } else {
       // STATE 3: Data is available
       balanceWidget = Text(
         formatBalance(_balance ?? '0'),
         style: TextStyle(
             color: Colors.white,
             fontFamily: 'Poppins',
             fontSize: getResponsiveFontSize(context, 24),
             fontWeight: FontWeight.w600,
             height: 1.3),
       );
     }

         return Container(
             width: screenWidth,
             height: screenHeight * 0.16,
             decoration: BoxDecoration(
               border: Border.all(
                   color: Colors.transparent
               ),
               image: const DecorationImage(
                 image: AssetImage('assets/images/applyForListingBG.png'),
                 filterQuality : FilterQuality.low,
                 fit: BoxFit.fill,
               ),
             ),
             child: Stack(
               children: [

                 Padding(
                   padding: EdgeInsets.symmetric(
                     horizontal: screenWidth * 0.025,
                     vertical: screenHeight * 0.015,
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [

                       Expanded(
                         flex: 2,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Image.asset(
                                     'assets/images/ecm.png',
                                     height: screenWidth * 0.04,
                                     fit: BoxFit.contain,
                                     filterQuality : FilterQuality.low
                                 ),
                                 SizedBox(width: screenWidth * 0.01),
                                 Text(
                                   'ECM Coin',
                                   textAlign:TextAlign.start,
                                   style: TextStyle(
                                     color: const Color(0xffFFF5ED),
                                     fontFamily: 'Poppins',
                                     fontSize: getResponsiveFontSize(context, 16),
                                     fontWeight: FontWeight.normal,
                                     height: 1.6,
                                   ),
                                 ),


                               ],
                             ),

                             balanceWidget,
                             SizedBox(height: screenHeight * 0.01),
                           ],
                         ),
                       ),

                       SingleChildScrollView(
                         child: Column(
                           // mainAxisAlignment: MainAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           crossAxisAlignment: CrossAxisAlignment.end,
                           children: [

                             // Badge
                             const UserBadgeLevel(
                               label: 'Level-1',
                               iconPath: 'assets/icons/check.svg',
                             ),

                             SizedBox(height: screenHeight * 0.01),
                             Image.asset(
                                 'assets/images/staticChart.png',
                                 width: screenWidth * 0.38 ,
                                 height: screenHeight * 0.08,
                                 fit: BoxFit.contain,
                                 filterQuality : FilterQuality.low
                             ),

                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
               ],
             )
         );


   }


   // Widget _EcmWithGraphChart(){
   //   double screenWidth = MediaQuery.of(context).size.width;
   //   double screenHeight = MediaQuery.of(context).size.height;
   //
   //   return Consumer2<WalletViewModel,UserAuthProvider>(
   //     builder: (context, walletVM ,userAuth, child){
   //       String balanceText = '...';
   //
   //
   //       if (walletVM.balance != null) {
   //         balanceText = walletVM.balance!;
   //       } else {
   //         balanceText = "0";
   //       }
   //       debugPrint("Dashboard _EcmWithGraphChart Consumer: walletVM.balance = ${walletVM.balance}, displayBalanceText = $balanceText");
   //
   //       return Container(
   //           width: screenWidth,
   //           height: screenHeight * 0.16,
   //           decoration: BoxDecoration(
   //             border: Border.all(
   //                 color: Colors.transparent
   //             ),
   //             image: const DecorationImage(
   //               image: AssetImage('assets/images/applyForListingBG.png'),
   //               filterQuality : FilterQuality.low,
   //               fit: BoxFit.fill,
   //             ),
   //           ),
   //           child: Stack(
   //             children: [
   //
   //               Padding(
   //                 padding: EdgeInsets.symmetric(
   //                   horizontal: screenWidth * 0.025,
   //                   vertical: screenHeight * 0.015,
   //                 ),
   //                 child: Row(
   //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
   //                   crossAxisAlignment: CrossAxisAlignment.center,
   //                   children: [
   //
   //                     Expanded(
   //                       flex: 2,
   //                       child: Column(
   //                         crossAxisAlignment: CrossAxisAlignment.start,
   //                         children: [
   //                           Row(
   //                             mainAxisAlignment: MainAxisAlignment.start,
   //                             crossAxisAlignment: CrossAxisAlignment.center,
   //                             children: [
   //                               Image.asset(
   //                                   'assets/images/ecm.png',
   //                                   height: screenWidth * 0.04,
   //                                   fit: BoxFit.contain,
   //                                   filterQuality : FilterQuality.low
   //                               ),
   //                               SizedBox(width: screenWidth * 0.01),
   //                               Text(
   //                                 'ECM Coin',
   //                                 textAlign:TextAlign.start,
   //                                 style: TextStyle(
   //                                   color: const Color(0xffFFF5ED),
   //                                   fontFamily: 'Poppins',
   //                                   fontSize: getResponsiveFontSize(context, 16),
   //                                   fontWeight: FontWeight.normal,
   //                                   height: 1.6,
   //                                 ),
   //                               ),
   //
   //
   //                             ],
   //                           ),
   //
   //                           (walletVM.isLoading && walletVM.balance == null)
   //                               ? const SizedBox(
   //                             height: 24,
   //                             width: 24,
   //                             child: CircularProgressIndicator(
   //                               strokeWidth: 2,
   //                               color: Colors.white,
   //                             ),
   //                           ) : Text(
   //                             formatBalance(balanceText),
   //                             style: TextStyle(
   //                                 color: Colors.white,
   //                                 fontFamily: 'Poppins',
   //                                 fontSize: getResponsiveFontSize(context, 24),
   //                                 fontWeight: FontWeight.w600,
   //                                 height: 1.3
   //                             ),
   //
   //                           ),
   //                           SizedBox(height: screenHeight * 0.01),
   //                         ],
   //                       ),
   //                     ),
   //
   //                     SingleChildScrollView(
   //                       child: Column(
   //                         // mainAxisAlignment: MainAxisAlignment.center,
   //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
   //                         crossAxisAlignment: CrossAxisAlignment.end,
   //                         children: [
   //
   //                           // Badge
   //                           const UserBadgeLevel(
   //                             label: 'Level-1',
   //                             iconPath: 'assets/icons/check.svg',
   //                           ),
   //
   //                           SizedBox(height: screenHeight * 0.01),
   //                           Image.asset(
   //                               'assets/images/staticChart.png',
   //                               width: screenWidth * 0.38 ,
   //                               height: screenHeight * 0.08,
   //                               fit: BoxFit.contain,
   //                               filterQuality : FilterQuality.low
   //                           ),
   //
   //                         ],
   //                       ),
   //                     ),
   //                   ],
   //                 ),
   //               ),
   //             ],
   //           )
   //       );
   //     },
   //
   //
   //   );
   // }



   Widget _transactionsReferral() {
     final Size screenSize = MediaQuery.of(context).size;
     final screenWidth = screenSize.width;
     final screenHeight = screenSize.height;
     final bool isPortrait = screenHeight > screenWidth;

     final baseSize = isPortrait ? screenWidth : screenHeight;

     return Padding(
       padding: const EdgeInsets.all(2.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           // Top Title Row
           Text(
             'Transactions',
             style: TextStyle(
               fontFamily: 'Poppins',
               fontWeight: FontWeight.w500,
               fontSize: baseSize * 0.045,
               height: 1.2,
               color: Colors.white,
             ),
           ),
           SizedBox(height: screenWidth * 0.05),

           // Main Milestone Container
           Container(
             width: double.infinity,
             padding: EdgeInsets.symmetric(
               vertical: screenHeight * 0.018,
               horizontal: screenWidth * 0.05,
             ),
             decoration:const BoxDecoration(
               image:  DecorationImage(
                   image: AssetImage('assets/images/transactionBgContainer.png'),
                   fit: BoxFit.fill,
                   filterQuality : FilterQuality.low
               ),
             ),
             child:  Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [

                 Column(
                   mainAxisSize: MainAxisSize.min,
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [


                     TransactionStatCard(
                       bgImagePath: 'assets/images/colorYellow.png',
                       title: 'Transactions',
                       value: _purchaseStats != null ? _purchaseStats!.totalPurchases.toString() : '0',

                     ),
                     SizedBox(height: screenHeight * 0.01),

                     TransactionStatCard(
                       bgImagePath: 'assets/images/colorPurple.png',
                       title: 'Purchased Amount ',
                       value: _purchaseStats != null ? _purchaseStats!.totalPurchaseAmount.toStringAsFixed(2) : '0',

                     ),


                     SizedBox(height: screenHeight * 0.01),
                     TransactionStatCard(
                       bgImagePath: 'assets/images/colorYellow.png',
                       title: 'Attendant',
                       value: _purchaseStats != null ? _purchaseStats!.uniqueStages.toString() : '0',

                     ),

                     SizedBox(height: screenHeight * 0.001),

                   ],
                 ),

                 SizedBox(width: screenWidth * 0.1),

                 Flexible(
                   flex: 1,
                   child:Center(
                     child: AnimatedTransactionLoader(
                       size: baseSize * 0.5,
                       duration: const Duration(seconds: 3),
                       isAnimating:true,
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
     );
   }

 }

String formatBalance(String balance) {
  if (balance.length <= 6) return balance;
  return '${balance.substring(0, 9)}...';
}

 class AnimatedTransactionLoader extends StatefulWidget {
   final double size;
   final Duration duration;
   final bool isAnimating;

   const AnimatedTransactionLoader({
     super.key,
     this.size = 80.0,
     this.duration = const Duration(seconds: 2),
     this.isAnimating = true,
   });

   @override
   State<AnimatedTransactionLoader> createState() => _AnimatedTransactionLoaderState();
 }

 class _AnimatedTransactionLoaderState extends State<AnimatedTransactionLoader>
     with SingleTickerProviderStateMixin {
   late AnimationController _controller;
   late Animation<double> _animation;

   static const double _towPi = 2 * 3.14159;
   static const String _assetPath = 'assets/images/transactionLoading.png';



   @override
   void initState() {
     super.initState();
     _initializeAnimation();

   }

   void _initializeAnimation(){
     _controller = AnimationController(
       duration: widget.duration,
       vsync: this,
     );

     _animation = Tween<double>(
       begin: 0.0,
       end: _towPi,
     ).animate(CurvedAnimation(
       parent: _controller,
       curve: Curves.linear,
     ));

     if (widget.isAnimating && mounted) {
       _controller.repeat();
     }
   }

   @override
   void didUpdateWidget(AnimatedTransactionLoader oldWidget) {
     super.didUpdateWidget(oldWidget);

     if (widget.isAnimating != oldWidget.isAnimating) {
       if (widget.isAnimating && mounted) {
         _controller.repeat();
       } else {
         _controller.stop();
       }
     }

     if(widget.duration != oldWidget.duration){
       _controller.duration = widget.duration;
     }
   }

   @override
   void dispose() {
     _controller.dispose();
     super.dispose();
   }

   @override
   Widget build(BuildContext context) {
     return RepaintBoundary(
       child: AnimatedBuilder(
         animation: _animation,
         builder: (context, child) {
           return Transform.rotate(
             angle: _animation.value,
             child: Image.asset(
               _assetPath,
               width: widget.size,
               height: widget.size,
               fit: BoxFit.contain,
               filterQuality: FilterQuality.low,
               cacheWidth: (widget.size * MediaQuery.of(context).devicePixelRatio).round(),
               cacheHeight: (widget.size * MediaQuery.of(context).devicePixelRatio).round(),

             ),
           );
         },
       ),
     );
   }
 }