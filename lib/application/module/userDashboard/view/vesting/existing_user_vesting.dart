import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/domain/constants/api_constants.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/vesting/vesting_Item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/VestingContainer.dart';
import '../../../../../framework/components/VestingSummaryRow.dart';
import '../../../../../framework/components/buy_ecm_button.dart';
import '../../../../../framework/components/claimHistoryCard.dart';
import '../../../../../framework/components/disconnectButton.dart';
import '../../../../../framework/components/loader.dart';
import '../../../../../framework/components/vestingDetailRow.dart';
import '../../../../../framework/utils/customToastMessage.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/toast_type.dart';
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
import 'package:http/http.dart'as http;


class Tuple3<A, B, C> {
  final A item1;
  final B item2;
  final C item3;
  Tuple3(this.item1, this.item2, this.item3);
}

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
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        _hasInitialized = true;
        final walletVM = Provider.of<WalletViewModel>(context, listen: false);
        walletVM.addListener(_onWalletAddressChanged);
        _walletVM = walletVM;
        _fetchVestingDataIfConnected();
        // _checkAndOpenModal();
      }
    });
  }

  void _onWalletAddressChanged() {
    if (!mounted || _isFetchingData) return;
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      if (_walletVM != null && _walletVM!.isConnected && _walletVM!.walletAddress.isNotEmpty) {
        _fetchVestingDataIfConnected();
      }

      // else{
      // _checkAndOpenModal();
      //
      // }
    });

  }

  void _fetchVestingDataIfConnected() async {
    if (_isFetchingData || _walletVM == null) return;
    if (!_walletVM!.isConnected || _walletVM!.walletAddress.isEmpty) {
      debugPrint('Wallet not connected, skipping vesting data fetch');
      return;
    }


    try {
      _isFetchingData = true;
      if (_walletVM!.existingVestingAddress != null && _walletVM!.existingVestInfo.start == 0) {
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

  // Future<void> _checkAndOpenModal() async {
  //   if (!mounted || _walletVM == null || _isFetchingData) return;
  //   final walletVM = context.read<WalletViewModel>();
  //   if (!walletVM.isConnected || walletVM.walletAddress.isEmpty) {
  //     debugPrint('Attempting to open modal with context: ${context.mounted}');
  //     try {
  //       await walletVM.openWalletModal(context); // Ensure context is passed
  //     } catch (e) {
  //       debugPrint('Error opening modal: $e');
  //     }
  //   }
  // }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (_walletVM != null) {
      _walletVM!.removeListener(_onWalletAddressChanged);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Selector<WalletViewModel, Tuple3<String?, String?, bool>>(
        selector: (context, walletVM) => Tuple3(
          walletVM.existingVestingAddress,
          walletVM.existingVestingStatus,
          walletVM.isConnected && walletVM.walletAddress.isNotEmpty,
        ),
        builder: (context, data, child){
          final walletVM = Provider.of<WalletViewModel>(context, listen: false);
          _walletVM ??= walletVM;
          debugPrint('ExistingVestingWrapper Selector: isLoading: ${walletVM.isLoading}, '
              'existingVestingAddress: ${walletVM.existingVestingAddress}, '
              'existingVestingStatus: ${walletVM.existingVestingStatus}');

          if(!data.item3){
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
                      onTap: () async {
                        if (!mounted) return;
                        await context.read<WalletViewModel>().openWalletModal(context);
                      },
                      gradientColors: const [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
                    ),
                    const SizedBox(height: 20),
                    DisconnectButton(
                      label: 'Disconnect',
                      color: const Color(0xffE04043),
                      icon: 'assets/icons/disconnected.svg',
                      onPressed: () async {
                        setState(() {
                          isDisconnecting = true;
                        });
                        final walletVm = Provider.of<WalletViewModel>(context, listen: false);
                        try {
                          await walletVm.disconnectWallet(context);
                          walletVm.reset();
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);
                          if (context.mounted && !walletVm.isConnected) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(create: (context) => WalletViewModel()),
                                    ChangeNotifierProvider(create: (_) => BottomNavProvider()),
                                    ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
                                    ChangeNotifierProvider(create: (_) => PersonalViewModel()),
                                    ChangeNotifierProvider(create: (_) => NavigationProvider()),
                                  ],
                                  child: const BottomNavBar(),
                                ),
                              ),
                                  (Route<dynamic> route) => false,
                            );
                          }
                        } catch (e) {
                          debugPrint("Error Wallet Disconnecting : $e");
                        } finally {
                          if (mounted) {
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
          // if (!data.item3) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     if (!_isFetchingData && mounted) {
          //       _checkAndOpenModal(); // Trigger modal on build if not connected
          //     }
          //   });
          //   return Scaffold(
          //     backgroundColor: const Color(0xFF01090B),
          //     body: Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const Text(
          //             "Connection lost Please restart your app or connect your wallet to view vesting details.",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(color: Colors.white70),
          //           ),
          //           const SizedBox(height: 20),
          //           CustomGradientButton(
          //             label: 'Retry',
          //             width: MediaQuery.of(context).size.width * 0.7,
          //             height: MediaQuery.of(context).size.height * 0.05,
          //             onTap: () async {
          //               if (!mounted) return;
          //               await _checkAndOpenModal(); // Reuse the modal opening logic
          //             },
          //             gradientColors: const [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
          //           ),
          //           const SizedBox(height: 20),
          //           DisconnectButton(
          //             label: 'Disconnect',
          //             color: const Color(0xffE04043),
          //             icon: 'assets/icons/disconnected.svg',
          //             onPressed: () async {
          //               setState(() {
          //                 isDisconnecting = true;
          //               });
          //               final walletVm = Provider.of<WalletViewModel>(context, listen: false);
          //               try {
          //                 await walletVm.disconnectWallet(context);
          //                 walletVm.reset();
          //                 final prefs = await SharedPreferences.getInstance();
          //                 await prefs.clear();
          //                 Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);
          //                 if (context.mounted && !walletVm.isConnected) {
          //                   Navigator.of(context).pushAndRemoveUntil(
          //                     MaterialPageRoute(
          //                       builder: (context) => MultiProvider(
          //                         providers: [
          //                           ChangeNotifierProvider(create: (context) => WalletViewModel()),
          //                           ChangeNotifierProvider(create: (_) => BottomNavProvider()),
          //                           ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
          //                           ChangeNotifierProvider(create: (_) => PersonalViewModel()),
          //                           ChangeNotifierProvider(create: (_) => NavigationProvider()),
          //                         ],
          //                         child: const BottomNavBar(),
          //                       ),
          //                     ),
          //                         (Route<dynamic> route) => false,
          //                   );
          //                 }
          //               } catch (e) {
          //                 debugPrint("Error Wallet Disconnecting : $e");
          //               } finally {
          //                 if (mounted) {
          //                   setState(() {
          //                     isDisconnecting = false;
          //                   });
          //                 }
          //               }
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // }

          return ExistingUserVesting(
            key: ValueKey('${data.item1 ?? 'null'}_${data.item2 ?? 'null'}'),
            onStartVestingComplete: () async {
              await walletVM.getExistingVestingInformation();
              if (mounted) {
                setState(() {});
              }
            },
            isPostVesting: data.item2 != null,
            existingVestingInfo: walletVM.existingVestInfo,
            existingVestingStatus: data.item2,
            vestingBalance: walletVM.balance ?? '0',
          );

        },


    );


  }

  @override
  bool get wantKeepAlive => true;

}

