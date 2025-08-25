import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../framework/components/AddressFieldComponent.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/ListingFields.dart';
import '../../../../../framework/components/VestingContainer.dart';
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

    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final vestingStatus = Provider.of<VestingStatusProvider>(context);

    if (vestingStatus.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (vestingStatus.hasSleepPeriodEnded) {
      return const VestingMainScreen();
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

                                totalBalance(screenHeight, screenWidth, context),

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

  Widget totalBalance(screenHeight, screenWidth, context){

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
  late DateTime contractStartDate;

   final Duration cliffPeriodDuration = const Duration(days: 150); // e.g., 4 months cliff
  final Duration totalVestingPeriodFromActualStart = const Duration(days: 547); // e.g., 18 months total

  late DateTime cliffEndDate;
  late DateTime fullVestedDate;


  @override
  void initState() {
    super.initState();
    contractStartDate = DateTime.now();

    // Calculate Cliff End Date (which is also when vesting *actually* starts)
     cliffEndDate = contractStartDate.add(cliffPeriodDuration);

    // Calculate Full Vested Date
    // Total vesting duration is calculated FROM the cliffEndDate (vestingActualStartDate)
     fullVestedDate = cliffEndDate.add(totalVestingPeriodFromActualStart);
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

    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    const baseWidth = 375.0;
    const baseHeight = 812.0;
    double scaleWidth(double size) => size * screenWidth / baseWidth;
    double scaleHeight(double size) => size * screenHeight / baseHeight;
    double scaleText(double size) => size * screenWidth / baseWidth;

    final DateTime targetForCliffCountdown = cliffEndDate;

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

                                /// Cliff Timer and Vesting Text
                                VestingContainer(
                                  width: screenWidth * 0.9,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: screenHeight * 0.02),

                                      ChangeNotifierProvider(
                                        create: (_) {
                                          return CountdownTimerProvider(
                                             targetDateTime: targetForCliffCountdown,
                                          );
                                        },
                                        child: Builder(
                                          builder: (context) {
                                            final timerProvider = Provider.of<CountdownTimerProvider>(context);
                                            final dateFormat = DateFormat('d MMMM yyyy');

                                            // Display the date when vesting *actually* begins (i.e., cliff ends)
                                            final formattedVestingActualStartDate = dateFormat.format(cliffEndDate);

                                            print('Cliff Timer - targetDateTime (cliff end): ${timerProvider.targetDateTime}');
                                             print('Text widget - months remaining: ${timerProvider.months}');


                                            if (timerProvider.remaining.isNegative &&
                                                timerProvider.targetDateTime != null &&
                                                timerProvider.targetDateTime!.isBefore(DateTime.now())) {
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                if (mounted) {
                                                  // Option 1: Navigate to a different screen
                                                  // Navigator.pushReplacement(
                                                  //   context,
                                                  //   MaterialPageRoute(builder: (_) => const VestingMainScreen()),
                                                  // );

                                                  // Option 2: Change state within this screen
                                                  // setState(() { _isCliffPeriodOver = true; });
                                                  // Then use _isCliffPeriodOver to change the UI below
                                                  print("Cliff period is over!");
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
                                    actualStartDate: cliffEndDate,
                                    actualFullVestDate: fullVestedDate
                                ),
                                SizedBox(height: screenHeight * 0.9),

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
                           // value: '20 July, 2027',
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






}





class VestingMainScreen extends StatefulWidget {
  const VestingMainScreen({super.key});

  @override
  State<VestingMainScreen> createState() => _VestingMainScreenState();
}

class _VestingMainScreenState extends State<VestingMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Vesting Main', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: const Color(0xFF01090B),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is the Vesting Main screen after Sleep Time is Over',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}



String _formatBalance(String balance) {
  if (balance.length <= 6) return balance;
  return '${balance.substring(0, 9)}';
}



class VestingDetailInfoRow extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;
  final double? iconSize;

  const VestingDetailInfoRow({
    super.key,
    required this.iconPath,
    required this.title,
    required this.value,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(
          iconPath,
          fit: BoxFit.contain,
          height: iconSize ?? screenHeight * 0.03,
        ),
         SizedBox(width: screenWidth * 0.02),
         Expanded(
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF7D8FA9),
                  fontSize: getResponsiveFontSize(context, 12),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,

                ),

              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                value,
                style:  TextStyle(
                  color: Color(0xFFFFF5ED),
                  fontSize: getResponsiveFontSize(context, 13),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),

              ),
            ],
                     ),
         ),
      ],
    );
  }
}