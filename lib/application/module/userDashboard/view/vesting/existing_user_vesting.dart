import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/vesting/vesting_Item.dart';
 import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/VestingContainer.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../data/services/api_service.dart';
import '../../../../presentation/viewmodel/user_auth_provider.dart';
import '../../../../presentation/viewmodel/wallet_view_model.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';
import 'helper/vesting_info.dart';


class ExistingUserVesting extends StatefulWidget {
  const ExistingUserVesting({super.key});

  @override
  State<ExistingUserVesting> createState() => _ExistingUserVestingState();
}

class _ExistingUserVestingState extends State<ExistingUserVesting> {
  String balanceText = '...';
  bool _isStartingVesting = false;
  bool _localLoading = true;
  Timer? _loadingTimeout;



  @override
  void initState() {
    super.initState();
    _startLoadingTimeout();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      try{
        await walletVM.ensureModalWithValidContext(context);
        await walletVM.rehydrate();
        await walletVM.getBalance();
        await walletVM.getExistingVestingInformation();
        print('initState: Vesting status = ${walletVM.vestingStatus}, vestInfo = ${walletVM.vestInfo.toString()}');
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
  @override
  void dispose() {
    _loadingTimeout?.cancel();
    super.dispose();
  }

  Future<String> resolveBalance() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      final authMethod = prefs.getString('auth_method') ?? '';
      String contract = prefs.getString('dashboard_contract_address') ?? '';

      if(contract.isEmpty){
        final details = await ApiService().fetchTokenDetails('e-commerce-coin');
        final contractAddr = (details.contractAddress ?? '').trim();
        if(contractAddr.isNotEmpty && contractAddr.length == 42 && contractAddr.startsWith('0x')){
          await prefs.setString('dashboard_contract_address', contractAddr);
          contract = contractAddr;
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
      print('resolveBalance Error: $e');
      return '0';
    }

  }


  double getUserBalance(WalletViewModel walletVM) {
    return double.tryParse(walletVM.balance ?? '0') ?? 0.0;
  }
  Widget _ShimmerPlaceholder({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 1500),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.1),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0, -0.3),
              end: Alignment(1.0, 0.3),
              transform: _SlidingGradientTransform(
                slidePercent: DateTime.now().millisecondsSinceEpoch / 2000,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


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
                            final walletVM = Provider.of<WalletViewModel>(context, listen: false);
                            setState(() {
                              _localLoading = true;
                            });
                            _startLoadingTimeout();
                            try{
                              await walletVM.ensureModalWithValidContext(context);
                              await walletVM.rehydrate();
                              await walletVM.getBalance();
                              await walletVM.getExistingVestingInformation();
                              print('Refresh: Vesting status = ${walletVM.vestingStatus}');
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
                                final isLoading = _localLoading || walletVM.isLoading;
                                print('UI Build: Local loading = $_localLoading, VM loading = ${walletVM.isLoading}, Status = ${walletVM.vestingStatus}');

                                 if(isLoading){
                                  return  Column(
                                    children: [
                                      _ShimmerPlaceholder(height: screenHeight * 0.18, width: double.infinity),
                                      SizedBox(height: screenHeight * 0.02),
                                      _ShimmerPlaceholder(height: screenHeight * 0.05, width: screenWidth * 0.8),
                                      SizedBox(height: screenHeight * 0.02),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _ShimmerPlaceholder(height: screenHeight * 0.3, width: screenWidth * 0.45),
                                          _ShimmerPlaceholder(height: screenHeight * 0.3, width: screenWidth * 0.45),
                                        ],
                                      ),
                                    ],
                                  );
                                }

                                 ///
                                // if(walletVM.vestingStatus == 'locked'){
                                //   // Vesting locked: Show countdown/lock screen
                                //   return VestingLockWidget(
                                //     vestInfo: walletVM.vestInfo,
                                //     walletVM: walletVM,
                                //     onCountdownReady: () => walletVM.getExistingVestingInformation(),
                                //   );
                                // }else if(walletVM.vestingStatus == 'process'){
                                //   // Vesting in process: Show claim/progress screen
                                //   final total = walletVM.vestInfo.totalVestingAmount ?? 0.0;
                                //   if (total == 0.0) {
                                //     // Stale data - show refresh prompt
                                //     return Column(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         Text(
                                //           'Loading vesting details...',
                                //           style: TextStyle(color: Colors.white),
                                //         ),
                                //         SizedBox(height: screenHeight * 0.02),
                                //         BlockButton(
                                //           height: screenHeight * 0.05,
                                //           width: screenWidth * 0.6,
                                //           label: 'Refresh Vesting',
                                //           onTap: () => walletVM.getExistingVestingInformation(),
                                //           gradientColors: [ Color(0xFF2680EF),
                                //             Color(0xFF1CD494)],
                                //         ),
                                //       ],
                                //     );
                                //   }
                                //   return VestingProcessWidget(
                                //     vestInfo: walletVM.vestInfo,
                                //     walletVM: walletVM,
                                //     onClaim: () => walletVM.claimECM(context),
                                //   );
                                // } else {
                                //   return Text(
                                //     "Unknown vesting state",
                                //     style: TextStyle(color: Colors.white, fontSize: getResponsiveFontSize(context, 16)),
                                //   );
                                // }
                                final userBalance = getUserBalance(walletVM);
                                 // No vesting: Show start vesting screen
                                 return Column(
                                   children: [
                                     totalBalance(screenHeight, screenWidth, context, walletVM ,userBalance),
                                     SizedBox(height: screenHeight * 0.02),
                                     whyVesting(screenHeight, screenWidth, context),
                                     SizedBox(height: screenHeight * 0.09),
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

  Widget totalBalance(screenHeight, screenWidth, context ,WalletViewModel walletVm ,double userBalance){
    final isLowBalance = userBalance <= 1;
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
                  onTap:  !_isStartingVesting && walletVm.vestingStatus == null ? ()async{
                    print('Start Vesting button clicked - initiating process');
                    setState(() {
                      _isStartingVesting = true;
                    });

                    try{

                      await walletVm.startVesting(context);
                      print('Start Vesting completed - navigating to vesting status screen');
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VestingStatusScreen(
                              walletVM: walletVm,
                            ),
                          ),
                        );
                      }
                      // await walletVm.getExistingVestingInformation();
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

              ],
            ),
          );
        }
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
}

