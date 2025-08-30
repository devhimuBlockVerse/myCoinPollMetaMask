import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/vesting/vesting_Item.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/VestingContainer.dart';
import '../../../../../framework/components/VestingSummaryRow.dart';
import '../../../../../framework/components/claimHistoryCard.dart';
import '../../../../../framework/components/loader.dart';
import '../../../../../framework/components/vestingDetailRow.dart';
import '../../../../../framework/utils/customToastMessage.dart';
import '../../../../../framework/utils/enums/toast_type.dart';
import '../../../../presentation/countdown_timer_helper.dart';
import '../../../../presentation/viewmodel/countdown_provider.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/dashboard_nav_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';
import 'helper/claim.dart';
import 'helper/vesting_info.dart';

class VestingWrapper extends StatefulWidget {
  const VestingWrapper({super.key});

  @override
  State<VestingWrapper> createState() => _VestingWrapperState();
}

class _VestingWrapperState extends State<VestingWrapper> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    walletVM.addListener(_onWalletAddressChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchVestingDataIfConnected();
    });

  }

  void _onWalletAddressChanged() {
    _fetchVestingDataIfConnected();
  }

  void _fetchVestingDataIfConnected() {
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    if (walletVM.vestingAddress != null && walletVM.vestInfo.start == 0) {
      walletVM.getVestingInformation();
      walletVM.getBalance(forAddress: walletVM.vestingAddress);
    }


  }



  @override
  void dispose() {
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    walletVM.removeListener(_onWalletAddressChanged);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<WalletViewModel>(
      builder: (context, walletVM, child) {

        debugPrint('VestingWrapper Consumer REBUILDING. isLoading: ${walletVM.isLoading}, vestingAddress: ${walletVM.vestingAddress}');
         debugPrint('walletAddress: ${walletVM.walletAddress}');
         debugPrint('vestingAddress: ${walletVM.vestingAddress}');
        debugPrint('Vesting balance: ${walletVM.balance}');
        if (walletVM.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (walletVM.walletAddress == null || walletVM.walletAddress!.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Please connect your wallet to view vesting details.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }


        if(walletVM.vestingAddress != null && walletVM.vestingAddress!.isNotEmpty){
          return  SleepPeriodScreen();
        }

        return  VestingView();

      },
    );
  }

  @override
  bool get wantKeepAlive => true;

}

class VestingView extends StatefulWidget {
  const VestingView({super.key});

  @override
  State<VestingView> createState() => _VestingViewState();
}


class _VestingViewState extends State<VestingView> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);



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
              child:
              Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: Alignment.topCenter,
                    child:  Text(
                      'ECM Vesting',
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

                        child: RefreshIndicator(
                          onRefresh: () async {
                            walletVM.refreshVesting();
                          },
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),


                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                buyECMHeader(screenHeight, screenWidth, context ,walletVM),

                                SizedBox(height: screenHeight * 0.02),

                                whyVesting(screenHeight, screenWidth, context)

                              ],
                            ),
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

  Widget buyECMHeader(screenHeight, screenWidth, context , WalletViewModel walletVm){
    return VestingContainer(
      width: screenWidth * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(height: screenHeight * 0.02),

          Text(
            'You haven’t purchased \n ECM yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0XFFFFF5ED),
              fontSize: getResponsiveFontSize(context, 22),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),


          SizedBox(height: screenHeight * 0.02),

          BlockButton(
            height: screenHeight * 0.05,
            width: screenWidth * 0.8,
            label: 'BUY ECM NOW',
            textStyle:  TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: getResponsiveFontSize(context, 14),
              height: 1.6,
            ),
            gradientColors: const [
              Color(0xFF2680EF),
              Color(0xFF1CD494)
            ],
            onTap: () {
              Provider.of<DashboardNavProvider>(context, listen: false).setIndex(1);
            },
            iconPath: 'assets/icons/arrowIcon.svg',
            iconSize : screenHeight * 0.013,
          ),
          SizedBox(height: screenHeight * 0.02),

        ],
      ),
    );

  }

  Widget whyVesting(screenHeight, screenWidth, context){
    final vestingData = [
      {
        "image": "assets/images/vestingImg1.png",
        "text": "Ensures a healthy token economy and reduces market dumps."
      },
      {
        "image": "assets/images/moneyVesting.png",
        "text": "Builds investor trust and shows project commitment"
      },
      {
        "image": "assets/images/vestingImg2.png",
        "text": "Offers bonus rewards or reduced transaction fees."
      },
      {
        "image": "assets/images/vestingImg3.png",
        "text": "Prevents oversupply and maintains token value."
      },
      {
        "image": "assets/images/vestingImg5.png",
        "text": "Encourages long-term investors and ecosystem strength."
      },
      {
        "image": "assets/images/moneyVesting.png",
        "text": "Provides priority in launches, airdrops, or governance."
      },
    ];

    return VestingContainer(
      width: screenWidth * 0.9,
      borderColor: const Color(0XFF2C2E41),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why vesting?',
            style: TextStyle(
              color: Color(0XFFFFF5ED),
              fontSize: getResponsiveFontSize(context, 16),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: screenHeight * 0.02),
          
          ...vestingData.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: VestingItem(
              imagePath: item['image']!,
              text: item['text']!,
              height: screenHeight,
            ),
          )),

        ],
      ),
    );
  }
}

class SleepPeriodScreen extends StatefulWidget {

  const SleepPeriodScreen({super.key,});

