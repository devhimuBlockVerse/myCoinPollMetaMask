import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
 import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/ListingFields.dart';
import '../../../../../framework/components/VestingContainer.dart';
import '../../../../../framework/components/VestingSummaryRow.dart';
import '../../../../../framework/components/buy_Ecm.dart';
import '../../../../../framework/components/claimHistoryCard.dart';
import '../../../../../framework/components/loader.dart';
import '../../../../../framework/components/vestingDetailRow.dart';
import '../../../../../framework/utils/customToastMessage.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/toast_type.dart';
import '../../../../data/services/api_service.dart';
import '../../../../presentation/countdown_timer_helper.dart';
import '../../../../presentation/viewmodel/countdown_provider.dart';
import '../../../../presentation/viewmodel/user_auth_provider.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';
import '../../viewmodel/vesting_status_provider.dart';
import 'package:intl/intl.dart';

import 'helper/claim.dart';

class StartVestingView extends StatefulWidget {
  const StartVestingView({super.key});

  @override
  State<StartVestingView> createState() => _StartVestingViewState();
}

class _StartVestingViewState extends State<StartVestingView> {
  String balanceText = '...';
  bool _isStartingVesting = false;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      await walletVM.ensureModalWithValidContext(context);
      await walletVM.rehydrate();
      await walletVM.getBalance();

