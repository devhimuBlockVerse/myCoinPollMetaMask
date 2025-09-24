import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/dashboard/dashboard_screen.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/ecm_ico/Ico_screen.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/staking/staking_screen.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/vesting/vesting_view.dart';
 import 'package:mycoinpoll_metamask/application/module/userDashboard/viewmodel/dashboard_nav_provider.dart';
import 'package:provider/provider.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/viewmodel/wallet_view_model.dart';
import 'userDashboard/view/transactions/transaction_screen.dart';

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
    // const VestingWrapper(),
    const TransactionScreen(),
    const ProfileScreen(),
  ];

  final List<String> _labels = ['Dashboard', 'ECM ICO', 'Staking', 'Transaction', 'Settings'];

  final List<String> _imgPaths = [
    'assets/icons/dasboard.svg',
    'assets/icons/ico.svg',
    'assets/icons/staking.svg',
    // 'assets/icons/vesting.svg',
    'assets/icons/transaction.svg',
    'assets/icons/profileIcon.svg',
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    double scaleFont(double size) => size * (screenWidth + screenHeight) / 1700;
    double scaleWidth(double size) => size * screenWidth / 375;
    double scaleHeight(double size) => size * screenHeight / 812;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Consumer<DashboardNavProvider>(
          builder: (context, navProvider, child) {
            return IndexedStack(
              index: navProvider.currentIndex,
              children: _pages,
            );
          },
        ),
        bottomNavigationBar: Consumer2<DashboardNavProvider, WalletViewModel>(
          builder: (context, navProvider, walletVM, child) {
            return ClipRRect(
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
                      final isSelected = navProvider.currentIndex == index;
                      return InkWell(
                        onTap: () async {
                          navProvider.setIndex(index);

                          // if (index == 3) {
                          //   // walletVM.getVestingInformation();
                          //
                          //
                          //   if (walletVM.walletAddress == null || walletVM.walletAddress!.isEmpty) {
                          //    await walletVM.ensureModalWithValidContext(context);
                          //    await walletVM.rehydrate();
                          //
                          //     //  await walletVM.appKitModal?.openModalView();
                          //    if (!mounted) return;
                          //    await context.read<WalletViewModel>().openWalletModal(context);
                          //   }
                          // }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: scaleWidth(50),
                              child: SvgPicture.asset(
                                _imgPaths[index],
                                color: isSelected
                                    ? const Color(0xFF6BB2FF)
                                    : const Color(0xFFB2B0B6),
                                height: scaleHeight(18),
                                width: scaleWidth(10),
                              ),
                            ),
                            SizedBox(height: scaleHeight(4)),
                            Text(
                              _labels[index],
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF6BB2FF)
                                    : const Color(0xFFB2B0B6),
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
            );
          },
        ),
      ),
    );
  }


}



