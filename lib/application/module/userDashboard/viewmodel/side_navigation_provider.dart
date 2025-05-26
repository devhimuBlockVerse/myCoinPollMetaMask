
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../framework/res/colors.dart';
import '../../../domain/model/nav_item.dart';

class NavigationProvider extends ChangeNotifier {
  String _currentScreenId = 'milestone';
  String get currentScreenId => _currentScreenId;

  void setScreen(String id) {
    _currentScreenId = id;
    notifyListeners();
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
      id: 'milestone',
      title: 'Milestone',
      iconPath: 'assets/icons/milestone.svg',
      screenBuilder: (context) =>
      const PlaceholderScreen(screenName: 'Milestone Screen'),
    ),
    NavItem(
      id: 'kyc',
      title: 'KYC',
      iconPath: 'assets/icons/kyc.svg',
      screenBuilder: (context) =>
      const PlaceholderScreen(screenName: 'KYC Screen'),
    ),
    NavItem(
      id: 'purchase_log',
      title: 'Purchase Log',
      iconPath: 'assets/icons/purchase_log.svg',
      screenBuilder: (context) =>
      const PlaceholderScreen(screenName: 'Purchase Log Screen'),
    ),
    NavItem(
      id: 'wallet',
      title: 'Wallet',
      iconPath: 'assets/icons/wallet.svg',
      screenBuilder: (context) =>
      const PlaceholderScreen(screenName: 'Wallet Screen'),
    ),
    NavItem(
      id: 'referral_stat',
      title: 'Referral Stat',
      iconPath: 'assets/icons/referral.svg',
      screenBuilder: (context) =>
      const PlaceholderScreen(screenName: 'Wallet Screen'),
    ),
    NavItem(
      id: 'referral_transaction',
      title: 'Referral Transaction',
      iconPath: 'assets/icons/referral_transaction.svg',
      screenBuilder: (context) =>
      const PlaceholderScreen(screenName: 'Wallet Screen'),
    ),
    NavItem(
      id: 'support_ticket',
      title: 'Support Ticket',
      iconPath: 'assets/icons/support_ticket.svg',
      screenBuilder: (context) =>
      const PlaceholderScreen(screenName: 'Wallet Screen'),
    ),
    NavItem(
      id: 'log_out',
      title: 'Logout',
      iconPath: 'assets/icons/logout.svg',
      screenBuilder: (context) =>
      const PlaceholderScreen(screenName: 'Wallet Screen'),
    ),
  ];
}



/// Replace With Original Screens
class PlaceholderScreen extends StatelessWidget {
  final String screenName;
  const PlaceholderScreen({Key? key, required this.screenName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenName),
        backgroundColor: AppColors.drawerGradientEnd,
      ),
      body: Center(child: Text("Content for $screenName")),
    );
  }
}
