import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/vesting/vesting_Item.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
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
import '../../../../../framework/utils/enums/toast_type.dart';
import '../../../../domain/constants/api_constants.dart';
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
import 'package:http/http.dart'as http;


class VestingWrapper extends StatefulWidget {
  const VestingWrapper({super.key});

  @override
  State<VestingWrapper> createState() => _VestingWrapperState();
}

class _VestingWrapperState extends State<VestingWrapper> with AutomaticKeepAliveClientMixin {
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

      if (_walletVM!.vestingAddress != null && _walletVM!.vestInfo.start == 0) {
        debugPrint('Fetching vesting information...');
        await _walletVM!.getVestingInformation();

        // Fetch balance only if vesting address is available
        if (_walletVM!.vestingAddress != null && _walletVM!.vestingAddress!.isNotEmpty) {
          debugPrint('Fetching vesting balance...');
          await _walletVM!.getBalance(forAddress: _walletVM!.vestingAddress);
          debugPrint('Vesting balance fetched: ${_walletVM!.vestingContractBalance}');

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

        debugPrint('VestingWrapper Consumer REBUILDING. isLoading: ${walletVM.isLoading}, vestingAddress: ${walletVM.vestingAddress}');
        debugPrint('walletAddress: ${walletVM.walletAddress}');
        debugPrint('vestingAddress: ${walletVM.vestingAddress}');
        debugPrint('Vesting balance: ${walletVM.vestingContractBalance}');

        // Check if wallet is connected
        if (!walletVM.isConnected || walletVM.walletAddress.isEmpty) {
          return Scaffold(
            backgroundColor: const Color(0xFF01090B),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    // "Connection lost Please connect your wallet to view vesting details.",
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


        if (walletVM.vestingAddress != null && walletVM.vestingAddress!.isNotEmpty) {
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
                  // Align(
                  //   alignment: Alignment.topCenter,
                  //   child:  Text(
                  //     'ECM Vesting',
                  //     style: TextStyle(
                  //       fontFamily: 'Poppins',
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.w600,
                  //       // fontSize: 20
                  //       fontSize: screenWidth * 0.05,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
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
              Navigator.pop(context);
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
        "text": "Vested users may gain early access to upcoming launches, airdrops, or governance participation."
      },
      // {
      //   "image": "assets/images/moneyVesting.png",
      //   "text": "Builds investor trust and shows project commitment"
      // },
      {
        "image": "assets/images/vestingImg2.png",
        "text": "Vesting may unlock special incentives such as bonus rewards, reduced fees, or priority in ecosystem benefits."
      },
      {
        "image": "assets/images/vestingImg3.png",
        "text": "Vesting reduces sudden market oversupply, helping to stabilize ECM’s value and support long-term growth."
      },
      {
        "image": "assets/images/vestingImg4.png",
        "text": "Vesting builds a committed base of long-term holders, making the ECM ecosystem stronger together."
      },
      {
        "image": "assets/images/vestingImg5.png",
        "text": "Only vested tokens will be tradable once ECM is listed at the end of Q1 2026. Without vesting, your coins will remain non-tradable."
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
  /// New timer for vested amount updates
  Timer? _vestingUpdateTimer;
  double? _lastVestedAmount;

  List<Claim> _claimHistory = []; // keep track of claims
  List<Claim> _filteredClaimHistory = []; // filtered list for search
  TextEditingController _searchController = TextEditingController();
  bool _isSearchOpen = false;
  WalletViewModel? _walletVM;



  @override
  void initState() {
    super.initState();
    _walletVM = Provider.of<WalletViewModel>(context, listen: false);
    _searchController.addListener(_onSearchChanged);


    WidgetsBinding.instance.addPostFrameCallback((_)async{
       _setupScreen();

      fetchClaimHistory().then((claims) {
        if (mounted) {
          setState(() {
            _claimHistory = claims;
            _filteredClaimHistory = claims;
          });
        }
      });

    });
    _vestingUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final newVestedAmount = _walletVM?.vestedAmount;
      if (newVestedAmount != _lastVestedAmount) {
        setState(() {
          _lastVestedAmount = newVestedAmount;
        });
      }
    });
  }

  // NEW METHOD to organize setup
  void _setupScreen() async {
    if (!mounted || _walletVM == null) return;

    // Fetch the balance of the vesting contract and update local state
    if (_walletVM!.vestingAddress != null) {
      debugPrint('Fetching vesting information...');


      final vestingBalance = await _walletVM!.getBalance(forAddress: _walletVM!.vestingAddress!);
      debugPrint('Vesting balance fetched: ${vestingBalance}');
      if (mounted) {
        setState(() {
          balanceText = vestingBalance;
        });
      }
    }

    //  Initialize timers as before
    _fetchVestingDataAndStartTimers();
  }


  void _fetchVestingDataAndStartTimers() async {
    if (!mounted || _walletVM == null) return;

    if (_walletVM!.vestInfo.start != 0) {
      _initializeTimers(_walletVM!.vestInfo);
    }

    _walletVM!.addListener(_onVestingDataUpdated);
  }

  void _onVestingDataUpdated() {
    if (!mounted || _walletVM == null) return;

    if (_walletVM!.vestInfo.start != 0) {
      _initializeTimers(_walletVM!.vestInfo);
      _walletVM!.removeListener(_onVestingDataUpdated);
    }
  }

  void _initializeTimers(IcoVestingInfo vestInfo) {
    if (!mounted) return;

    // vestingStartDate = DateTime.fromMillisecondsSinceEpoch(vestInfo.start! * 1000).add(const Duration(days: 120)); // For Testing
    cliffEndTime = DateTime.fromMillisecondsSinceEpoch(vestInfo.cliff! * 1000).subtract(const Duration(days: 120)); // For Testing

    vestingStartDate = DateTime.fromMillisecondsSinceEpoch(vestInfo.start! * 1000);
    // cliffEndTime = DateTime.fromMillisecondsSinceEpoch(vestInfo.cliff! * 1000) ;
    fullVestedDate = DateTime.fromMillisecondsSinceEpoch(vestInfo.end! * 1000);

    _startCountdownTimer();
    _lastVestedAmount = _walletVM?.vestedAmount;
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
          setState(() {
            isVestingPeriodDurationOver = false;
            isCliffPeriodOver = false;
            _countdownText = "Vesting Starts Soon";
          });
        }
      } else if (now.isBefore(cliffEndTime!)) {
        if (!isVestingPeriodDurationOver || isCliffPeriodOver) {
          setState(() {
            isVestingPeriodDurationOver = true;
            isCliffPeriodOver = false;
            _countdownText = "Cliff Period Active";
          });
        }
      } else {
        if (!isCliffPeriodOver) {
          setState(() {
            isVestingPeriodDurationOver = true;
            isCliffPeriodOver = true;
            _countdownText = "Vesting Active - Claim Available";
          });
        }
        timer.cancel();
      }
    });
  }


  @override
  void dispose() {
    _countdownTimer?.cancel();
    _vestingUpdateTimer?.cancel();
    _searchController.dispose();
    if (_walletVM != null) {
      _walletVM!.removeListener(_onVestingDataUpdated);
    }
    super.dispose();
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
          Uri.parse('${ApiConstants.baseUrl}/vesting-claim-history/ICO_Vesting/$_walletAddress'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': token != null && token.isNotEmpty ? 'Bearer $token' : '',

          },
        );
        if (response.statusCode == 200 && mounted) {
          print('fetchClaimHistory ICO_VESTING: Response status code = ${response.statusCode},'
              ' body = ${response.body}');

          final data = jsonDecode(response.body) as List;
          return data.map((json) => Claim(
            amount: 'ECM ${json['amount'] ?? '0.0'}',
            dateTime: json['created_at'] ?? '',
            walletAddress: json['wallet_address'] ?? '',
            hash: json['hash'] ?? '',
          )).toList();
        } else if (response.statusCode >= 400) {
          print('fetchClaimHistory: Server error (attempt $retryCount): ${response.body}');
          await Future.delayed(const Duration(seconds: 2));
          retryCount++;
        } else {
          print('fetchClaimHistory: Unexpected response (attempt $retryCount): ${response.body}');
          break;
        }
      } catch (e) {
        print('fetchClaimHistory: Error (attempt $retryCount): $e');
        await Future.delayed(const Duration(seconds: 2));
        retryCount++;
      }
    }
    return [];
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

    // if(walletVm.isLoading || walletVm.vestingAddress == null){
    //   return const Scaffold(
    //     backgroundColor: Color(0xFF01090B),
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // }


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
                            await walletVm.getVestingInformation();
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

          String displayBalance = "0";

          if (walletVM.isLoading && walletVM.vestingContractBalance == null) {
            // Keep existing balanceText during loading
            displayBalance = balanceText;
          } else if (walletVM.vestingContractBalance != null && walletVM.vestingContractBalance!.isNotEmpty) {
            displayBalance = walletVM.vestingContractBalance!;
            balanceText = displayBalance; // Update local state
          } else if (walletVM.balance != null && walletVM.balance!.isNotEmpty) {
            displayBalance = walletVM.balance!;
            balanceText = displayBalance;
          } else {
            displayBalance = "0";
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

                (walletVM.isLoading && walletVM.vestingContractBalance == null)
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

          String displayBalance = "0";

          if (walletVM.isLoading && walletVM.vestingContractBalance == null) {
            // Keep existing balanceText during loading
            displayBalance = balanceText;
          } else if (walletVM.vestingContractBalance != null && walletVM.vestingContractBalance!.isNotEmpty) {
            displayBalance = walletVM.vestingContractBalance!;
            balanceText = displayBalance; // Update local state
          } else if (walletVM.balance != null && walletVM.balance!.isNotEmpty) {
            displayBalance = walletVM.balance!;
            balanceText = displayBalance;
          } else {
            displayBalance = "0";
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
                  final explorerUrl = 'https://etherscan.io/tx/${claim.hash}';
                  return ClaimHistoryCard(
                    amount: claim.amount,
                    dateTime: claim.dateTime,
                    walletAddress: claim.walletAddress,
                    buttonLabel: "Explore",
                    onButtonTap: ()  async{
                      if(await canLaunchUrl(Uri.parse(explorerUrl))){
                        await launchUrl(Uri.parse(explorerUrl));
                      }
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