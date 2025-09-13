import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/vesting/vesting_Item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/VestingContainer.dart';
import '../../../../../framework/components/VestingSummaryRow.dart';
import '../../../../../framework/components/buy_ecm_button.dart';
import '../../../../../framework/components/claimHistoryCard.dart';
import '../../../../../framework/components/disconnectButton.dart';
import '../../../../../framework/components/loader.dart';
import '../../../../../framework/components/vestingDetailRow.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../presentation/countdown_timer_helper.dart';
import '../../../../presentation/screens/bottom_nav_bar.dart';
import '../../../../presentation/viewmodel/bottom_nav_provider.dart';
import '../../../../presentation/viewmodel/countdown_provider.dart';
import '../../../../presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/dashboard_nav_provider.dart';
import '../../viewmodel/side_navigation_provider.dart';
import 'helper/claim.dart';
import 'helper/vesting_info.dart';
import 'package:intl/intl.dart';
class ExistingVestingWrapper extends StatefulWidget {
  const ExistingVestingWrapper({super.key});

  @override
  State<ExistingVestingWrapper> createState() => _ExistingVestingWrapperState();
}

class _ExistingVestingWrapperState extends State<ExistingVestingWrapper> with AutomaticKeepAliveClientMixin {
  bool _isFetchingData = false;
  bool _hasInitialized = false;
  WalletViewModel? _walletVM;
  bool isDisconnecting = false;



  @override
  void initState() {
    super.initState();
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    walletVM.addListener(_onWalletAddressChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        _hasInitialized = true;
        _fetchVestingDataIfConnected();
      }
    });

  }

  void _onWalletAddressChanged() {
    if (!mounted || _isFetchingData) return;
    // final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    if (_walletVM != null && _walletVM!.isConnected && _walletVM!.walletAddress.isNotEmpty) {
      _fetchVestingDataIfConnected();
    }

  }

  void _fetchVestingDataIfConnected() async {
    if (_isFetchingData) return;
    if (!_walletVM!.isConnected || _walletVM!.walletAddress.isEmpty) {
      debugPrint('Wallet not connected, skipping vesting data fetch');
      return;
    }


    try {
      _isFetchingData = true;

      if (_walletVM!.existingVestingAddress != null && _walletVM!.vestInfo.start == 0) {
        debugPrint('Fetching Existing vesting information...');
        await _walletVM!.getExistingVestingInformation();

        // Fetch balance only if vesting address is available
        if (_walletVM!.existingVestingAddress != null && _walletVM!.existingVestingAddress!.isNotEmpty) {
          debugPrint('Fetching vesting balance...');
          await _walletVM!.getBalance(forAddress: _walletVM!.existingVestingAddress);

        }
      }
    } catch (e) {
      debugPrint('Error fetching vesting data: $e');
    } finally {
      _isFetchingData = false;
    }

  }



  @override
  void dispose() {
    if (_walletVM != null) {
      _walletVM!.removeListener(_onWalletAddressChanged);
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<WalletViewModel>(
      builder: (context, walletVM, child) {

        _walletVM = walletVM;

        debugPrint('ExistingVestingWrapper Consumer isLoading: ${walletVM.isLoading},'
            ' existingVestingAddress: ${walletVM.existingVestingAddress},existingVestingStatus: ${walletVM.existingVestingStatus}');
        debugPrint('walletAddress: ${walletVM.walletAddress}');
        debugPrint('Existing vestingAddress: ${walletVM.existingVestingAddress}');
        debugPrint('Existing Vesting balance: ${walletVM.balance}');



        // Check if wallet is connected
        if (!walletVM.isConnected || walletVM.walletAddress.isEmpty) {
          return Scaffold(
            backgroundColor: const Color(0xFF01090B),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Connection lost Please restart your app or connect your wallet to view vesting details.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),

                  CustomGradientButton(
                    label: 'Retry',
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.05,
                    onTap: ()async{
                      if (!mounted) return;
                      await context.read<WalletViewModel>().openWalletModal(context);
                    },
                    gradientColors: const [
                      Color(0xFF2D8EFF),
                      Color(0xFF2EE4A4)
                    ],
                  ),

                  const SizedBox(height: 20),
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
                ],
              ),
            ),
          );
        }

        return ExistingUserVesting(
          // key: ValueKey(walletVM.existingVestingStatus ?? 'initial'),
          // key: ValueKey('${walletVM.existingVestingStatus}_${walletVM.vestInfo.start ?? 0}'),
          key: ValueKey('${walletVM.existingVestingStatus}_${walletVM.vestInfo.start ?? 0}_${walletVM.balance ?? '0'}_${walletVM.isLoading}'),
          onStartVestingComplete: () async {
            await walletVM.getExistingVestingInformation();
            if (mounted) {
              setState(() {});
            }
          },
          isPostVesting: walletVM.existingVestingStatus != null,
          vestingInfo:  walletVM.vestInfo,
          vestingStatus: walletVM.existingVestingStatus,
          vestingBalance: walletVM.balance ?? '0',
        );

      },
    );
  }

  @override
  bool get wantKeepAlive => true;

}

