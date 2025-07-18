
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/viewmodel/upload_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../framework/components/DialogModalViewComponent.dart';
import '../../../domain/model/nav_item.dart';
import '../../../presentation/screens/bottom_nav_bar.dart';
import '../../../presentation/viewmodel/bottom_nav_provider.dart';
import '../../../presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import '../../../presentation/viewmodel/wallet_view_model.dart';
import '../view/purchaseLog/purchase_log_screen.dart';
import '../view/referralStat/referralStatScreen.dart';
import 'dashboard_nav_provider.dart';
import 'kyc_navigation_provider.dart';

class NavigationProvider extends ChangeNotifier {
  String _currentScreenId = 'milestone';
  String get currentScreenId => _currentScreenId;

  void setScreen(String id) {
    // _currentScreenId = id;
    // notifyListeners();
    if (_currentScreenId != id) {
      _currentScreenId = id;
      notifyListeners();
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }

  List<NavItem> get drawerNavItems => [
    // NavItem(
    //   id: 'milestone',
    //   title: 'Milestone',
    //   iconPath: 'assets/icons/milestone.svg',
    //   screenBuilder: (context) => const MilestoneScreen(),
    // ),
    // NavItem(
    //   id: 'kyc',
    //   title: 'KYC',
    //   iconPath: 'assets/icons/kyc.svg',
    //   screenBuilder: (context) => const KycScreen(),
    // ),
    NavItem(
      id: 'purchase_log',
      title: 'Purchase Log',
      iconPath: 'assets/icons/purchase_log.svg',
      screenBuilder: (context) => const PurchaseLogScreen(),

    ),
    // NavItem(
    //   id: 'wallet',
    //   title: 'Wallet',
    //   iconPath: 'assets/icons/wallet.svg',
    //   screenBuilder: (context) => const WalletScreen(),
    //
    // ),

    NavItem(
      id: 'referral_stat',
      title: 'Referral Stat',
      iconPath: 'assets/icons/referral.svg',
      screenBuilder: (context) => const ReferralStatScreen(),

  ),
    // NavItem(
    //   id: 'referral_transaction',
    //   title: 'Referral Transaction',
    //   iconPath: 'assets/icons/referral_transaction.svg',
    //   screenBuilder: (context) => const ReferralTransactionScreen(),
    //
    // ),
    // NavItem(
    //   id: 'support_ticket',
    //   title: 'Support Ticket',
    //   iconPath: 'assets/icons/support_ticket.svg',
    //   screenBuilder: (context) => const SupportTicketScreen(),
    //
    // ),

    ///
    // NavItem(
    //   id: 'log_out',
    //   // title: 'Logout',
    //   title: 'Exit',
    //   iconPath: 'assets/icons/logout.svg',
    //   onTap: (context) {
    //
    //
    //     showDialog(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (context) => DialogModalView(
    //         title: 'Exit Dashboard',
    //         message: 'Do you wish to exit the Dashboard panel?',
    //         // message: 'Are you sure you want to log out?',
    //         yesLabel: 'Yes',
    //         onYes: ()async {
    //           // final prefs = await SharedPreferences.getInstance();
    //           // await prefs.remove('token');
    //           // await prefs.remove('user');
    //           Navigator.push(context, MaterialPageRoute(builder: (context) =>  BottomNavBar()));
    //
    //
    //         },
    //         onNo: () {
    //           Navigator.of(context).pop();
    //         },
    //       ),
    //     );
    //   },
    // ),


    NavItem(
      id: 'log_out',
      // title: 'Logout',
      title: 'Exit',
      iconPath: 'assets/icons/logout.svg',
      onTap: (context) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => DialogModalView(
            title: 'Exit Dashboard',
            message: 'Do you wish to exit the Dashboard panel?',
            yesLabel: 'Yes',
            onYes: () async {
              try {
                // Clear all shared preferences
                // final prefs = await SharedPreferences.getInstance();
                // await prefs.clear();

                /// Only remove token-based login prefs
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                await prefs.remove('user');

                // Reset BottomNav index
                Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);

                // Restart app from BottomNavBar with fresh providers
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(create: (_) => WalletViewModel()),
                          ChangeNotifierProvider(create: (_) => BottomNavProvider()),
                          ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
                          ChangeNotifierProvider(create: (_) => PersonalViewModel()),
                          ChangeNotifierProvider(create: (_) => NavigationProvider()),
                          ChangeNotifierProvider(create: (_) => KycNavigationProvider()),
                          ChangeNotifierProvider(create: (_) => UploadProvider()),
                        ],
                        child: const BottomNavBar(),
                      ),
                    ),
                        (route) => false,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  debugPrint('Error during logout: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logout failed: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            // onNo: () => Navigator.of(context).pop(false),
          ),
        );
      },
    ),
  ];
}