class ExistingUserVesting extends StatefulWidget {
  final Future<void> Function()? onStartVestingComplete;
  final bool isPostVesting;
  final ExistingVestingInfo existingVestingInfo;
  final String? existingVestingStatus;
  final String vestingBalance;

  const ExistingUserVesting({
    super.key,
    this.onStartVestingComplete,
    this.isPostVesting = false,
    required this.existingVestingInfo,
    this.existingVestingStatus,
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
  WalletViewModel? _walletVM;
  Timer? _vestingUpdateTimer;
  double? _lastVestedAmount;

  TextEditingController _searchController = TextEditingController();


  List<Claim> _claimHistory = [];
  List<Claim> _filteredClaimHistory = [];


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _startLoadingTimeout();
    balanceText = widget.vestingBalance;
    if (widget.isPostVesting) {
      _initializeTimers(widget.existingVestingInfo);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _fetchInitialData();
    });

    _vestingUpdateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final newVestedAmount = _walletVM?.existingVestedAmount;
      if (newVestedAmount != _lastVestedAmount) {
        setState(() {
          _lastVestedAmount = newVestedAmount;
        });
      }
    });

  }

  Future<void> _fetchInitialData() async {
    if (!mounted) return;
    try {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      await walletVM.ensureModalWithValidContext(context);
      await walletVM.rehydrate();
      await walletVM.getBalance();
      await walletVM.getExistingVestingInformation();
      final claims = await fetchClaimHistory();
      if (mounted) {
        setState(() {
          _claimHistory = claims;
          _filteredClaimHistory = claims;
          balanceText = walletVM.balance ?? '0';
        });
      }
    } catch (e) {
      print('initState Error: $e');
    } finally {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _endLoading());
      }
    }
  }


  Future<List<Claim>> fetchClaimHistory() async {
    if (!mounted) return [];
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    final _walletAddress = walletVM.walletAddress;
    if (_walletAddress == null || _walletAddress.isEmpty) {
      print('fetchClaimHistory: Wallet address not available');
      return [];
    }

    int retryCount = 0;
    const maxRetries = 3;
    while (retryCount < maxRetries) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        final response = await http.get(
          Uri.parse('${ApiConstants.baseUrl}/vesting-claim-history/Exiting_Vesting/$_walletAddress'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': token != null && token.isNotEmpty ? 'Bearer $token' : '',
          },
        );
        if (response.statusCode == 200 && mounted) {
          final data = jsonDecode(response.body) as List;
          return data.map((json) => Claim(
            amount: 'ECM ${json['amount'] ?? '0.0'}',
            dateTime: json['created_at'] ?? '',
            walletAddress: json['wallet_address'] ?? '',
            hash: json['hash'] ?? '',
          )).toList();
        } else if (response.statusCode >= 400) {
          await Future.delayed(const Duration(seconds: 2));
          retryCount++;
        } else {
          break;
        }
      } catch (e) {
        await Future.delayed(const Duration(seconds: 2));
        retryCount++;
      }
    }
    return [];
  }

  void _startLoadingTimeout() {
    _loadingTimeout = Timer(const Duration(seconds: 3), () {
      if (_localLoading && mounted) {
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
    if (!mounted) return;

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


  @override
  void dispose() {
    _loadingTimeout?.cancel();
    _countdownTimer?.cancel();
    _vestingUpdateTimer?.cancel();

    _searchController.dispose();
    super.dispose();
  }

  double getUserBalance(WalletViewModel walletVM) {
    return double.tryParse(walletVM.balance ?? '0') ?? 0.0;
  }

  void _initializeTimers(ExistingVestingInfo existingVestInfo) {
    if (!mounted) return;
    existingVestingStartDate = DateTime.fromMillisecondsSinceEpoch(existingVestInfo.start! * 1000);
    // cliffEndTime = DateTime.fromMillisecondsSinceEpoch(existingVestInfo.cliff! * 1000).subtract(const Duration(days: 365));
    cliffEndTime = DateTime.fromMillisecondsSinceEpoch(existingVestInfo.cliff! * 1000);
    fullVestedDate = DateTime.fromMillisecondsSinceEpoch(existingVestInfo.end! * 1000);
    _lastVestedAmount = _walletVM?.existingVestedAmount;
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
        if (mounted) {
          setState(() {
            _countdownText = "Vesting Starts Soon";
            isCliffPeriodOver = false;
          });
        }
      } else if (now.isBefore(cliffEndTime!)) {
        if (mounted) {
          setState(() {
            isCliffPeriodOver = false;
            _countdownText = "Cliff Period Active";
          });
        }
      }
      else {
        if (mounted) {
          setState(() {
            isCliffPeriodOver = true;
            _countdownText = "Vesting Active - Claim Available";
          });
        }
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
    const baseWidth = 375.0;
    const baseHeight = 812.0;

    double scaleWidth(double size) => size * screenWidth / baseWidth;
    double scaleHeight(double size) => size * screenHeight / baseHeight;
    double scaleText(double size) => size * screenWidth / baseWidth;

    return  Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 80,
        drawer: SideNavBar(
          currentScreenId: currentScreenId,
          navItems: navItems,
          onScreenSelected: (id) => navProvider.setScreen(id),
          onLogoutTapped: () {},
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
                            if (!mounted) return;
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
                              if (mounted) {
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  _endLoading();
                                });
                              }
                            }

                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),


                            child: Consumer<WalletViewModel>(
                                builder: (context , walletVM, child){

                                  final userBalance = getUserBalance(walletVM);
                                  return Column(
                                    children: [

                                      if (widget.existingVestingStatus == 'locked') ...[

                                        VestingContainer(
                                          width: screenWidth * 0.9,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: screenHeight * 0.02),
                                              if (existingVestingStartDate != null)
                                                Text(
                                                  'Vesting Period Begin on \n${DateFormat('d MMMM yyyy').format(existingVestingStartDate!)}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: const Color(0xFFFFF5ED),
                                                    fontSize: getResponsiveFontSize(context, 22),
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,

                                                  ),
                                                ),
                                              SizedBox(height: screenHeight * 0.02),
                                              if (existingVestingStartDate != null)
                                                ChangeNotifierProvider(
                                                  create: (_) {
                                                    return CountdownTimerProvider(
                                                      targetDateTime: existingVestingStartDate!,
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
                                        existingVestingDetails(screenHeight, screenWidth, context,),
                                        SizedBox(height: screenHeight * 0.9),

                                        ] else if (widget.existingVestingStatus == 'process') ...[

                                        SizedBox(height: screenHeight * 0.02),
                                        cliffTimerAndClaimSection(screenHeight, screenWidth, context, walletVM),
                                        SizedBox(height: screenHeight * 0.02),
                                        vestingSummary(screenHeight, screenWidth, context),
                                        SizedBox(height: screenHeight * 0.02),
                                        claimHistory(screenHeight, screenWidth, context),

                                      ] else ...[
                                        totalBalance(screenHeight, screenWidth, context, walletVM, userBalance, widget.isPostVesting),
                                        SizedBox(height: screenHeight * 0.02),
                                        whyVesting(screenHeight, screenWidth, context),
                                        SizedBox(height: screenHeight * 0.09),
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
    final displayBalance = widget.existingVestingStatus != null ? widget.existingVestingInfo.totalVestingAmount?.toStringAsFixed(2) : _formatBalance(balanceText);
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

          SizedBox(height: screenHeight * 0.01),

          /// Start Vesting Enable Button
          // BlockButton(
          //   height: screenHeight * 0.05,
          //   width: screenWidth * 0.8,
          //   label: _isStartingVesting ? "Starting.." : "Start Vesting",
          //   textStyle:  TextStyle(
          //     fontWeight: FontWeight.w700,
          //     color: Colors.white,
          //     fontSize: getResponsiveFontSize(context, 16),
          //     height: 1.6,
          //   ),
          //   gradientColors: const [
          //     Color(0xFF2680EF),
          //     Color(0xFF1CD494)
          //   ],
          //   // onTap:!isPostVesting && !isLowBalance && !_isStartingVesting
          //   onTap: widget.existingVestingStatus == null && !isLowBalance && !_isStartingVesting
          //       ? () async{
          //     print('Start Vesting button clicked - initiating process');
          //     setState(() {
          //       _isStartingVesting = true;
          //     });
          //
          //     try{
          //       await walletVm.startVesting(context);
          //       print('Start Vesting completed - navigating to vesting status screen');
          //       if (widget.onStartVestingComplete != null) {
          //         await widget.onStartVestingComplete!();
          //       }
          //
          //       await walletVm.getBalance();
          //
          //       if (mounted) {
          //         setState(() {
          //           balanceText = walletVm.balance ?? '0';
          //           _initializeTimers(widget.existingVestingInfo);
          //         });
          //       }
          //
          //     } catch (e) {
          //       print('totalBalance: startVesting error: $e');
          //     }finally{
          //       if(mounted){
          //         setState(() {
          //           _isStartingVesting = false;
          //         });
          //       }
          //     }
          //   } : null,
          //
          // ),
          /// Start Vesting Disable Button
          Text(
            'Vesting period has expired.',
            style:  TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white54,
              fontSize: getResponsiveFontSize(context, 16),
             ),
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
        "text": "Claims are only possible after the cliff period is over. At that time, the tokens vested during the cliff will be released to you."
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

  Widget existingVestingDetails(double screenHeight, double screenWidth, BuildContext context) {
    final displayBalance = widget.existingVestingStatus != null ? widget.existingVestingInfo.totalVestingAmount?.toStringAsFixed(2) : _formatBalance(balanceText);

    return Consumer<WalletViewModel>(
        builder: (context,walletVM, child) {

          debugPrint(" ExistingVestingDetails Consumer: walletVM.balance = ${walletVM.balance}, displayExistingBalanceText = $balanceText");

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

                (walletVM.vestingStatus == null)
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ) :
                ShaderMask(
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
                    // 'ECM ${_formatBalance(balanceText)}',
                    'ECM $displayBalance',
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
                              value: existingVestingStartDate != null ? DateFormat('d MMMM yyyy').format(existingVestingStartDate!) : '...',

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

  Widget cliffTimerAndClaimSection(double screenHeight, double screenWidth, BuildContext context, WalletViewModel walletVM ) {
    final displayBalance = widget.existingVestingStatus != null ? widget.existingVestingInfo.totalVestingAmount?.toStringAsFixed(2) : _formatBalance(balanceText);
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
              // 'ECM ${_formatBalance(balanceText)}',
              'ECM $displayBalance',
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
                      value: 'ECM ${walletVM.existingVestInfo.released?.toStringAsFixed(6) ?? '0.0'}',
                      iconSize: screenHeight * 0.025,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Flexible(
                    child: VestingDetailInfoRow(
                      iconPath: 'assets/icons/claimedIcon.svg',
                      title: 'Available claim',
                      value: 'ECM ${walletVM.availableClaimableAmountForExistingUser.toStringAsFixed(6)}',
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
              onTap: () {
                print('CLAIM button tapped for testing');
                walletVM.releaseECM(context);
              },
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
                  final explorerUrl = 'https://etherscan.io/tx/${claim.hash}';

                  final amountNumeric = double.tryParse(claim.amount.replaceAll('ECM ', '')) ?? 0.0;
                  final formattedAmount = "ECM ${amountNumeric.toStringAsFixed(6)}";

                  final dateTimeFormatted = DateFormat("dd MMM yyyy HH:mm")
                      .format(DateTime.parse(claim.dateTime));

                  return ClaimHistoryCard(
                    // amount: claim.amount,
                    // dateTime: claim.dateTime,
                    amount: formattedAmount,
                    dateTime: dateTimeFormatted,
                    walletAddress: claim.walletAddress,
                    buttonLabel: "Explore",
                    onButtonTap: () async{
                      if(await canLaunchUrl(Uri.parse(explorerUrl))){
                        await launchUrl(Uri.parse(explorerUrl));
                      }
                      debugPrint("Explore tapped for ${claim.hash}");
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
  try {
    final value = double.parse(balance);
    return value.toStringAsFixed(2);
  } catch (e) {
    return balance;
  }
}