class ExistingUserVesting extends StatefulWidget {
  // final VoidCallback? onStartVestingComplete;
  final Future<void> Function()? onStartVestingComplete;
  final bool isPostVesting;
  final VestingInfo vestingInfo;
  final String? vestingStatus;
  final String vestingBalance;

  const ExistingUserVesting({
    super.key,
    this.onStartVestingComplete,
    this.isPostVesting = false,
    required this.vestingInfo,
    this.vestingStatus,
    required this.vestingBalance,
  });

  @override
  State<ExistingUserVesting> createState() => _ExistingUserVestingState();
}

class _ExistingUserVestingState extends State<ExistingUserVesting> {
  String balanceText = '...';
  bool _isStartingVesting = false;
  bool _localLoading = true;
  Timer? _loadingTimeout;

  DateTime? existingVestingStartDate;
  DateTime? cliffEndTime;
  DateTime? fullVestedDate;
  Timer? _countdownTimer;
  bool isCliffPeriodOver = false;
  String _countdownText = '';
  bool _isSearchOpen = false;

  TextEditingController _searchController = TextEditingController();


  List<Claim> _claimHistory = [];
  List<Claim> _filteredClaimHistory = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    _startLoadingTimeout();
    balanceText = widget.vestingBalance;
    if(widget.isPostVesting){
      _initializeTimers(widget.vestingInfo);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchClaimHistory().then((claims) {
        if (mounted) {
          setState(() {
            _claimHistory = claims;
            _filteredClaimHistory = claims;
          });
        }
      });

      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      try{
        await walletVM.ensureModalWithValidContext(context);
        await walletVM.rehydrate();
        await walletVM.getBalance();
        await walletVM.getExistingVestingInformation();
        print('initState: Vesting status = ${walletVM.existingVestingStatus}, vestInfo = ${walletVM.vestInfo.toString()}');
        if (mounted) {
          setState(() {
            balanceText = walletVM.balance ?? '0';
          });
        }
      }catch (e) {
        print('initState Error: $e');
      }finally {
        WidgetsBinding.instance.addPostFrameCallback((_) => _endLoading());
      }

       if(mounted){
        setState(() {});
      }
     });
  }
  void _startLoadingTimeout() {
    _loadingTimeout = Timer(const Duration(seconds: 3), () {
      if (_localLoading) {
        print('Loading timeout - forcing end of loading state');
        _endLoading();
      }
    });
  }
  void _endLoading() {
    if (mounted) {
      setState(() {
        _localLoading = false;
      });
      print('Loading ended: Local loading = false');
    }
    _loadingTimeout?.cancel();
  }
  void _onSearchChanged() {
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
  void dispose() {
    _loadingTimeout?.cancel();
    _countdownTimer?.cancel();
    _searchController.dispose();

    super.dispose();
  }

  double getUserBalance(WalletViewModel walletVM) {
    return double.tryParse(walletVM.balance ?? '0') ?? 0.0;
  }

  void _initializeTimers(VestingInfo vestInfo) {
    if (!mounted) return;
    existingVestingStartDate = DateTime.fromMillisecondsSinceEpoch(vestInfo.start! * 1000);
    cliffEndTime = DateTime.fromMillisecondsSinceEpoch(vestInfo.cliff! * 1000);
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
      if (existingVestingStartDate == null || cliffEndTime == null) return;
      if (now.isBefore(existingVestingStartDate!)) {
        setState(() {
          _countdownText = "Vesting Starts Soon";
        });
      } else if (now.isBefore(cliffEndTime!)) {
        setState(() {
          isCliffPeriodOver = false;
          _countdownText = "Cliff Period Active";
        });
      } else {
        setState(() {
          isCliffPeriodOver = true;
          _countdownText = "Vesting Active - Claim Available";
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    debugPrint('Building ExistingUserVesting with isPostVesting: ${widget.isPostVesting}, vestingStatus: ${widget.vestingStatus}, balance: ${widget.vestingBalance}');
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/back_button.svg',
                          color: Colors.white,
                          width: screenWidth * 0.04,
                          height: screenWidth * 0.04,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
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
                      ),
                      SizedBox(width: screenWidth * 0.12),
                    ],
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
                            setState(() {
                              _localLoading = true;
                            });
                            _startLoadingTimeout();
                            try{
                              await walletVM.ensureModalWithValidContext(context);
                              await walletVM.rehydrate();
                              await walletVM.getBalance();
                              await walletVM.getExistingVestingInformation();
                              print('Refresh: Vesting status = ${walletVM.existingVestingStatus}');
                              if (mounted) {
                                setState(() {
                                  balanceText = walletVM.balance ?? '0';
                                });
                              }
                            }catch (e) {
                              print('Refresh Error: $e');
                            } finally {
                              Future.delayed(const Duration(milliseconds: 500), () {
                                _endLoading();
                              });
                            }

                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),


                            child: Consumer<WalletViewModel>(
                              builder: (context , walletVM, child){

                                final userBalance = getUserBalance(walletVM);
                                  return Column(
                                   children: [
                                     totalBalance(screenHeight, screenWidth, context, walletVM ,userBalance,widget.isPostVesting),
                                     SizedBox(height: screenHeight * 0.02),
                                     whyVesting(screenHeight, screenWidth, context),
                                     SizedBox(height: screenHeight * 0.09),


                                     // if(widget.isPostVesting && widget.vestingStatus != null)
                                     // if(widget.isPostVesting && widget.vestingStatus != null && widget.vestingStatus!.isNotEmpty)
                                     //   ...[
                                     //     SizedBox(height: screenHeight * 0.02),
                                     //     cliffTimerAndClaimSection(screenHeight, screenWidth, context, walletVM),
                                     //     SizedBox(height: screenHeight * 0.02),
                                     //     vestingSummary(screenHeight, screenWidth, context),
                                     //     SizedBox(height: screenHeight * 0.02),
                                     //     claimHistory(screenHeight, screenWidth, context),
                                     //   ],

///
//                                       if (widget.vestingStatus == 'process' || widget.vestingStatus == 'locked')
//                                        ...[
//                                          SizedBox(height: screenHeight * 0.02),
//                                          cliffTimerAndClaimSection(screenHeight, screenWidth, context, walletVM),
//                                          SizedBox(height: screenHeight * 0.02),
//                                          vestingSummary(screenHeight, screenWidth, context),
//                                          SizedBox(height: screenHeight * 0.02),
//                                          claimHistory(screenHeight, screenWidth, context),
//                                        ]
//                                      else if (widget.vestingStatus == 'locked')
//                                        VestingLockWidget(
//                                          vestInfo: widget.vestingInfo,
//                                          walletVM: walletVM,
//                                          onCountdownReady: () => walletVM.getExistingVestingInformation(),
//                                        ),

                                     if (widget.vestingStatus != null)
                                       ...[
                                         SizedBox(height: screenHeight * 0.02),
                                         if (widget.vestingStatus == 'locked')
                                           VestingLockWidget(
                                             vestInfo: widget.vestingInfo,
                                             walletVM: walletVM,
                                             onCountdownReady: () => walletVM.getExistingVestingInformation(),
                                           ),
                                         if (widget.vestingStatus == 'process')
                                           cliffTimerAndClaimSection(screenHeight, screenWidth, context, walletVM),
                                         if (widget.vestingStatus == 'process') ...[
                                           SizedBox(height: screenHeight * 0.02),
                                           vestingSummary(screenHeight, screenWidth, context),
                                           SizedBox(height: screenHeight * 0.02),
                                           claimHistory(screenHeight, screenWidth, context),
                                         ],
                                       ],

                                   ],
                                 );


                              }
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

  Widget totalBalance(double screenHeight,double screenWidth,BuildContext context,WalletViewModel walletVm ,double userBalance, bool isPostVesting){
    final isLowBalance = userBalance <= 1;
    // final displayBalance = widget.vestingStatus != null ? widget.vestingInfo.totalVestingAmount?.toStringAsFixed(2) : _formatBalance(balanceText);
    return VestingContainer(
            width: screenWidth * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: screenHeight * 0.02),

                Text(
                  'Total Balance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0XFFFFF5ED),
                    fontSize: getResponsiveFontSize(context, 12),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: screenHeight * 0.001),
                ShaderMask(
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
                    // 'ECM $displayBalance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 22),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                BlockButton(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.8,
                  label: _isStartingVesting ? "Starting.." : "Start Vesting",
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
                  // onTap:!isPostVesting && !isLowBalance && !_isStartingVesting
                  onTap: widget.vestingStatus == null && !isLowBalance && !_isStartingVesting
                      ? () async{
                    print('Start Vesting button clicked - initiating process');
                    setState(() {
                      _isStartingVesting = true;
                    });

                    try{
                      await walletVm.startVesting(context);
                      print('Start Vesting completed - navigating to vesting status screen');
                      if (widget.onStartVestingComplete != null) {
                        await widget.onStartVestingComplete!();
                      }

                      await walletVm.getBalance();

                      if (mounted) {
                        setState(() {
                          balanceText = walletVm.balance ?? '0';
                          _initializeTimers(widget.vestingInfo);
                        });
                      }

                    } catch (e) {
                      print('totalBalance: startVesting error: $e');
                    }finally{
                      if(mounted){
                        setState(() {
                          _isStartingVesting = false;
                        });
                      }
                    }
                  } : null,

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
        "text": "Vesting is the process of gradually unlocking your ECM tokens over time, instead of receiving them all at once. This helps protect token value and ensures long-term commitment from holders."
      },

      {
        "image": "assets/images/vestingImg2.png",
        "text": "Without vesting, your tokens will remain non-tradable. Only vested tokens can be listed and traded once ECM goes live at the end of Q1 2026."
      },
      {
        "image": "assets/images/vestingImg3.png",
        "text": "During the cliff, your tokens are vesting in the background but cannot be claimed. Once the cliff ends, all tokens vested up to that point will become claimable immediately."
      },
      {
        "image": "assets/images/vestingImg4.png",
        "text": "Linear vesting means your tokens unlock gradually every second. After the cliff, you don’t need to wait for monthly unlocks — your vested balance grows continuously and can be claimed at any time."
      },
      {
        "image": "assets/images/vestingImg5.png",
        "text": "Vesting gives you tradability at listing, protects ECM’s price by preventing oversupply, and makes you eligible for exclusive rewards, ecosystem benefits, and stronger community participation."
      },
      {
        "image": "assets/images/moneyVesting.png",
        "text": "No. Claims are only possible after the cliff period is over. At that time, the tokens vested during the cliff will be released to you."
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

  Widget cliffTimerAndClaimSection(double screenHeight, double screenWidth, BuildContext context, WalletViewModel walletVM) {
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
              color: Color(0xFFFFFFFF),
              fontSize: getResponsiveFontSize(context, 12),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: screenHeight * 0.001),
          ShaderMask(
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
          if (!isCliffPeriodOver) ...[
            Text(
              'Once the cliff period ends, you can claim your ECM',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: getResponsiveFontSize(context, 12),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            ChangeNotifierProvider(
              create: (_) => CountdownTimerProvider(targetDateTime: cliffEndTime!),
              child: Builder(
                builder: (context) => CountdownTimer(
                  scaleWidth: (size) => size * screenWidth / 335.0,
                  scaleHeight: (size) => size * screenHeight / 1600.0,
                  scaleText: (size) => size * screenWidth / 335.0,
                  gradientColors: [
                    Color(0xFF2680EF).withAlpha(60),
                    Color(0xFF1CD494).withAlpha(60)
                  ],
                  showMonths: true,
                ),
              ),
            ),
          ],
          if (isCliffPeriodOver) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: VestingDetailInfoRow(
                      iconPath: 'assets/icons/checkIcon.svg',
                      title: 'Claimed',
                      value: 'ECM ${walletVM.vestInfo.released?.toStringAsFixed(6) ?? '0.0'}',
                      iconSize: screenHeight * 0.025,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Flexible(
                    child: VestingDetailInfoRow(
                      iconPath: 'assets/icons/claimedIcon.svg',
                      title: 'Available claim',
                      value: 'ECM ${walletVM.vestInfo.claimable?.toStringAsFixed(6)}',
                      iconSize: screenHeight * 0.032,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            BlockButton(
              height: screenHeight * 0.05,
              width: screenWidth * 0.8,
              label: "CLAIM",
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: getResponsiveFontSize(context, 16),
                height: 1.6,
              ),
              gradientColors: const [
                Color(0xFF2680EF),
                Color(0xFF1CD494)
              ],
              onTap: walletVM.isLoading ? null : () => walletVM.claimECM(context),
            ),
          ],
        ],
      ),
    );
  }


  Widget vestingSummary(double screenHeight, double screenWidth, BuildContext context) {
    final dateFormat = DateFormat('d MMMM, yyyy');
    String formattedVestingStart = existingVestingStartDate != null ? dateFormat.format(existingVestingStartDate!) : 'Loading...';
    String formattedCliffEnd = cliffEndTime != null ? dateFormat.format(cliffEndTime!) : 'Loading...';
    String formattedFullVested = fullVestedDate != null ? dateFormat.format(fullVestedDate!) : 'Loading...';
    String totalVestingPeriodStr = 'Calculating...';
    String cliffPeriodStr = 'Calculating...';

    if (existingVestingStartDate != null && fullVestedDate != null) {
      Duration totalDuration = fullVestedDate!.difference(existingVestingStartDate!);
      totalVestingPeriodStr = _formatOverallDuration(totalDuration);
    }
    if (existingVestingStartDate != null && cliffEndTime != null) {
      Duration cliffDuration = cliffEndTime!.difference(existingVestingStartDate!);
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
              color: Color(0xFFFFFFFF),
              fontSize: getResponsiveFontSize(context, 16),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          VestingSummaryRow(label: 'Vesting Start Date', value: formattedVestingStart),
          SizedBox(height: screenHeight * 0.01),
          VestingSummaryRow(label: 'Vesting Period', value: totalVestingPeriodStr),
          SizedBox(height: screenHeight * 0.01),
          VestingSummaryRow(label: 'Cliff Info', value: '$cliffPeriodStr until $formattedCliffEnd'),
          SizedBox(height: screenHeight * 0.01),
          VestingSummaryRow(label: 'Full Vested Date', value: formattedFullVested),
          SizedBox(height: screenHeight * 0.02),
          if (existingVestingStartDate != null && fullVestedDate != null)
            ECMProgressIndicator(vestingStartDate: existingVestingStartDate!, fullVestedDate: fullVestedDate!),
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


// class VestingStatusScreen extends StatelessWidget {
//   final WalletViewModel walletVM;
//
//   const VestingStatusScreen({
//     super.key,
//     required this.walletVM,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF01090B),
//       body: SafeArea(
//         child: Consumer<WalletViewModel>(
//           builder: (context, walletVM, child) {
//             if (walletVM.vestingStatus == 'locked') {
//               return VestingLockWidget(
//                 vestInfo: walletVM.vestInfo,
//                 walletVM: walletVM,
//                 onCountdownReady: () => walletVM.getExistingVestingInformation(),
//               );
//             } else if (walletVM.vestingStatus == 'process') {
//               final total = walletVM.vestInfo.totalVestingAmount ?? 0.0;
//               if (total == 0.0) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Loading vesting details...',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     SizedBox(height: screenHeight * 0.02),
//                     BlockButton(
//                       height: screenHeight * 0.05,
//                       width: screenWidth * 0.6,
//                       label: 'Refresh Vesting',
//                       onTap: () => walletVM.getExistingVestingInformation(),
//                       gradientColors: const [Color(0xFF2680EF), Color(0xFF1CD494)],
//                     ),
//                   ],
//                 );
//               }
//               return VestingProcessWidget(
//                 vestInfo: walletVM.vestInfo,
//                 walletVM: walletVM,
//                 onClaim: () => walletVM.claimECM(context),
//               );
//             } else {
//               // Fallback to start screen if status null after vesting
//               return Column(
//                 children: [
//                   Text('Vesting initiated. Refreshing...', style: TextStyle(color: Colors.white)),
//                   SizedBox(height: screenHeight * 0.02),
//                   BlockButton(
//                     height: screenHeight * 0.05,
//                     width: screenWidth * 0.6,
//                     label: 'Refresh',
//                     onTap: () => walletVM.getExistingVestingInformation(),
//                     gradientColors: const [Color(0xFF2680EF), Color(0xFF1CD494)],
//                   ),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class VestingLockWidget extends StatefulWidget {
//   final VestingInfo vestInfo;
//   final WalletViewModel walletVM;
//   final VoidCallback onCountdownReady;
//
//   const VestingLockWidget({
//     super.key,
//     required this.vestInfo,
//     required this.walletVM,
//     required this.onCountdownReady,
//   });
//
//   @override
//   State<VestingLockWidget> createState() => _VestingLockWidgetState();
// }
//
// class _VestingLockWidgetState extends State<VestingLockWidget> {
//   late Duration remainingTime;
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _updateRemainingTime();
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       _updateRemainingTime();
//       if (remainingTime <= Duration.zero) {
//         timer.cancel();
//         widget.onCountdownReady();
//         print('VestingLockWidget: Countdown reached zero, refreshing status');
//       }
//     });
//   }
//
//   void _updateRemainingTime() {
//     final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//     final start = widget.vestInfo.start;
//     if (start! > now) {
//       setState(() {
//         remainingTime = Duration(seconds: start - now);
//       });
//     } else {
//       remainingTime = Duration.zero;
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   String _formatDuration(Duration duration) {
//     final days = duration.inDays;
//     final hours = duration.inHours % 24;
//     final minutes = duration.inMinutes % 60;
//     final seconds = duration.inSeconds % 60;
//     return '$days days $hours hrs $minutes min $seconds sec';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return VestingContainer(
//       width: screenWidth * 0.9,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: screenHeight * 0.02),
//           Text(
//             'Vesting Locked',
//             style: TextStyle(
//               color: Color(0XFFFFF5ED),
//               fontSize: getResponsiveFontSize(context, 16),
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.01),
//           Text(
//             'Time until vesting starts:',
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: getResponsiveFontSize(context, 14),
//               fontFamily: 'Poppins',
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.01),
//           ShaderMask(
//             blendMode: BlendMode.srcIn,
//             shaderCallback: (Rect bounds) {
//               return LinearGradient(
//                 colors: const [
//                   Color(0xFF2680EF),
//                   Color(0xFF1CD494),
//                 ],
//               ).createShader(bounds);
//             },
//             child: Text(
//               _formatDuration(remainingTime),
//               style: TextStyle(
//                 fontSize: getResponsiveFontSize(context, 20),
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.02),
//           Text(
//             'Total Vesting Amount: ${widget.vestInfo.totalVestingAmount?.toStringAsFixed(2)} ECM',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: getResponsiveFontSize(context, 14),
//               fontFamily: 'Poppins',
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.02),
//         ],
//       ),
//     );
//   }
// }
//
// class VestingProcessWidget extends StatelessWidget {
//   final VestingInfo vestInfo;
//   final WalletViewModel walletVM;
//   final VoidCallback onClaim;
//
//   const VestingProcessWidget({
//     super.key,
//     required this.vestInfo,
//     required this.walletVM,
//     required this.onClaim,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final vested = walletVM.vestedAmount ?? 0.0;
//     final claimable = walletVM.availableClaimableAmount ?? 0.0;
//     final total = walletVM.vestInfo.totalVestingAmount ?? 0.0;
//     final progress = total > 0 ? vested / total : 0.0;
//     if (total == 0.0) {
//
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Loading vesting details...',
//               style: TextStyle(color: Colors.white, fontSize: getResponsiveFontSize(context, 16)),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             BlockButton(
//               height: screenHeight * 0.05,
//               width: screenWidth * 0.6,
//               label: 'Refresh Vesting',
//               onTap: () => walletVM.getExistingVestingInformation(), gradientColors: [Color(0xFF2680EF), Color(0xFF1CD494),],
//             ),
//           ],
//         ),
//       );
//     }
//     return VestingContainer(
//       width: screenWidth * 0.9,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: screenHeight * 0.02),
//           Text(
//             'Vesting in Progress',
//             style: TextStyle(
//               color: Color(0XFFFFF5ED),
//               fontSize: getResponsiveFontSize(context, 16),
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.01),
//           Text(
//             'Vested: ${vested.toStringAsFixed(2)} / ${total.toStringAsFixed(2)} ECM',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: getResponsiveFontSize(context, 14),
//               fontFamily: 'Poppins',
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.01),
//           LinearProgressIndicator(
//             value: progress,
//             backgroundColor: Colors.white24,
//             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1CD494)),
//             minHeight: 8,
//           ),
//           SizedBox(height: screenHeight * 0.01),
//           Text(
//             'Claimable: ${claimable.toStringAsFixed(2)} ECM',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: getResponsiveFontSize(context, 14),
//               fontFamily: 'Poppins',
//             ),
//           ),
//           SizedBox(height: screenHeight * 0.02),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               BlockButton(
//                 height: screenHeight * 0.05,
//                 width: screenWidth * 0.4,
//                 label: 'Claim Now',
//                 textStyle: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                   fontSize: getResponsiveFontSize(context, 16),
//                   height: 1.6,
//                 ),
//                 gradientColors: const [
//                   Color(0xFF2680EF),
//                   Color(0xFF1CD494),
//                 ],
//                 onTap: onClaim,
//               ),
//               SizedBox(width: screenWidth * 0.02),
//               BlockButton(
//                 height: screenHeight * 0.05,
//                 width: screenWidth * 0.4,
//                 label: 'Refresh',
//                 textStyle: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                   fontSize: getResponsiveFontSize(context, 16),
//                   height: 1.6,
//                 ),
//                 gradientColors: const [
//                   Color(0xFF2680EF),
//                   Color(0xFF1CD494),
//                 ],
//                 onTap: () async {
//                   try {
//                     await walletVM.refreshVesting();
//                     print('VestingProcessWidget: refreshVesting completed');
//                   } catch (e) {
//                     print('VestingProcessWidget: refreshVesting error: $e');
//                   }
//                 },
//               ),
//             ],
//           ),
//           SizedBox(height: screenHeight * 0.02),
//         ],
//       ),
//     );
//   }
// }
//
















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
  try {
    final value = double.parse(balance);
    return value.toStringAsFixed(2);
  } catch (e) {
    return balance;
  }
}
// String _formatBalance(String balance) {
//   if (balance.length <= 6) return balance;
//   return '${balance.substring(0, 9)}';
// }