  @override
  State<SleepPeriodScreen> createState() => _SleepPeriodScreenState();
}
  // class _SleepPeriodScreenState extends State<SleepPeriodScreen> {
  //   String balanceText = '...';
  //
  //   DateTime? vestingStartDate;
  //   DateTime? cliffEndTime;
  //   DateTime? fullVestedDate;
  //
  //   // Timers and state for the countdown
  //   Timer? _countdownTimer;
  //   bool isVestingPeriodDurationOver = false;
  //   bool isCliffPeriodOver = false;
  //   String _countdownText = '';
  //
  //
  //
  //   List<Claim> _claimHistory = []; // keep track of claims
  //   List<Claim> _filteredClaimHistory = []; // filtered list for search
  //   TextEditingController _searchController = TextEditingController();
  //   bool _isSearchOpen = false;
  //
  //   @override
  //   void initState() {
  //     super.initState();
  //     _searchController.addListener(_onSearchChanged);
  //
  //
  //     WidgetsBinding.instance.addPostFrameCallback((_)async{
  //       // _fetchVestingDataAndStartTimers();
  //      _setupScreen();
  //
  //       fetchClaimHistory().then((claims) {
  //         if (mounted) {
  //           setState(() {
  //             _claimHistory = claims;
  //             _filteredClaimHistory = claims;
  //           });
  //         }
  //       });
  //
  //     });
  //   }
  //
  //   // NEW METHOD to organize setup
  //   void _setupScreen() async {
  //     final walletVM = Provider.of<WalletViewModel>(context, listen: false);
  //
  //     // Fetch the balance of the vesting contract and update local state
  //     if (walletVM.vestingAddress != null) {
  //       final vestingBalance = await walletVM.getBalance(forAddress: walletVM.vestingAddress!);
  //       if (mounted) {
  //         setState(() {
  //           balanceText = vestingBalance;
  //         });
  //       }
  //     }
  //
  //     //  Initialize timers as before
  //     _fetchVestingDataAndStartTimers();
  //   }
  //
  //
  //   void _fetchVestingDataAndStartTimers() async {
  //     final walletVM = Provider.of<WalletViewModel>(context, listen: false);
  //     if (walletVM.vestInfo.start != 0) {
  //       _initializeTimers(walletVM.vestInfo);
  //     }
  //
  //     walletVM.addListener(_onVestingDataUpdated);
  //
  //   }
  //
  //   void _onVestingDataUpdated() {
  //     if (!mounted) {
  //     return;
  //   }
  //     final walletVM = Provider.of<WalletViewModel>(context, listen: false);
  //     if (walletVM.vestInfo.start != 0) {
  //       _initializeTimers(walletVM.vestInfo);
  //       walletVM.removeListener(_onVestingDataUpdated);
  //     }
  //   }
  //
  //   void _initializeTimers(VestingInfo vestInfo) {
  //     if (!mounted) return;
  //
  //     // vestingStartDate = DateTime.fromMillisecondsSinceEpoch(vestInfo.start! * 1000).add(const Duration(days: 120)); // For Testing
  //     // cliffEndTime = DateTime.fromMillisecondsSinceEpoch(vestInfo.cliff! * 1000).subtract(const Duration(days: 120)); // For Testing
  //     vestingStartDate = DateTime.fromMillisecondsSinceEpoch(vestInfo.start! * 1000);
  //     cliffEndTime = DateTime.fromMillisecondsSinceEpoch(vestInfo.cliff! * 1000) ;
  //     fullVestedDate = DateTime.fromMillisecondsSinceEpoch(vestInfo.end! * 1000);
  //
  //     _startCountdownTimer();
  //   }
  //
  //   void _startCountdownTimer() {
  //     _countdownTimer?.cancel();
  //     _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //       if (!mounted) {
  //         timer.cancel();
  //         return;
  //       }
  //       final now = DateTime.now();
  //
  //       if (vestingStartDate == null || cliffEndTime == null) {
  //         print("Vesting dates not yet initialized in _startCountdownTimer. UI should show loading.");
  //         return;
  //       }
  //
  //       if (now.isBefore(vestingStartDate!)) {
  //         if (isVestingPeriodDurationOver || isCliffPeriodOver) {
  //           setState(() {
  //             isVestingPeriodDurationOver = false;
  //             isCliffPeriodOver = false;
  //             _countdownText = "Vesting Starts Soon";
  //           });
  //         }
  //       } else if (now.isBefore(cliffEndTime!)) {
  //         if (!isVestingPeriodDurationOver || isCliffPeriodOver) {
  //           setState(() {
  //             isVestingPeriodDurationOver = true;
  //             isCliffPeriodOver = false;
  //             _countdownText = "Cliff Period Active";
  //           });
  //         }
  //       } else {
  //         if (!isCliffPeriodOver) {
  //           setState(() {
  //             isVestingPeriodDurationOver = true;
  //             isCliffPeriodOver = true;
  //             _countdownText = "Vesting Active - Claim Available";
  //           });
  //         }
  //         timer.cancel();
  //       }
  //     });
  //   }
  //
  //
  //   @override
  //   void dispose() {
  //     _countdownTimer?.cancel();
  //     _searchController.dispose();
  //     final walletVM = Provider.of<WalletViewModel>(context, listen: false);
  //     walletVM.removeListener(_onVestingDataUpdated);
  //     super.dispose();
  //   }
  //
  //
  //
  //   void _onSearchChanged() {
  //     final query = _searchController.text.toLowerCase().trim();
  //
  //     setState(() {
  //       _filteredClaimHistory = _claimHistory.where((claim) {
  //         final amount = claim.amount.replaceAll('ECM ', '').toLowerCase();
  //         final dateTime = claim.dateTime.toLowerCase();
  //         final wallet = claim.walletAddress.toLowerCase();
  //
  //         return amount.contains(query) ||
  //             dateTime.contains(query) ||
  //             wallet.contains(query);
  //       }).toList();
  //     });
  //   }
  //
  //
  //
  //
  //   Future<List<Claim>> fetchClaimHistory() async {
  //     await Future.delayed(const Duration(seconds: 1));
  //
  //     return [
  //
  //       // Claim(
  //       //   amount: "ECM 120.200",
  //       //   dateTime: "15 Nov 2025 11:10:20",
  //       //   walletAddress: "0x9a6fbF46F26625e709c11ca2e84a7f34481bc7d",
  //       // ),     Claim(
  //       //   amount: "ECM 258.665",
  //       //   dateTime: "06 Nov 2025 21:30:48",
  //       //   walletAddress: "0x298f3EF46F26625e709c11ca2e84a7f34489C71d",
  //       // ),
  //       // Claim(
  //       //   amount: "ECM 100.200",
  //       //   dateTime: "15 Nov 2025 11:10:20",
  //       //   walletAddress: "0x9a6fbF46F26625e709c11ca2e84a7f34481bc7d",
  //       // ),
  //     ];
  //   }
  //
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     double screenWidth = MediaQuery.of(context).size.width;
  //     double screenHeight = MediaQuery.of(context).size.height;
  //     final navProvider = Provider.of<NavigationProvider>(context);
  //     final currentScreenId = navProvider.currentScreenId;
  //     final navItems = navProvider.drawerNavItems;
  //     final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //
  //     const baseWidth = 375.0;
  //     const baseHeight = 812.0;
  //
  //     double scaleWidth(double size) => size * screenWidth / baseWidth;
  //     double scaleHeight(double size) => size * screenHeight / baseHeight;
  //     double scaleText(double size) => size * screenWidth / baseWidth;
  //
  //     final walletVm = Provider.of<WalletViewModel>(context);
  //
  //     if(walletVm.isLoading || walletVm.vestingAddress == null){
  //       return const Scaffold(
  //         backgroundColor: Color(0xFF01090B),
  //         body: Center(child: CircularProgressIndicator()),
  //       );
  //     }
  //
  //     final bool isLoadingVestingData = vestingStartDate == null;
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
  //                       child: isLoadingVestingData || walletVm.isLoading
  //                           ? const Center(child: CircularProgressIndicator(color: Colors.white))
  //                           : ScrollConfiguration(
  //                         behavior: const ScrollBehavior().copyWith(overscroll: false),
  //
  //                         child: RefreshIndicator(
  //                           onRefresh: () async {
  //                             await walletVm.getVestingInformation();
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
  //
  //                                 SizedBox(height: screenHeight * 0.02),
  //
  //
  //                                 /// Vesting Event Timer and Vesting Text
  //                                 if(!isVestingPeriodDurationOver) ...[
  //
  //                                   VestingContainer(
  //                                     width: screenWidth * 0.9,
  //                                     child: Column(
  //                                       crossAxisAlignment: CrossAxisAlignment.center,
  //                                       children: [
  //                                         SizedBox(height: screenHeight * 0.02),
  //                                         if (vestingStartDate != null)
  //                                           Text(
  //                                             'Vesting Period Begin on \n${DateFormat('d MMMM yyyy').format(vestingStartDate!)}',
  //                                             textAlign: TextAlign.center,
  //                                             style: TextStyle(
  //                                               color: const Color(0xFFFFF5ED),
  //                                               fontSize: getResponsiveFontSize(context, 22),
  //                                               fontFamily: 'Poppins',
  //                                               fontWeight: FontWeight.w500,
  //
  //                                             ),
  //                                           ),
  //                                         SizedBox(height: screenHeight * 0.02),
  //                                         if (vestingStartDate != null)
  //                                           ChangeNotifierProvider(
  //                                             create: (_) {
  //                                               return CountdownTimerProvider(
  //                                                 targetDateTime: vestingStartDate!,
  //                                               );
  //                                             },
  //                                             child: CountdownTimer(
  //                                               scaleWidth: scaleWidth,
  //                                               scaleHeight: scaleHeight,
  //                                               scaleText: scaleText,
  //                                               showMonths: true,
  //                                             ),
  //                                           ),
  //                                         SizedBox(height: screenHeight * 0.03),
  //
  //                                       ],
  //                                     ),
  //                                   ),
  //
  //                                   SizedBox(height: screenHeight * 0.02),
  //
  //                                   /// Vesting Wallet Address
  //                                   CustomLabeledInputField(
  //                                     containerWidth: screenWidth * 0.9,
  //                                     labelText: 'Vesting Wallet:',
  //                                     hintText: walletVm.vestingAddress ?? "...",
  //                                     isReadOnly: true,
  //                                     trailingIconAsset: 'assets/icons/copyImg.svg',
  //                                     onTrailingIconTap: () {
  //                                       final vestingAddress = walletVm.vestingAddress;
  //                                       if(vestingAddress != null && vestingAddress.isNotEmpty){
  //                                         Clipboard.setData(ClipboardData(text:vestingAddress));
  //                                         ToastMessage.show(
  //                                           message: "Vesting Wallet Address copied!",
  //                                           subtitle: vestingAddress,
  //                                           type: MessageType.success,
  //                                           duration: CustomToastLength.SHORT,
  //                                           gravity: CustomToastGravity.BOTTOM,
  //                                         );
  //                                       }
  //                                     },
  //                                   ),
  //
  //                                   SizedBox(height: screenHeight * 0.02),
  //                                   vestingDetails(screenHeight, screenWidth, context,),
  //                                   SizedBox(height: screenHeight * 0.9),
  //                                 ]else ...[
  //                                   cliffTimerAndClaimSection(screenHeight, screenWidth, context),
  //                                   SizedBox(height: screenHeight * 0.02),
  //
  //                                   CustomLabeledInputField(
  //                                     containerWidth: screenWidth * 0.9,
  //                                     labelText: 'Vesting Wallet:',
  //                                     hintText: walletVm.vestingAddress ?? "...",
  //                                     isReadOnly: true,
  //                                     trailingIconAsset: 'assets/icons/copyImg.svg',
  //                                     onTrailingIconTap: () {
  //                                       final vestingAddress = walletVm.vestingAddress;
  //                                       if(vestingAddress != null && vestingAddress.isNotEmpty){
  //                                         Clipboard.setData(ClipboardData(text:vestingAddress));
  //                                         ToastMessage.show(
  //                                           message: "Vesting Wallet Address copied!",
  //                                           subtitle: vestingAddress,
  //                                           type: MessageType.success,
  //                                           duration: CustomToastLength.SHORT,
  //                                           gravity: CustomToastGravity.BOTTOM,
  //                                         );
  //                                       }
  //                                     },
  //                                   ),
  //
  //                                   SizedBox(height: screenHeight * 0.02),
  //
  //                                   vestingSummary(screenHeight,screenWidth,context),
  //
  //                                   SizedBox(height: screenHeight * 0.02),
  //
  //                                   claimHistory(screenHeight,screenWidth,context)
  //                                 ],
  //
  //                                 // if (isVestingPeriodDurationOver) ...[
  //                                 //   cliffTimerAndClaimSection(screenHeight, screenWidth, context),
  //                                 //   SizedBox(height: screenHeight * 0.02),
  //                                 //
  //                                 //   CustomLabeledInputField(
  //                                 //     containerWidth: screenWidth * 0.9,
  //                                 //     labelText: 'Vesting Wallet:',
  //                                 //     hintText: "0xE4763679E40basdasd1c4e7d117429",
  //                                 //     isReadOnly: true,
  //                                 //     trailingIconAsset: 'assets/icons/copyImg.svg',
  //                                 //     onTrailingIconTap: () {
  //                                 //       final vestingAddress = "0xE4763679E40b...1c4e7d117429";
  //                                 //       if(vestingAddress.isNotEmpty){
  //                                 //         Clipboard.setData(ClipboardData(text:vestingAddress));
  //                                 //         ToastMessage.show(
  //                                 //           message: "Vesting Wallet Address copied!",
  //                                 //           subtitle: vestingAddress,
  //                                 //           type: MessageType.success,
  //                                 //           duration: CustomToastLength.SHORT,
  //                                 //           gravity: CustomToastGravity.BOTTOM,
  //                                 //         );
  //                                 //       }
  //                                 //     },
  //                                 //   ),
  //                                 //
  //                                 //   SizedBox(height: screenHeight * 0.02),
  //                                 //
  //                                 //   vestingSummary(screenHeight,screenWidth,context),
  //                                 //
  //                                 //   SizedBox(height: screenHeight * 0.02),
  //                                 //
  //                                 //   claimHistory(screenHeight,screenWidth,context)
  //                                 // ],
  //
  //                                 SizedBox(height: screenHeight * 0.02),
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
  //   Widget vestingDetails(double screenHeight, double screenWidth, BuildContext context) {
  //      return Consumer<WalletViewModel>(
  //          builder: (context,walletVM, child) {
  //
  //            if (walletVM.isLoading && walletVM.balance == null) {
  //            } else if (walletVM.balance != null) {
  //              balanceText = walletVM.balance!;
  //
  //            } else {
  //              balanceText = "0";
  //            }
  //
  //            debugPrint(" vestingDetails Consumer: walletVM.balance = ${walletVM.balance}, displayBalanceText = $balanceText");
  //
  //           return VestingContainer(
  //             width: screenWidth * 0.9,
  //             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //
  //                 Text(
  //                   'Total Vesting ECM',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: Color(0XFFFFFFFF),
  //                     fontSize: getResponsiveFontSize(context, 12),
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                 ),
  //                 SizedBox(height: screenHeight * 0.001),
  //
  //                 (walletVM.isLoading && walletVM.balance == null)
  //                     ? const SizedBox(
  //                   height: 24,
  //                   width: 24,
  //                   child: CircularProgressIndicator(
  //                     strokeWidth: 2,
  //                     color: Colors.white,
  //                   ),
  //                 ) : ShaderMask(
  //                   blendMode: BlendMode.srcIn,
  //                   shaderCallback: (Rect bounds) {
  //                     return const LinearGradient(
  //                       colors:  [
  //                         Color(0xFF2680EF),
  //                         Color(0xFF1CD494),
  //                       ],
  //                     ).createShader(bounds);
  //                   },
  //                   child: Text(
  //                     'ECM ${_formatBalance(balanceText)}',
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       fontSize: getResponsiveFontSize(context, 22),
  //                       fontFamily: 'Poppins',
  //                       fontWeight: FontWeight.w700,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: screenHeight * 0.03),
  //
  //                 Builder(
  //                     builder: (context) {
  //
  //                       return Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Flexible(
  //                             child: VestingDetailInfoRow(
  //                               iconPath: 'assets/icons/vestingStartDate.svg',
  //                               title: 'Vesting Start Date',
  //                               // value: formattedStart,
  //                               value: vestingStartDate != null ? DateFormat('d MMMM yyyy').format(vestingStartDate!) : '...',
  //
  //                             ),
  //                           ),
  //                           SizedBox(width: screenWidth * 0.03),
  //                           Flexible(
  //                             child: VestingDetailInfoRow(
  //                               iconPath: 'assets/icons/vestingFullDate.svg',
  //                               title: 'Full Vested Date',
  //                               // value: formattedEnd,
  //                               value: fullVestedDate != null ? DateFormat('d MMMM yyyy').format(fullVestedDate!) : '...',
  //
  //                             ),
  //                           ),
  //
  //                         ],
  //
  //                       );
  //                     }
  //                 ),
  //
  //               ],
  //             ),
  //           );
  //         }
  //     );
  //
  //   }
  //
  //
  //
  //   Widget cliffTimerAndClaimSection(double screenHeight, double screenWidth, BuildContext context){
  //     const baseWidth = 335.0;
  //     const baseHeight = 1600.0;
  //     double scaleWidth(double size) => size * screenWidth / baseWidth;
  //     double scaleHeight(double size) => size * screenHeight / baseHeight;
  //     double scaleText(double size) => size * screenWidth / baseWidth;
  //
  //
  //     return Consumer<WalletViewModel>(
  //         builder: (context,walletVM, child) {
  //
  //           if (walletVM.isLoading && walletVM.balance == null) {
  //
  //           } else if (walletVM.balance != null) {
  //             balanceText = walletVM.balance!;
  //           } else {
  //             balanceText = "0";
  //           }
  //           debugPrint("Dashboard _EcmWithGraphChart Consumer: walletVM.balance = ${walletVM.balance}, displayBalanceText = $balanceText");
  //
  //           return VestingContainer(
  //             width: screenWidth * 0.9,
  //             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //
  //                 Text(
  //                   'Total Vesting ECM',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: Color(0XFFFFFFFF),
  //                     fontSize: getResponsiveFontSize(context, 12),
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w400,
  //                   ),
  //                 ),
  //                 SizedBox(height: screenHeight * 0.001),
  //
  //                 (walletVM.isLoading && walletVM.balance == null)
  //                     ? const SizedBox(
  //                   height: 24,
  //                   width: 24,
  //                   child: CircularProgressIndicator(
  //                     strokeWidth: 2,
  //                     color: Colors.white,
  //                   ),
  //                 ) : ShaderMask(
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
  //
  //                 /// Timer for cliff period
  //                 if(!isCliffPeriodOver ) ...[
  //                   Text(
  //                     'Once the cliff period ends, you can claim your ECM',
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       color: Color(0XFFFFFFFF),
  //                       fontSize: getResponsiveFontSize(context, 12),
  //                       fontFamily: 'Poppins',
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                   SizedBox(height: screenHeight * 0.01),
  //                   ChangeNotifierProvider(
  //                     create: (_) {
  //                       return CountdownTimerProvider(
  //                         targetDateTime: cliffEndTime!,
  //
  //                       );
  //                     },
  //                     child: Builder(
  //                         builder: (context) {
  //
  //                           return CountdownTimer(
  //                             scaleWidth: scaleWidth,
  //                             scaleHeight: scaleHeight,
  //                             scaleText: scaleText,
  //                             gradientColors: [
  //                               Color(0xFF2680EF).withAlpha(60),
  //                               Color(0xFF1CD494).withAlpha(60)
  //                             ],
  //
  //                             showMonths: true,
  //                           );
  //                         }
  //                     ),
  //                   ),
  //
  //                   SizedBox(height: screenHeight * 0.01),
  //                 ],
  //
  //                 if(isCliffPeriodOver)...[
  //                   /// When the cliff period ends, you can claim your ECM
  //                   Padding(
  //                     padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Flexible(
  //                           child: VestingDetailInfoRow(
  //                             iconPath: 'assets/icons/checkIcon.svg',
  //                             title: 'Claimed',
  //                             // value: 'ECM 125.848',
  //                             value: 'ECM ${walletVM.vestInfo.released?.toStringAsFixed(6) ?? 'Loading ...'}',
  //                             iconSize: screenHeight *0.025,
  //
  //                           ),
  //                         ),
  //                         SizedBox(width: screenWidth * 0.03),
  //                         Flexible(
  //                           child: VestingDetailInfoRow(
  //                             iconPath: 'assets/icons/claimedIcon.svg',
  //                             title: 'Available claim',
  //                             // value: 'ECM 52.152',
  //                             value: 'ECM ${walletVM.availableClaimableAmount.toStringAsFixed(6)}',
  //                              iconSize: screenHeight *0.032,
  //
  //                           ),
  //                         ),
  //
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(height: screenHeight * 0.02),
  //                   BlockButton(
  //                       height: screenHeight * 0.05,
  //                       width: screenWidth * 0.8,
  //                       label:"CLAIM",
  //                       textStyle:  TextStyle(
  //                         fontWeight: FontWeight.w700,
  //                         color: Colors.white,
  //                         fontSize: getResponsiveFontSize(context, 16),
  //                         height: 1.6,
  //                       ),
  //                       gradientColors: const [
  //                         Color(0xFF2680EF),
  //                         Color(0xFF1CD494)
  //                       ],
  //                       // onTap: (){
  //                       //   final newClaim = Claim(
  //                       //     amount: "ECM 50.000",
  //                       //     dateTime: DateFormat("dd MMM yyyy HH:mm:ss").format(DateTime.now()),
  //                       //     walletAddress: walletVm.walletAddress,
  //                       //   );
  //                       //
  //                       //   setState(() {
  //                       //     _claimHistory.insert(0, newClaim);
  //                       //     _onSearchChanged();
  //                       //   });
  //                       //
  //                       //   ToastMessage.show(
  //                       //     message: "Claim successful!",
  //                       //     type: MessageType.success,
  //                       //   );
  //                       // }
  //
  //                     onTap: walletVM.isLoading ? null : (){
  //                       walletVM.claimECM(context);
  //                     }
  //
  //                   ),
  //                 ],
  //
  //
  //
  //
  //
  //               ],
  //             ),
  //           );
  //         }
  //     );
  //   }
  //
  //
  //   Widget vestingSummary(double screenHeight, double screenWidth, BuildContext context){
  //
  //     final dateFormat = DateFormat('d MMMM, yyyy');
  //     String formattedVestingStart = "Loading...";
  //     String formattedCliffEnd = "Loading...";
  //     String formattedFullVested = "Loading...";
  //     String totalVestingPeriodStr = "Calculating...";
  //     String cliffPeriodStr = "Calculating...";
  //
  //
  //     if (vestingStartDate != null) {
  //       formattedVestingStart = dateFormat.format(vestingStartDate!);
  //     }
  //     if (fullVestedDate != null) {
  //       formattedFullVested = dateFormat.format(fullVestedDate!);
  //     }
  //     if (cliffEndTime != null) {
  //       formattedCliffEnd = dateFormat.format(cliffEndTime!); // For "Cliff Info"
  //     }
  //
  //     // Calculate durations if all dates are available
  //     if (vestingStartDate != null && fullVestedDate != null) {
  //       Duration totalDuration = fullVestedDate!.difference(vestingStartDate!);
  //       totalVestingPeriodStr = _formatOverallDuration(totalDuration);
  //     }
  //
  //     if (vestingStartDate != null && cliffEndTime != null) {
  //       Duration cliffDuration = cliffEndTime!.difference(vestingStartDate!);
  //       cliffPeriodStr = _formatOverallDuration(cliffDuration);
  //     }
  //
  //
  //     return VestingContainer(
  //       width: screenWidth * 0.9,
  //       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.02),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //
  //         children: [
  //
  //           Text(
  //             'Vesting Summary',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               color: Color(0XFFFFFFFF),
  //               fontSize: getResponsiveFontSize(context, 16),
  //               fontFamily: 'Poppins',
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           SizedBox(height: screenHeight * 0.03),
  //
  //           VestingSummaryRow(
  //             label: 'Vesting Start Date',
  //             value: formattedVestingStart,
  //           ),
  //
  //           SizedBox(height: screenHeight * 0.01),
  //
  //           VestingSummaryRow(
  //             label: 'Vesting Period',
  //             value: totalVestingPeriodStr,
  //           ),
  //
  //
  //           SizedBox(height: screenHeight * 0.01),
  //
  //           VestingSummaryRow(
  //               label: 'Cliff Info',
  //               value: '$cliffPeriodStr until $formattedCliffEnd'
  //           ),
  //
  //
  //           SizedBox(height: screenHeight * 0.01),
  //
  //           VestingSummaryRow(
  //             label: 'Full Vested Date',
  //             value: formattedFullVested,
  //           ),
  //
  //           SizedBox(height: screenHeight * 0.02),
  //           if (vestingStartDate != null && fullVestedDate != null)
  //             ECMProgressIndicator(
  //
  //               vestingStartDate:  vestingStartDate!,
  //               fullVestedDate: fullVestedDate!,
  //             ),
  //
  //         ],
  //       ),
  //     );
  //   }
  //
  //
  //   Widget claimHistory(double screenHeight, double screenWidth, BuildContext context){
  //     return VestingContainer(
  //         width: screenWidth * 0.9,
  //         height: screenHeight * 0.5,
  //         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.02),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //
  //             // Title + Search Field
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   'Claim History',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: Color(0XFFFFFFFF),
  //                     fontSize: getResponsiveFontSize(context, 16),
  //                     fontFamily: 'Poppins',
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //
  //                 AnimatedContainer(
  //                   duration: const Duration(milliseconds: 250),
  //                   width: _isSearchOpen ? screenWidth * 0.5 : screenHeight * 0.034,
  //                   child: _isSearchOpen
  //                       ? TextField(
  //                     controller: _searchController,
  //                     autofocus: true,
  //                     style: const TextStyle(color: Colors.white, fontSize: 14),
  //                     decoration: InputDecoration(
  //                       hintText: "Search...",
  //                       hintStyle: const TextStyle(color: Colors.white54),
  //                       filled: true,
  //                       fillColor: Colors.white12,
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                         borderSide: BorderSide.none,
  //                       ),
  //                       contentPadding: EdgeInsets.symmetric(
  //                         vertical: screenHeight * 0.008,
  //                         horizontal: screenWidth * 0.02,
  //                       ),
  //                       suffixIcon: GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             _isSearchOpen = false;
  //                             _searchController.clear();
  //                             _onSearchChanged();
  //                           });
  //                         },
  //                         child: const Icon(Icons.close, color: Colors.white, size: 20),
  //                       ),
  //                     ),
  //                     onChanged: (value) => _onSearchChanged(),
  //                   )
  //                       : GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         _isSearchOpen = true;
  //                       });
  //                     },
  //                     child: SvgPicture.asset(
  //                       'assets/icons/search.svg',
  //                       fit: BoxFit.contain,
  //                       height: screenHeight * 0.034,
  //                     ),
  //                   ),
  //                 )
  //
  //
  //               ],
  //             ),
  //             SizedBox(
  //               width: screenWidth * 0.9,
  //               child: const Divider(
  //                 color: Colors.white12,
  //                 thickness: 1,
  //                 height: 15,
  //               ),
  //             ),
  //
  //             SizedBox(height: screenHeight * 0.02),
  //
  //             /// Fetch Claim History
  //
  //             Expanded(
  //               child: _filteredClaimHistory.isEmpty
  //                   ?  Center(
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Opacity(
  //                       opacity: 0.5,
  //                       child: Image.asset(
  //                         'assets/images/noDataFoundImg.png',
  //                         fit: BoxFit.contain,
  //                         height: screenHeight * 0.2,
  //                       ),
  //                     ),
  //                     SizedBox(height: screenHeight * 0.02),
  //                     Text(
  //                       "No Data Founds",
  //                       style: TextStyle(
  //                         color: Color(0XFF7D8FA9),
  //                         fontSize: getResponsiveFontSize(context, 12) ,
  //                         fontFamily: "Poppins",
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //                   : ListView.separated(
  //                 physics: const BouncingScrollPhysics(),
  //                 itemCount: _filteredClaimHistory.length,
  //                 separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.01),
  //                 itemBuilder: (context, index) {
  //                   final claim = _filteredClaimHistory[index];
  //                   return ClaimHistoryCard(
  //                     amount: claim.amount,
  //                     dateTime: claim.dateTime,
  //                     walletAddress: claim.walletAddress,
  //                     buttonLabel: "Explore",
  //                     onButtonTap: () {
  //                       debugPrint("Explore tapped for ${claim.walletAddress}");
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         )
  //     );
  //   }
  //
  // }
  class _SleepPeriodScreenState extends State<SleepPeriodScreen> {
    String balanceText = '...';

    DateTime? vestingStartDate;
    DateTime? cliffEndTime;
    DateTime? fullVestedDate;

    // Timers and state for the countdown
    Timer? _countdownTimer;
    bool isVestingPeriodDurationOver = false;
    bool isCliffPeriodOver = false;
    String _countdownText = '';



    List<Claim> _claimHistory = []; // keep track of claims
    List<Claim> _filteredClaimHistory = []; // filtered list for search
    TextEditingController _searchController = TextEditingController();
    bool _isSearchOpen = false;
    bool _isInitializing = true;
    bool _isDisposed = false;

    @override
    void initState() {
      super.initState();
      _searchController.addListener(_onSearchChanged);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) { // Add mounted check
          await _setupScreen();

          if (mounted) {
            fetchClaimHistory().then((claims) {
              if (mounted) {
                setState(() {
                  _claimHistory = claims;
                  _filteredClaimHistory = claims;
                });
              }
            });
          }
        }
      });
    }



    // NEW METHOD to organize setup
    Future<void> _setupScreen() async {
      if (!mounted) return; // Add mounted check at the beginning

      final walletVM = Provider.of<WalletViewModel>(context, listen: false);

      try {
        // Fetch the balance of the vesting contract and update local state
        if (walletVM.vestingAddress != null) {
          final vestingBalance = await walletVM.getBalance(forAddress: walletVM.vestingAddress!);
          if (mounted) { // Add mounted check before setState
            setState(() {
              balanceText = vestingBalance;
            });
          }
        }

        // Initialize timers as before
        if (mounted) { // Add mounted check
          _fetchVestingDataAndStartTimers();
        }
      } catch (e) {
        debugPrint("Error in _setupScreen: $e");
      } finally {
        if (mounted) { // Add mounted check
          setState(() {
            _isInitializing = false;
          });
        }
      }
    }



    void _fetchVestingDataAndStartTimers() async {
      if (!mounted) return;

      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      if (walletVM.vestInfo.start != 0) {
        _initializeTimers(walletVM.vestInfo);
      }

      walletVM.addListener(_onVestingDataUpdated);

    }

    void _onVestingDataUpdated() {
      if (!mounted) {
      return;
    }
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      if (walletVM.vestInfo.start != 0) {
        _initializeTimers(walletVM.vestInfo);
        walletVM.removeListener(_onVestingDataUpdated);
      }
    }

    void _initializeTimers(VestingInfo vestInfo) {
      if (!mounted) return;

      // vestingStartDate = DateTime.fromMillisecondsSinceEpoch(vestInfo.start! * 1000).add(const Duration(days: 120)); // For Testing
      // cliffEndTime = DateTime.fromMillisecondsSinceEpoch(vestInfo.cliff! * 1000).subtract(const Duration(days: 120)); // For Testing
      vestingStartDate = DateTime.fromMillisecondsSinceEpoch(vestInfo.start! * 1000);
      cliffEndTime = DateTime.fromMillisecondsSinceEpoch(vestInfo.cliff! * 1000) ;
      fullVestedDate = DateTime.fromMillisecondsSinceEpoch(vestInfo.end! * 1000);

      _startCountdownTimer();
    }

    void _startCountdownTimer() {
      _countdownTimer?.cancel();
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        final now = DateTime.now();

        if (vestingStartDate == null || cliffEndTime == null) {
          print("Vesting dates not yet initialized in _startCountdownTimer. UI should show loading.");
          return;
        }

        if (now.isBefore(vestingStartDate!)) {
          if (isVestingPeriodDurationOver || isCliffPeriodOver) {
            if(mounted){
              setState(() {
                isVestingPeriodDurationOver = false;
                isCliffPeriodOver = false;
                _countdownText = "Vesting Starts Soon";
              });
            }

          }
        } else if (now.isBefore(cliffEndTime!)) {
          if (!isVestingPeriodDurationOver || isCliffPeriodOver) {
            if (mounted) {
              setState(() {
                isVestingPeriodDurationOver = true;
                isCliffPeriodOver = false;
                _countdownText = "Cliff Period Active";
              });
            }
          }
        } else {
          if (!isCliffPeriodOver) {
            if(mounted){
            setState(() {
              isVestingPeriodDurationOver = true;
              isCliffPeriodOver = true;
              _countdownText = "Vesting Active - Claim Available";
            });
          }}
          timer.cancel();
        }
      });
    }


    @override
    void dispose() {
      _countdownTimer?.cancel();
      _searchController.dispose();
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      walletVM.removeListener(_onVestingDataUpdated);
      super.dispose();
    }



    void _onSearchChanged() {
      if (!mounted) return;
      final query = _searchController.text.toLowerCase().trim();

      setState(() {
        _filteredClaimHistory = _claimHistory.where((claim) {
          final amount = claim.amount.replaceAll('ECM ', '').toLowerCase();
          final dateTime = claim.dateTime.toLowerCase();
          final wallet = claim.walletAddress.toLowerCase();

          return amount.contains(query) ||
              dateTime.contains(query) ||
              wallet.contains(query);
        }).toList();
      });
    }




    Future<List<Claim>> fetchClaimHistory() async {
      await Future.delayed(const Duration(seconds: 1));

      return [

        // Claim(
        //   amount: "ECM 120.200",
        //   dateTime: "15 Nov 2025 11:10:20",
        //   walletAddress: "0x9a6fbF46F26625e709c11ca2e84a7f34481bc7d",
        // ),     Claim(
        //   amount: "ECM 258.665",
        //   dateTime: "06 Nov 2025 21:30:48",
        //   walletAddress: "0x298f3EF46F26625e709c11ca2e84a7f34489C71d",
        // ),
        // Claim(
        //   amount: "ECM 100.200",
        //   dateTime: "15 Nov 2025 11:10:20",
        //   walletAddress: "0x9a6fbF46F26625e709c11ca2e84a7f34481bc7d",
        // ),
      ];
    }


    @override
    Widget build(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      final navProvider = Provider.of<NavigationProvider>(context);
      final currentScreenId = navProvider.currentScreenId;
      final navItems = navProvider.drawerNavItems;
      final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

      const baseWidth = 375.0;
      const baseHeight = 812.0;

      double scaleWidth(double size) => size * screenWidth / baseWidth;
      double scaleHeight(double size) => size * screenHeight / baseHeight;
      double scaleText(double size) => size * screenWidth / baseWidth;

      final walletVm = Provider.of<WalletViewModel>(context);

      if(_isInitializing || walletVm.isLoading || walletVm.vestingAddress == null){
        return const Scaffold(
          backgroundColor: Color(0xFF01090B),
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final bool isLoadingVestingData = vestingStartDate == null;

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
                child:
                Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Align(
                      alignment: Alignment.topCenter,
                      child:  Text(
                        'ECM Vesting',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
                        child: isLoadingVestingData || walletVm.isLoading
                            ? const Center(child: CircularProgressIndicator(color: Colors.white))
                            : ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(overscroll: false),

                          child: RefreshIndicator(
                            onRefresh: () async {
                              if(mounted){
                                await walletVm.getVestingInformation();
                              }
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),


                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [


                                  SizedBox(height: screenHeight * 0.02),


                                  /// Vesting Event Timer and Vesting Text
                                  if(!isVestingPeriodDurationOver) ...[

                                    VestingContainer(
                                      width: screenWidth * 0.9,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: screenHeight * 0.02),
                                          if (vestingStartDate != null)
                                            Text(
                                              'Vesting Period Begin on \n${DateFormat('d MMMM yyyy').format(vestingStartDate!)}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: const Color(0xFFFFF5ED),
                                                fontSize: getResponsiveFontSize(context, 22),
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,

                                              ),
                                            ),
                                          SizedBox(height: screenHeight * 0.02),
                                          if (vestingStartDate != null)
                                            ChangeNotifierProvider(
                                              create: (_) {
                                                return CountdownTimerProvider(
                                                  targetDateTime: vestingStartDate!,
                                                );
                                              },
                                              child: CountdownTimer(
                                                scaleWidth: scaleWidth,
                                                scaleHeight: scaleHeight,
                                                scaleText: scaleText,
                                                showMonths: true,
                                              ),
                                            ),
                                          SizedBox(height: screenHeight * 0.03),

                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.02),

                                    /// Vesting Wallet Address
                                    CustomLabeledInputField(
                                      containerWidth: screenWidth * 0.9,
                                      labelText: 'Vesting Wallet:',
                                      hintText: walletVm.vestingAddress ?? "...",
                                      isReadOnly: true,
                                      trailingIconAsset: 'assets/icons/copyImg.svg',
                                      onTrailingIconTap: () {
                                        final vestingAddress = walletVm.vestingAddress;
                                        if(vestingAddress != null && vestingAddress.isNotEmpty){
                                          Clipboard.setData(ClipboardData(text:vestingAddress));
                                          ToastMessage.show(
                                            message: "Vesting Wallet Address copied!",
                                            subtitle: vestingAddress,
                                            type: MessageType.success,
                                            duration: CustomToastLength.SHORT,
                                            gravity: CustomToastGravity.BOTTOM,
                                          );
                                        }
                                      },
                                    ),

                                    SizedBox(height: screenHeight * 0.02),
                                    vestingDetails(screenHeight, screenWidth, context,),
                                    SizedBox(height: screenHeight * 0.9),
                                  ]else ...[
                                    cliffTimerAndClaimSection(screenHeight, screenWidth, context),
                                    SizedBox(height: screenHeight * 0.02),

                                    CustomLabeledInputField(
                                      containerWidth: screenWidth * 0.9,
                                      labelText: 'Vesting Wallet:',
                                      hintText: walletVm.vestingAddress ?? "...",
                                      isReadOnly: true,
                                      trailingIconAsset: 'assets/icons/copyImg.svg',
                                      onTrailingIconTap: () {
                                        final vestingAddress = walletVm.vestingAddress;
                                        if(vestingAddress != null && vestingAddress.isNotEmpty){
                                          Clipboard.setData(ClipboardData(text:vestingAddress));
                                          ToastMessage.show(
                                            message: "Vesting Wallet Address copied!",
                                            subtitle: vestingAddress,
                                            type: MessageType.success,
                                            duration: CustomToastLength.SHORT,
                                            gravity: CustomToastGravity.BOTTOM,
                                          );
                                        }
                                      },
                                    ),

                                    SizedBox(height: screenHeight * 0.02),

                                    vestingSummary(screenHeight,screenWidth,context),

                                    SizedBox(height: screenHeight * 0.02),

                                    claimHistory(screenHeight,screenWidth,context)
                                  ],

                                  // if (isVestingPeriodDurationOver) ...[
                                  //   cliffTimerAndClaimSection(screenHeight, screenWidth, context),
                                  //   SizedBox(height: screenHeight * 0.02),
                                  //
                                  //   CustomLabeledInputField(
                                  //     containerWidth: screenWidth * 0.9,
                                  //     labelText: 'Vesting Wallet:',
                                  //     hintText: "0xE4763679E40basdasd1c4e7d117429",
                                  //     isReadOnly: true,
                                  //     trailingIconAsset: 'assets/icons/copyImg.svg',
                                  //     onTrailingIconTap: () {
                                  //       final vestingAddress = "0xE4763679E40b...1c4e7d117429";
                                  //       if(vestingAddress.isNotEmpty){
                                  //         Clipboard.setData(ClipboardData(text:vestingAddress));
                                  //         ToastMessage.show(
                                  //           message: "Vesting Wallet Address copied!",
                                  //           subtitle: vestingAddress,
                                  //           type: MessageType.success,
                                  //           duration: CustomToastLength.SHORT,
                                  //           gravity: CustomToastGravity.BOTTOM,
                                  //         );
                                  //       }
                                  //     },
                                  //   ),
                                  //
                                  //   SizedBox(height: screenHeight * 0.02),
                                  //
                                  //   vestingSummary(screenHeight,screenWidth,context),
                                  //
                                  //   SizedBox(height: screenHeight * 0.02),
                                  //
                                  //   claimHistory(screenHeight,screenWidth,context)
                                  // ],

                                  SizedBox(height: screenHeight * 0.02),

                                ],
                              ),
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

    Widget vestingDetails(double screenHeight, double screenWidth, BuildContext context) {
       return Consumer<WalletViewModel>(
           builder: (context,walletVM, child) {

             if (walletVM.isLoading && walletVM.balance == null) {
             } else if (walletVM.balance != null) {
               balanceText = walletVM.balance!;

             } else {
               balanceText = "0";
             }

             debugPrint(" vestingDetails Consumer: walletVM.balance = ${walletVM.balance}, displayBalanceText = $balanceText");

            return VestingContainer(
              width: screenWidth * 0.9,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text(
                    'Total Vesting ECM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0XFFFFFFFF),
                      fontSize: getResponsiveFontSize(context, 12),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.001),

                  (walletVM.isLoading && walletVM.balance == null)
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ) : ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors:  [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494),
                        ],
                      ).createShader(bounds);
                    },
                    child: Text(
                      'ECM ${_formatBalance(balanceText)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(context, 22),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  Builder(
                      builder: (context) {

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: VestingDetailInfoRow(
                                iconPath: 'assets/icons/vestingStartDate.svg',
                                title: 'Vesting Start Date',
                                // value: formattedStart,
                                value: vestingStartDate != null ? DateFormat('d MMMM yyyy').format(vestingStartDate!) : '...',

                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Flexible(
                              child: VestingDetailInfoRow(
                                iconPath: 'assets/icons/vestingFullDate.svg',
                                title: 'Full Vested Date',
                                // value: formattedEnd,
                                value: fullVestedDate != null ? DateFormat('d MMMM yyyy').format(fullVestedDate!) : '...',

                              ),
                            ),

                          ],

                        );
                      }
                  ),

                ],
              ),
            );
          }
      );

    }



    Widget cliffTimerAndClaimSection(double screenHeight, double screenWidth, BuildContext context){
      const baseWidth = 335.0;
      const baseHeight = 1600.0;
      double scaleWidth(double size) => size * screenWidth / baseWidth;
      double scaleHeight(double size) => size * screenHeight / baseHeight;
      double scaleText(double size) => size * screenWidth / baseWidth;


      return Consumer<WalletViewModel>(
          builder: (context,walletVM, child) {

            if (walletVM.isLoading && walletVM.balance == null) {

            } else if (walletVM.balance != null) {
              balanceText = walletVM.balance!;
            } else {
              balanceText = "0";
            }
            debugPrint("Dashboard _EcmWithGraphChart Consumer: walletVM.balance = ${walletVM.balance}, displayBalanceText = $balanceText");

            return VestingContainer(
              width: screenWidth * 0.9,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text(
                    'Total Vesting ECM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0XFFFFFFFF),
                      fontSize: getResponsiveFontSize(context, 12),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.001),

                  (walletVM.isLoading && walletVM.balance == null)
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ) : ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: const [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494),
                        ],
                      ).createShader(bounds);
                    },
                    child: Text(
                      'ECM ${_formatBalance(balanceText)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(context, 22),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),


                  /// Timer for cliff period
                  if(!isCliffPeriodOver ) ...[
                    Text(
                      'Once the cliff period ends, you can claim your ECM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0XFFFFFFFF),
                        fontSize: getResponsiveFontSize(context, 12),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ChangeNotifierProvider(
                      create: (_) {
                        return CountdownTimerProvider(
                          targetDateTime: cliffEndTime!,

                        );
                      },
                      child: Builder(
                          builder: (context) {

                            return CountdownTimer(
                              scaleWidth: scaleWidth,
                              scaleHeight: scaleHeight,
                              scaleText: scaleText,
                              gradientColors: [
                                Color(0xFF2680EF).withAlpha(60),
                                Color(0xFF1CD494).withAlpha(60)
                              ],

                              showMonths: true,
                            );
                          }
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),
                  ],

                  if(isCliffPeriodOver)...[
                    /// When the cliff period ends, you can claim your ECM
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: VestingDetailInfoRow(
                              iconPath: 'assets/icons/checkIcon.svg',
                              title: 'Claimed',
                              // value: 'ECM 125.848',
                              value: 'ECM ${walletVM.vestInfo.released?.toStringAsFixed(6) ?? 'Loading ...'}',
                              iconSize: screenHeight *0.025,

                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Flexible(
                            child: VestingDetailInfoRow(
                              iconPath: 'assets/icons/claimedIcon.svg',
                              title: 'Available claim',
                              // value: 'ECM 52.152',
                              value: 'ECM ${walletVM.availableClaimableAmount.toStringAsFixed(6)}',
                               iconSize: screenHeight *0.032,

                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    BlockButton(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.8,
                        label:"CLAIM",
                        textStyle:  TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: getResponsiveFontSize(context, 16),
                          height: 1.6,
                        ),
                        gradientColors: const [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494)
                        ],
                        // onTap: (){
                        //   final newClaim = Claim(
                        //     amount: "ECM 50.000",
                        //     dateTime: DateFormat("dd MMM yyyy HH:mm:ss").format(DateTime.now()),
                        //     walletAddress: walletVm.walletAddress,
                        //   );
                        //
                        //   setState(() {
                        //     _claimHistory.insert(0, newClaim);
                        //     _onSearchChanged();
                        //   });
                        //
                        //   ToastMessage.show(
                        //     message: "Claim successful!",
                        //     type: MessageType.success,
                        //   );
                        // }

                      onTap: walletVM.isLoading ? null : (){
                        walletVM.claimECM(context);
                      }

                    ),
                  ],





                ],
              ),
            );
          }
      );
    }


    Widget vestingSummary(double screenHeight, double screenWidth, BuildContext context){

      final dateFormat = DateFormat('d MMMM, yyyy');
      String formattedVestingStart = "Loading...";
      String formattedCliffEnd = "Loading...";
      String formattedFullVested = "Loading...";
      String totalVestingPeriodStr = "Calculating...";
      String cliffPeriodStr = "Calculating...";


      if (vestingStartDate != null) {
        formattedVestingStart = dateFormat.format(vestingStartDate!);
      }
      if (fullVestedDate != null) {
        formattedFullVested = dateFormat.format(fullVestedDate!);
      }
      if (cliffEndTime != null) {
        formattedCliffEnd = dateFormat.format(cliffEndTime!); // For "Cliff Info"
      }

      // Calculate durations if all dates are available
      if (vestingStartDate != null && fullVestedDate != null) {
        Duration totalDuration = fullVestedDate!.difference(vestingStartDate!);
        totalVestingPeriodStr = _formatOverallDuration(totalDuration);
      }

      if (vestingStartDate != null && cliffEndTime != null) {
        Duration cliffDuration = cliffEndTime!.difference(vestingStartDate!);
        cliffPeriodStr = _formatOverallDuration(cliffDuration);
      }


      return VestingContainer(
        width: screenWidth * 0.9,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              'Vesting Summary',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0XFFFFFFFF),
                fontSize: getResponsiveFontSize(context, 16),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            VestingSummaryRow(
              label: 'Vesting Start Date',
              value: formattedVestingStart,
            ),

            SizedBox(height: screenHeight * 0.01),

            VestingSummaryRow(
              label: 'Vesting Period',
              value: totalVestingPeriodStr,
            ),


            SizedBox(height: screenHeight * 0.01),

            VestingSummaryRow(
                label: 'Cliff Info',
                value: '$cliffPeriodStr until $formattedCliffEnd'
            ),


            SizedBox(height: screenHeight * 0.01),

            VestingSummaryRow(
              label: 'Full Vested Date',
              value: formattedFullVested,
            ),

            SizedBox(height: screenHeight * 0.02),
            if (vestingStartDate != null && fullVestedDate != null)
              ECMProgressIndicator(

                vestingStartDate:  vestingStartDate!,
                fullVestedDate: fullVestedDate!,
              ),

          ],
        ),
      );
    }


    Widget claimHistory(double screenHeight, double screenWidth, BuildContext context){
      return VestingContainer(
          width: screenWidth * 0.9,
          height: screenHeight * 0.5,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Title + Search Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Claim History',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0XFFFFFFFF),
                      fontSize: getResponsiveFontSize(context, 16),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: _isSearchOpen ? screenWidth * 0.5 : screenHeight * 0.034,
                    child: _isSearchOpen
                        ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.008,
                          horizontal: screenWidth * 0.02,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSearchOpen = false;
                              _searchController.clear();
                              _onSearchChanged();
                            });
                          },
                          child: const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                      onChanged: (value) => _onSearchChanged(),
                    )
                        : GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSearchOpen = true;
                        });
                      },
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        fit: BoxFit.contain,
                        height: screenHeight * 0.034,
                      ),
                    ),
                  )


                ],
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: const Divider(
                  color: Colors.white12,
                  thickness: 1,
                  height: 15,
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              /// Fetch Claim History

              Expanded(
                child: _filteredClaimHistory.isEmpty
                    ?  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/images/noDataFoundImg.png',
                          fit: BoxFit.contain,
                          height: screenHeight * 0.2,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        "No Data Founds",
                        style: TextStyle(
                          color: Color(0XFF7D8FA9),
                          fontSize: getResponsiveFontSize(context, 12) ,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredClaimHistory.length,
                  separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.01),
                  itemBuilder: (context, index) {
                    final claim = _filteredClaimHistory[index];
                    return ClaimHistoryCard(
                      amount: claim.amount,
                      dateTime: claim.dateTime,
                      walletAddress: claim.walletAddress,
                      buttonLabel: "Explore",
                      onButtonTap: () {
                        debugPrint("Explore tapped for ${claim.walletAddress}");
                      },
                    );
                  },
                ),
              ),
            ],
          )
      );
    }

  }

String _formatOverallDuration(Duration duration) {
  if (duration.inDays < 0) return "N/A";

  int years = duration.inDays ~/ 365;
  int remainingDaysAfterYears = duration.inDays % 365;
  int months = remainingDaysAfterYears ~/ 30;

  List<String> parts = [];
  if (years > 0) {
    parts.add("$years year${years > 1 ? 's' : ''}");
  }
  if (months > 0) {
    parts.add("$months month${months > 1 ? 's' : ''}");
  }
  if (parts.isEmpty) {

    if (duration.inDays > 0) return "${duration.inDays} day${duration.inDays > 1 ? 's' : ''}";
    return "Approx. ${duration.inHours} hours";
  }
  return parts.join(', ');
}




String _formatBalance(String balance) {
  if (balance.length <= 6) return balance;
  return '${balance.substring(0, 9)}';
}