class VestingStatusScreen extends StatelessWidget {
  final WalletViewModel walletVM;

  const VestingStatusScreen({
    super.key,
    required this.walletVM,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF01090B),
      body: SafeArea(
        child: Consumer<WalletViewModel>(
          builder: (context, walletVM, child) {
            if (walletVM.vestingStatus == 'locked') {
              return VestingLockWidget(
                vestInfo: walletVM.vestInfo,
                walletVM: walletVM,
                onCountdownReady: () => walletVM.getExistingVestingInformation(),
              );
            } else if (walletVM.vestingStatus == 'process') {
              final total = walletVM.vestInfo.totalVestingAmount ?? 0.0;
              if (total == 0.0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Loading vesting details...',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    BlockButton(
                      height: screenHeight * 0.05,
                      width: screenWidth * 0.6,
                      label: 'Refresh Vesting',
                      onTap: () => walletVM.getExistingVestingInformation(),
                      gradientColors: const [Color(0xFF2680EF), Color(0xFF1CD494)],
                    ),
                  ],
                );
              }
              return VestingProcessWidget(
                vestInfo: walletVM.vestInfo,
                walletVM: walletVM,
                onClaim: () => walletVM.claimECM(context),
              );
            } else {
              // Fallback to start screen if status null after vesting
              return Column(
                children: [
                  Text('Vesting initiated. Refreshing...', style: TextStyle(color: Colors.white)),
                  SizedBox(height: screenHeight * 0.02),
                  BlockButton(
                    height: screenHeight * 0.05,
                    width: screenWidth * 0.6,
                    label: 'Refresh',
                    onTap: () => walletVM.getExistingVestingInformation(),
                    gradientColors: const [Color(0xFF2680EF), Color(0xFF1CD494)],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    this.slidePercent = 0.0,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

class VestingLockWidget extends StatefulWidget {
  final VestingInfo vestInfo;
  final WalletViewModel walletVM;
  final VoidCallback onCountdownReady;

  const VestingLockWidget({
    super.key,
    required this.vestInfo,
    required this.walletVM,
    required this.onCountdownReady,
  });

  @override
  State<VestingLockWidget> createState() => _VestingLockWidgetState();
}

class _VestingLockWidgetState extends State<VestingLockWidget> {
  late Duration remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateRemainingTime();
      if (remainingTime <= Duration.zero) {
        timer.cancel();
        widget.onCountdownReady();
        print('VestingLockWidget: Countdown reached zero, refreshing status');
      }
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final start = widget.vestInfo.start;
    if (start! > now) {
      setState(() {
        remainingTime = Duration(seconds: start - now);
      });
    } else {
      remainingTime = Duration.zero;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '$days days $hours hrs $minutes min $seconds sec';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return VestingContainer(
      width: screenWidth * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Vesting Locked',
            style: TextStyle(
              color: Color(0XFFFFF5ED),
              fontSize: getResponsiveFontSize(context, 16),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Time until vesting starts:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: getResponsiveFontSize(context, 14),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
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
              _formatDuration(remainingTime),
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, 20),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Total Vesting Amount: ${widget.vestInfo.totalVestingAmount?.toStringAsFixed(2)} ECM',
            style: TextStyle(
              color: Colors.white,
              fontSize: getResponsiveFontSize(context, 14),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}

class VestingProcessWidget extends StatelessWidget {
  final VestingInfo vestInfo;
  final WalletViewModel walletVM;
  final VoidCallback onClaim;

  const VestingProcessWidget({
    super.key,
    required this.vestInfo,
    required this.walletVM,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final vested = walletVM.vestedAmount ?? 0.0;
    final claimable = walletVM.availableClaimableAmount ?? 0.0;
    final total = walletVM.vestInfo.totalVestingAmount ?? 0.0;
    final progress = total > 0 ? vested / total : 0.0;
    if (total == 0.0) {

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loading vesting details...',
              style: TextStyle(color: Colors.white, fontSize: getResponsiveFontSize(context, 16)),
            ),
            SizedBox(height: screenHeight * 0.02),
            BlockButton(
              height: screenHeight * 0.05,
              width: screenWidth * 0.6,
              label: 'Refresh Vesting',
              onTap: () => walletVM.getExistingVestingInformation(), gradientColors: [Color(0xFF2680EF), Color(0xFF1CD494),],
            ),
          ],
        ),
      );
    }
    return VestingContainer(
      width: screenWidth * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Vesting in Progress',
            style: TextStyle(
              color: Color(0XFFFFF5ED),
              fontSize: getResponsiveFontSize(context, 16),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Vested: ${vested.toStringAsFixed(2)} / ${total.toStringAsFixed(2)} ECM',
            style: TextStyle(
              color: Colors.white,
              fontSize: getResponsiveFontSize(context, 14),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1CD494)),
            minHeight: 8,
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Claimable: ${claimable.toStringAsFixed(2)} ECM',
            style: TextStyle(
              color: Colors.white,
              fontSize: getResponsiveFontSize(context, 14),
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlockButton(
                height: screenHeight * 0.05,
                width: screenWidth * 0.4,
                label: 'Claim Now',
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(context, 16),
                  height: 1.6,
                ),
                gradientColors: const [
                  Color(0xFF2680EF),
                  Color(0xFF1CD494),
                ],
                onTap: onClaim,
              ),
              SizedBox(width: screenWidth * 0.02),
              BlockButton(
                height: screenHeight * 0.05,
                width: screenWidth * 0.4,
                label: 'Refresh',
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(context, 16),
                  height: 1.6,
                ),
                gradientColors: const [
                  Color(0xFF2680EF),
                  Color(0xFF1CD494),
                ],
                onTap: () async {
                  try {
                    await walletVM.refreshVesting();
                    print('VestingProcessWidget: refreshVesting completed');
                  } catch (e) {
                    print('VestingProcessWidget: refreshVesting error: $e');
                  }
                },
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
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