class VestingLockWidget extends StatefulWidget {
  final VestingInfo vestInfo;
  final WalletViewModel walletVM;
  final VoidCallback onCountdownReady;

  const VestingLockWidget({
    required this.vestInfo,
    required this.walletVM,
    required this.onCountdownReady,
    super.key,
  });

  @override
  State<VestingLockWidget> createState() => _VestingLockWidgetState();
}

class _VestingLockWidgetState extends State<VestingLockWidget> {
  late DateTime _startDate;
  Timer? _countdownTimer;
  String _countdownText = 'Calculating...';

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.fromMillisecondsSinceEpoch(widget.vestInfo.start! * 1000);
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
      if (now.isBefore(_startDate)) {
        final difference = _startDate.difference(now);
        setState(() {
          _countdownText = '${difference.inDays}d ${difference.inHours.remainder(24)}h ${difference.inMinutes.remainder(60)}m ${difference.inSeconds.remainder(60)}s until vesting starts';
        });
      } else {
        setState(() {
          _countdownText = 'Vesting has started';
        });
        timer.cancel();
        widget.onCountdownReady();
      }
    });
  }


  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VestingContainer(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.02,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Vesting Locked',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: getResponsiveFontSize(context, 16),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            _countdownText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF7D8FA9),
              fontSize: getResponsiveFontSize(context, 14),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}