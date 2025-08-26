import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/dashboard/dashboard_screen.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/ecm_ico/Ico_screen.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/staking/staking_screen.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/transactions/transaction_screen.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/vesting/start_vesting_view.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/vesting/vesting_view.dart';
 import 'package:mycoinpoll_metamask/application/module/userDashboard/viewmodel/dashboard_nav_provider.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/viewmodel/vesting_status_provider.dart';
import 'package:provider/provider.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/viewmodel/wallet_view_model.dart';

class DashboardBottomNavBar extends StatefulWidget {
  const DashboardBottomNavBar({super.key});

  @override
  State<DashboardBottomNavBar> createState() => _DashboardBottomNavBarState();
}
class _DashboardBottomNavBarState extends State<DashboardBottomNavBar> {
  final List<Widget> _pages = [
    const DashboardScreen(),
    const ECMIcoScreen(),
    const StakingScreen(),
    const VestingWrapper(),

    // const VestingView(),
    // const StartVestingView(),
    // const SleepPeriodScreen(),
    const ProfileScreen(),
  ];

  final List<String> _labels = ['Dashboard', 'ECM ICO', 'Staking', 'Vesting', 'Settings'];

  final List<String> _imgPaths = [
    'assets/icons/dasboard.svg',
    'assets/icons/ico.svg',
    'assets/icons/staking.svg',
    'assets/icons/vesting.svg',
    'assets/icons/profileIcon.svg',
  ];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vestingProvider = Provider.of<VestingStatusProvider>(context, listen: false);
      vestingProvider.loadFromBackend();
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    // Scaling factors
    double scaleFont(double size) => size * (screenWidth + screenHeight) / 1700;
    double scaleWidth(double size) => size * screenWidth / 375;
    double scaleHeight(double size) => size * screenHeight / 812;

    final currentIndex = Provider.of<DashboardNavProvider>(context).currentIndex;
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    return SafeArea(
      child: Scaffold(
         backgroundColor: Colors.transparent,
        // body: _pages[currentIndex],
        body: IndexedStack(
          index: currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              height: scaleHeight(75),
              padding: EdgeInsets.symmetric(
                horizontal: scaleWidth(15),
                vertical: scaleHeight(8),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF141521).withOpacity(0.85),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.05),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_labels.length, (index) {
                  final isSelected = currentIndex == index;
                  return InkWell(
                    // onTap: ()async {
                    //   Provider.of<DashboardNavProvider>(context, listen: false).setIndex(index);
                    //   if (index == 3) {
                    //     Provider.of<VestingStatusProvider>(context, listen: false).loadFromBackend();
                    //
                    //     final walletVM = Provider.of<WalletViewModel>(context, listen: false);
                    //     final walletAddress = walletVM.walletAddress ;
                    //     await walletVM.getVestingInformation();
                    //
                    //     if(walletAddress == null || walletAddress.isEmpty){
                    //       debugPrint("No wallet connected. Opening wallet connect modal...");
                    //       walletVM.ensureModalWithValidContext(context);
                    //       walletVM.appKitModal?.openModalView();
                    //
                    //     }
                    //     debugPrint("User Wallet Address: $walletAddress");
                    //   }
                    //
                    // },

                     onTap: () async {
                      // Change the page index first
                      Provider.of<DashboardNavProvider>(context, listen: false).setIndex(index);

                      if (index == 3) {

                         if (walletVM.walletAddress == null || walletVM.walletAddress!.isEmpty) {
                           debugPrint("No wallet connected. Opening wallet connect modal...");
                           walletVM.ensureModalWithValidContext(context);
                           await walletVM.appKitModal?.openModalView();
                        } else {
                           debugPrint("User Wallet Address: ${walletVM.walletAddress}");
                           debugPrint("✅ Tapped Vesting tab. Calling getVestingInformation now...");

                           await walletVM.getVestingInformation();
                        }

                        // This call can be made after the main logic
                        Provider.of<VestingStatusProvider>(context, listen: false).loadFromBackend();
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: scaleWidth(50),
                          child: SvgPicture.asset(
                            _imgPaths[index],
                            color: isSelected ? const Color(0xFF6BB2FF) : const Color(0xFFB2B0B6),
                            height: scaleHeight(18),
                            width: scaleWidth(10),
                          ),
                        ),
                        SizedBox(height: scaleHeight(4)),
                        Text(
                          _labels[index],
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF6BB2FF) : const Color(0xFFB2B0B6),
                            fontSize: isSelected ? scaleFont(18) : scaleFont(16),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

