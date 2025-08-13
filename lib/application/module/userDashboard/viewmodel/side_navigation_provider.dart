
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../framework/components/DialogModalViewComponent.dart';
import '../../../domain/model/nav_item.dart';
import '../../../presentation/screens/bottom_nav_bar.dart';
import '../../../presentation/viewmodel/bottom_nav_provider.dart';
import '../../../presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import '../../../presentation/viewmodel/user_auth_provider.dart';
import '../../../presentation/viewmodel/wallet_view_model.dart';
import '../view/purchaseLog/purchase_log_screen.dart';
import '../view/referralStat/referralStatScreen.dart';
import 'dashboard_nav_provider.dart';

// class NavigationProvider extends ChangeNotifier {
//   String _currentScreenId = 'milestone';
//   String get currentScreenId => _currentScreenId;
//
//   void setScreen(String id) {
//
//     if (_currentScreenId != id) {
//       _currentScreenId = id;
//       notifyListeners();
//     }
//   }
//
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//
//   void openDrawer() {
//     scaffoldKey.currentState?.openDrawer();
//   }
//
//   void closeDrawer() {
//     scaffoldKey.currentState?.closeDrawer();
//   }
//
//   List<NavItem> get drawerNavItems => [
//
//     NavItem(
//       id: 'purchase_log',
//       title: 'Purchase Log',
//       iconPath: 'assets/icons/purchase_log.svg',
//       screenBuilder: (context) => const PurchaseLogScreen(),
//
//     ),
//
//
//     NavItem(
//       id: 'referral_stat',
//       title: 'Referral Stat',
//       iconPath: 'assets/icons/referral.svg',
//       screenBuilder: (context) => const ReferralStatScreen(),
//
//   ),
//
//     NavItem(
//       id: 'log_out',
//       // title: 'Logout',
//       title: 'Exit',
//       iconPath: 'assets/icons/logout.svg',
//       onTap: (context) {
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => DialogModalView(
//             title: 'Exit Dashboard',
//             message: 'Do you wish to exit the Dashboard panel?',
//             yesLabel: 'Yes',
//             onYes: () async {
//               try {
//
//                 /// Only remove token-based login prefs
//                 final prefs = await SharedPreferences.getInstance();
//                 await prefs.remove('token');
//                 await prefs.remove('user');
//
//                 // Reset BottomNav index
//                 Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);
//
//                 // Restart app from BottomNavBar with fresh providers
//                 if (context.mounted) {
//                   Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                       builder: (context) => MultiProvider(
//                         providers: [
//                           ChangeNotifierProvider(create: (_) => WalletViewModel()),
//                           ChangeNotifierProvider(create: (_) => BottomNavProvider()),
//                           ChangeNotifierProvider(create: (_) => DashboardNavProvider()),
//                           ChangeNotifierProvider(create: (_) => PersonalViewModel()),
//                           ChangeNotifierProvider(create: (_) => NavigationProvider()),
//                          ],
//                         child: const BottomNavBar(),
//                       ),
//                     ),
//                         (route) => false,
//                   );
//                 }
//               } catch (e) {
//                 if (context.mounted) {
//                   debugPrint('Error during logout: $e');
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Logout failed: ${e.toString()}'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               }
//             },
//             // onNo: () => Navigator.of(context).pop(false),
//           ),
//         );
//       },
//     ),
//   ];
// }
class NavigationProvider extends ChangeNotifier {
  String _currentScreenId = 'milestone';
  String get currentScreenId => _currentScreenId;

  void setScreen(String id) {

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

    NavItem(
      id: 'purchase_log',
      title: 'Purchase Log',
      iconPath: 'assets/icons/purchase_log.svg',
      screenBuilder: (context) => const PurchaseLogScreen(),

    ),


    NavItem(
      id: 'referral_stat',
      title: 'Referral Stat',
      iconPath: 'assets/icons/referral.svg',
      screenBuilder: (context) => const ReferralStatScreen(),

  ),

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

                /// Only remove token-based login prefs
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                await prefs.remove('user');
                await prefs.remove('unique_id');
                await prefs.remove('firstName');
                await prefs.remove('userName');
                await prefs.remove('emailAddress');
                await prefs.remove('phoneNumber');
                await prefs.remove('profileImage');

                final userAuth = Provider.of<UserAuthProvider>(context, listen: false);
                await userAuth.loadUserFromPrefs();

                Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const BottomNavBar()),
                        (_) => false,
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