      final vestingProvider = Provider.of<VestingStatusProvider>(context, listen: false);
      await vestingProvider.loadFromBackend();
     });
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
        return await walletVM.getBalance();
      } catch (_) {
        return '0';
      }


    }catch(e){
      return '0';
    }

  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final vestingStatus = Provider.of<VestingStatusProvider>(context);

    if (vestingStatus.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (vestingStatus.hasUserStartedVestingSleepPeriod) {
      return WillPopScope(
        onWillPop: () async => false,
        child: const SleepPeriodScreen(),
      );
    }


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
                            final walletVM = Provider.of<WalletViewModel>(context, listen: false);
                            await walletVM.ensureModalWithValidContext(context);
                            await walletVM.rehydrate();
                            await walletVM.getBalance();
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),


                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                totalBalance(screenHeight, screenWidth, context,walletVM),

                                SizedBox(height: screenHeight * 0.02),

                                vestingInfo(screenHeight, screenWidth, context),

                                SizedBox(height: screenHeight * 0.09),

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

  Widget totalBalance(screenHeight, screenWidth, context ,WalletViewModel walletVm){

    return FutureBuilder<String>(
        future: resolveBalance(),
        builder: (context,snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              balanceText = snapshot.data!;
            } else if (snapshot.hasError) {
              balanceText = "0";
            }
          }
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
                     // "${walletVm.walletAddress.substring(0, 6)}...${walletVm.walletAddress.substring(walletVm.walletAddress.length - 4)}",

                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 22),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

              ],
            ),
          );
        }
    );

  }
  Widget vestingInfo(screenHeight, screenWidth, context){


    return VestingContainer(
      width: screenWidth * 0.9,
      borderColor: const Color(0XFF2C2E41),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Vesting info',
              style: TextStyle(
                color: Color(0XFFFFF5ED),
                fontSize: getResponsiveFontSize(context, 16),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
             ),
          ),

          SizedBox(height: screenHeight * 0.04),
          Text(
            'ECM Amount',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: getResponsiveFontSize(context, 14),
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          ListingField(
            controller: TextEditingController(),
            labelText: '${_formatBalance(balanceText)} ECM',
            height: screenHeight * 0.05,
            width: screenWidth* 0.88,
            expandable: false,
            readOnly: true,
            keyboard: TextInputType.name,
          ), ///

          SizedBox(height: screenHeight * 0.03),



          Text(
            'Vesting Period',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: getResponsiveFontSize(context, 14),
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          ListingField(
            controller: TextEditingController(),
            labelText: '3 months cliff',
            height: screenHeight * 0.05,
            width: screenWidth* 0.88,
            expandable: false,
            readOnly: true,
            keyboard: TextInputType.name,
          ),

          SizedBox(height: screenHeight * 0.03),

          Text(
            'Vesting Start',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: getResponsiveFontSize(context, 14),
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          ListingField(
            controller: TextEditingController(),
            labelText: '20 January , 2026',
            height: screenHeight * 0.05,
            width: screenWidth* 0.88,
            expandable: false,
            readOnly: true,
            keyboard: TextInputType.name,
          ),
          SizedBox(height: screenHeight * 0.04),


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
            onTap: _isStartingVesting ? null : () async{
              setState(() => _isStartingVesting = true);

              final vestingProvider = Provider.of<VestingStatusProvider>(context, listen: false);
              final success  = await vestingProvider.startVestingSleepPeriod();

              if(success && mounted){
                setState(() {});
              }
              if(mounted){
                setState(() => _isStartingVesting = false);
              }
            },

          ),

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
  late DateTime vestingEventStartDate;

   final Duration vestingPeriodDuration = const Duration(seconds: 10); // e.g., 4 months cliff
  final Duration totalVestingPeriodFromActualStart = const Duration(days: 547); // e.g., 18 months total

  late DateTime vestingStartDate;
  late DateTime fullVestedDate;

  bool isVestingPeriodDurationOver = false;
  bool isCliffPeriodOver = false;

  late DateTime cliffEndTime;

  List<Claim> _claimHistory = []; // keep track of claims
  List<Claim> _filteredClaimHistory = []; // filtered list for search
  TextEditingController _searchController = TextEditingController();
  bool _isSearchOpen = false;


  @override
  void initState() {
    super.initState();


    vestingEventStartDate = DateTime.now();

    // Calculate vesting *actually* starts
     vestingStartDate = vestingEventStartDate.add(vestingPeriodDuration);

    // Calculate Full Vested Date
    // Total vesting duration is calculated FROM the vestingStartDate (vestingActualStartDate)
     fullVestedDate = vestingStartDate.add(totalVestingPeriodFromActualStart);

    // Start timers
    _startGlobalVestingTimer();
    _startUserCliffTimer();

    // preload mock claim history
    fetchClaimHistory().then((claims) {
      if (mounted) {
        setState(() {
          _claimHistory = claims;
          _filteredClaimHistory = claims;
        });
      }
    });
    _searchController.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      await walletVM.ensureModalWithValidContext(context);
      await walletVM.rehydrate();
      await walletVM.getBalance();
    });
  }

  void _startGlobalVestingTimer() {
    if (DateTime.now().isAfter(vestingStartDate)) {
      // Vesting period already over
      setState(() => isVestingPeriodDurationOver = true);
      _startUserCliffTimer(); // Start cliff immediately
    } else {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (DateTime.now().isAfter(vestingStartDate)) {
          if (mounted) setState(() => isVestingPeriodDurationOver = true);
          timer.cancel();
          _startUserCliffTimer();
        }
      });
    }
  }

  void _startUserCliffTimer() {
    // Only start if cliff not already over
    if (isCliffPeriodOver) return;

    final userCliffDuration = Duration(seconds: 10); // per-user cliff
    cliffEndTime = DateTime.now().add(userCliffDuration);
    // final userCliffEndDate = cliffStartTime.add(userCliffDuration);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (DateTime.now().isAfter(cliffEndTime)) {
        if (mounted) setState(() => isCliffPeriodOver = true);
        timer.cancel();
      } else {
        if (mounted) setState(() {}); // triggers UI update for CountdownTimer
      }
    });
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
        return await walletVM.getBalance();
      } catch (_) {
        return '0';
      }


    }catch(e){
      return '0';
    }

  }

  Future<List<Claim>> fetchClaimHistory() async {
    await Future.delayed(const Duration(seconds: 1));

     return [

      Claim(
        amount: "ECM 120.200",
        dateTime: "15 Nov 2025 11:10:20",
        walletAddress: "0x9a6fbF46F26625e709c11ca2e84a7f34481bc7d",
      ),     Claim(
        amount: "ECM 258.665",
        dateTime: "06 Nov 2025 21:30:48",
        walletAddress: "0x298f3EF46F26625e709c11ca2e84a7f34489C71d",
      ),
      Claim(
        amount: "ECM 100.200",
        dateTime: "15 Nov 2025 11:10:20",
        walletAddress: "0x9a6fbF46F26625e709c11ca2e84a7f34481bc7d",
      ),
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

    final DateTime targetForVestingPeriodCountDown = vestingStartDate;

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
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),

                        child: RefreshIndicator(
                          onRefresh: () async {
                            final walletVM = Provider.of<WalletViewModel>(context, listen: false);
                            await walletVM.ensureModalWithValidContext(context);
                            await walletVM.rehydrate();
                            await walletVM.getBalance();
                            if (mounted) {
                              setState(() {});
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

                                        ChangeNotifierProvider(
                                          create: (_) {
                                            return CountdownTimerProvider(
                                              targetDateTime: targetForVestingPeriodCountDown,
                                            );
                                          },
                                          child: Builder(
                                            builder: (context) {
                                              final timerProvider = Provider.of<CountdownTimerProvider>(context);
                                              final dateFormat = DateFormat('d MMMM yyyy');

                                              // Display the date when vesting *actually* begins (i.e., cliff ends)
                                              final formattedVestingActualStartDate = dateFormat.format(vestingStartDate);

                                              print('Cliff Timer - targetDateTime (cliff end): ${timerProvider.targetDateTime}');
                                              print('Text widget - months remaining: ${timerProvider.months}');


                                              if (!isVestingPeriodDurationOver && timerProvider.remaining.isNegative) {
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  if (mounted) {
                                                    setState(() => isVestingPeriodDurationOver = true);
                                                    print("Cliff period is over! Switching UI");
                                                  }
                                                });
                                              }

                                              return Column(
                                                children: [
                                                  Text(
                                                    'Vesting Period Begin on \n$formattedVestingActualStartDate',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: const Color(0xFFFFF5ED),
                                                      fontSize: getResponsiveFontSize(context, 22),
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(height: screenHeight * 0.02),
                                                  CountdownTimer(
                                                    scaleWidth: scaleWidth,
                                                    scaleHeight: scaleHeight,
                                                    scaleText: scaleText,
                                                    showMonths: true,
                                                  ),
                                                ],
                                              );
                                            },
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
                                    hintText: "0xE4763679E40basdasd1c4e7d117429",
                                    isReadOnly: true,
                                    trailingIconAsset: 'assets/icons/copyImg.svg',
                                    onTrailingIconTap: () {
                                      final vestingAddress = "0xE4763679E40b...1c4e7d117429";
                                      if(vestingAddress.isNotEmpty){
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
                                  vestingDetails(
                                      screenHeight, screenWidth, context,
                                      actualStartDate: vestingStartDate,
                                      actualFullVestDate: fullVestedDate
                                  ),
                                  // SizedBox(height: screenHeight * 0.9),
                                ],

                                if (isVestingPeriodDurationOver) ...[
                                  cliffTimerAndClaimSection(screenHeight, screenWidth, context),
                                  SizedBox(height: screenHeight * 0.02),

                                  CustomLabeledInputField(
                                    containerWidth: screenWidth * 0.9,
                                    labelText: 'Vesting Wallet:',
                                    hintText: "0xE4763679E40basdasd1c4e7d117429",
                                    isReadOnly: true,
                                    trailingIconAsset: 'assets/icons/copyImg.svg',
                                    onTrailingIconTap: () {
                                      final vestingAddress = "0xE4763679E40b...1c4e7d117429";
                                      if(vestingAddress.isNotEmpty){
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

  Widget vestingDetails(double screenHeight, double screenWidth, BuildContext context,
      {required DateTime actualStartDate, required DateTime actualFullVestDate}) {
    return FutureBuilder<String>(
        future: resolveBalance(),
        builder: (context,snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              balanceText = snapshot.data!;
            } else if (snapshot.hasError) {
              balanceText = "0";
            }
          }
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

                    // Use the passed-in, consistent dates
                    final dateFormat = DateFormat('d MMMM yyyy');
                    final formattedStart = dateFormat.format(actualStartDate);
                    final formattedEnd = dateFormat.format(actualFullVestDate);

                    print('Vesting Details - actualStartDate: $actualStartDate');
                    print('Vesting Details - actualFullVestDate: $actualFullVestDate');

                   return Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Flexible(
                         child: VestingDetailInfoRow(
                           iconPath: 'assets/icons/vestingStartDate.svg',
                           title: 'Vesting Start Date',
                            value: formattedStart,

                         ),
                       ),
                        SizedBox(width: screenWidth * 0.03),
                        Flexible(
                         child: VestingDetailInfoRow(
                           iconPath: 'assets/icons/vestingFullDate.svg',
                           title: 'Full Vested Date',
                           value: formattedEnd,
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

    return FutureBuilder<String>(
        future: resolveBalance(),
        builder: (context,snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              balanceText = snapshot.data!;
            } else if (snapshot.hasError) {
              balanceText = "0";
            }
          }
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
                        targetDateTime: cliffEndTime,

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
                            value: 'ECM 125.848',
                            iconSize: screenHeight *0.025,

                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Flexible(
                          child: VestingDetailInfoRow(
                            iconPath: 'assets/icons/claimedIcon.svg',
                            title: 'Available claim',
                            value: 'ECM 52.152',
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
                      onTap: (){
                        final newClaim = Claim(
                          amount: "ECM 50.000", // dynamically fetch actual claimable amount
                          dateTime: DateFormat("dd MMM yyyy HH:mm:ss").format(DateTime.now()),
                          walletAddress: "0x298f3EF46F26625e709c11ca2e84a7f34489C71d", // replace with real user wallet
                        );

                        setState(() {
                          _claimHistory.insert(0, newClaim); // add at top
                          _onSearchChanged();
                        });

                        ToastMessage.show(
                          message: "Claim successful!",
                          type: MessageType.success,
                        );
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

          const VestingSummaryRow(
            label: 'Vesting Start Date',
            value: '20 January, 2026',
           ),

          SizedBox(height: screenHeight * 0.01),

          const VestingSummaryRow(
            label: 'Vesting Period',
            value: '12 Months. 3 months cliff',
          ),


          SizedBox(height: screenHeight * 0.01),

          const VestingSummaryRow(
            label: 'Cliff Info',
            value: '25% unlock at 3 months',
          ),


          SizedBox(height: screenHeight * 0.01),

          const VestingSummaryRow(
            label: 'Full Vested Date',
            value: '20 July, 2027',
          ),

          SizedBox(height: screenHeight * 0.02),

        ECMProgressIndicator(
              vestingStartDate: DateTime(2025, 1, 20),
              fullVestedDate: DateTime(2026, 7, 20),
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



String _formatBalance(String balance) {
  if (balance.length <= 6) return balance;
  return '${balance.substring(0, 9)}';
}




