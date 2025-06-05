
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/milestone/mileston_screen.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/supportTicket/suppor_ticket_screen.dart';

import '../../../../framework/res/colors.dart';
import '../../../domain/model/nav_item.dart';
import '../view/kyc/kyc_screen.dart';
import '../view/purchaseLog/purchase_log_screen.dart';
import '../view/referralStat/referralStatScreen.dart';
import '../view/referralTransaction/referral_transaction_screen.dart';
import '../view/supportTicket/widget/ticket_description_card.dart';
import '../view/wallet/wallet_screen.dart';

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
    NavItem(
      id: 'milestone',
      title: 'Milestone',
      iconPath: 'assets/icons/milestone.svg',
      screenBuilder: (context) => const MilestonScreen(),
    ),
    NavItem(
      id: 'kyc',
      title: 'KYC',
      iconPath: 'assets/icons/kyc.svg',
      screenBuilder: (context) => const KycScreen(),
    ),
    NavItem(
      id: 'purchase_log',
      title: 'Purchase Log',
      iconPath: 'assets/icons/purchase_log.svg',
      screenBuilder: (context) => const PurchaseLogScreen(),

    ),
    NavItem(
      id: 'wallet',
      title: 'Wallet',
      iconPath: 'assets/icons/wallet.svg',
      screenBuilder: (context) => const WalletScreen(),

    ),

    NavItem(
      id: 'referral_stat',
      title: 'Referral Stat',
      iconPath: 'assets/icons/referral.svg',
      screenBuilder: (context) => const ReferralStatScreen(),

  ),
    NavItem(
      id: 'referral_transaction',
      title: 'Referral Transaction',
      iconPath: 'assets/icons/referral_transaction.svg',
      screenBuilder: (context) => const ReferralTransactionScreen(),

    ),
    NavItem(
      id: 'support_ticket',
      title: 'Support Ticket',
      iconPath: 'assets/icons/support_ticket.svg',
      screenBuilder: (context) => const SupportTicketScreen(),

    ),
    NavItem(
      id: 'log_out',
      title: 'Logout',
      iconPath: 'assets/icons/logout.svg',
      onTap: (context) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CloseTicketDialog(
            title: 'Logout',
            message: 'Are you sure you want to log out?',
            yesLabel: 'Yes',
            onYes: () {
              Navigator.of(context).pop();

            },
            onNo: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    ),
  ];
}

