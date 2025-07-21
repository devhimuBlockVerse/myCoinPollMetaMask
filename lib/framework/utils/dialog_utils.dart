import 'package:flutter/material.dart';

import '../../application/domain/model/DialogModel.dart';
import '../components/CustomDialog.dart';

class DialogUtils {

  static void startWalkingDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.2),
      pageBuilder: (_, __, ___) {
        return  CustomDialog(
          title: 'Start Walking',
          subtitle: '2022',
          items: [


            DialogItem(text: 'Plan Creation', icon: Icons.check_box),
            DialogItem(text: 'Token Concept Development', icon: Icons.check_box),
            DialogItem(text: 'Community Build Plan', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll.Com Site Create', icon: Icons.check_box),
            DialogItem(text: 'ECM Eco System Development Planning', icon: Icons.check_box),
          ],
        );
      },
    );
  }

  static void launchingProjectDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.2),
      pageBuilder: (_, __, ___) {
        return  CustomDialog(
          title: 'Launching Lots of Project',
          image: 'assets/images/dialogBgvv.png',

          subtitle: '2023',
          items: [

            DialogItem(text: 'MyCoinPoll.Com Site launched', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll.Com ETH Community Donation Program launched', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll.Com USDT Community Donation Program launched', icon: Icons.check_box),
            DialogItem(text: '1000+ MyCoinPoll.Com Community Member', icon: Icons.check_box),
            DialogItem(text: 'Pre-Launch Planning', icon: Icons.check_box),
            DialogItem(text: 'Business Model', icon: Icons.check_box),
            DialogItem(text: 'ECM COIN Private Presale Start', icon: Icons.check_box),
            DialogItem(text: 'ECM COIN Public Presale Start (Round 01)', icon: Icons.check_box),
            DialogItem(text: 'Development of ECM Blockchain and Androverse has been started', icon: Icons.check_box),
          ],
        );
      },
    );
  }

  static void launchingIcoDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.2),
      pageBuilder: (_, __, ___) {
        return  CustomDialog(
          title: 'Launching ICO or Androverse',
          image: 'assets/images/dialogBgvv.png',

          subtitle: '2024-Q1',
          items: [

            DialogItem(text: 'MyCoinPoll.Com Site Update 2.0.0', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll.Com Site Update 2.0.1', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll.Com Site Update 2.0.2', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll.Com Site Update 2.0.3 (Web3 Connected)', icon: Icons.check_box),
            DialogItem(text: 'ECM COIN Public Presale (Round 02)', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll.Com Site launching ICO & ITO Launchpad.', icon: Icons.check_box),
          ],
        );
      },
    );
  }

  static void ecmCoinDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.2),
      pageBuilder: (_, __, ___) {
        return  CustomDialog(
          title: 'ECM Coin',
          image: 'assets/images/dialogBgvv.png',

          subtitle: '2024-Q2',
          items: [

            DialogItem(text: 'ECM COIN Public Presale (Round 03)', icon: Icons.check_box),
            DialogItem(text: 'ECM COIN Public Presale (Round 04)', icon: Icons.check_box),
            DialogItem(text: 'Smart Contracts Development', icon: Icons.check_box),
            DialogItem(text: 'Platform Security Algorithm Schema', icon: Icons.check_box),
            DialogItem(text: 'White Paper & Smart Contracts Final Audit Reports', icon: Icons.check_box),
          ],
        );
      },
    );
  }

  static void updateAndDevelopmentDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.2),
      pageBuilder: (_, __, ___) {
        return  CustomDialog(
          title: 'Update & Development',
          subtitle: '2024-Q3',
          image: 'assets/images/dialogBgvv.png',
          items: [

            DialogItem(text: 'Community building', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll.Com Site Update 2.0.4', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll.Com Site Update 2.0.5', icon: Icons.check_box),
            DialogItem(text: 'ECM Token Distribute Private Holder', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll.Com Site Update 2.0.6', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll.Com Site Update 2.0.7', icon: Icons.check_box),
            DialogItem(text: 'The first phase of the Androverse is created', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll Mobile App Development Planning', icon: Icons.check_box),
          ],
        );
      },
    );
  }

  static void ecmIcoLaunchDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.2),
      pageBuilder: (_, __, ___) {
        return  CustomDialog(
          title: 'ECM ICO launch',
          image: 'assets/images/dialogBgvv.png',
          subtitle: '2024-Q4',
          items: [

            DialogItem(text: 'The founder company has done business registration as a crypto exchanger.', icon: Icons.check_box),
            DialogItem(text: 'Androverse Access & VA Selling Planning', icon: Icons.check_box),
            DialogItem(text: 'ECM ICO Launch(www.mycoinpoll.com)', icon: Icons.check_box),
            DialogItem(text: 'Telegram Tap to Earn Game Launching', icon: Icons.check_box),
            DialogItem(text: 'Press releases', icon: Icons.check_box),
            DialogItem(text: 'Marketing articles published on major platforms', icon: Icons.check_box),
            DialogItem(text: 'MyCoinPoll Mobile App Launching', icon: Icons.timer),
            DialogItem(text: 'ECM ICO launch on more than 50 websites', icon: Icons.timer),
            DialogItem(text: 'Androverse Access & VA Presale Start', icon: Icons.timer),
          ],
        );
      },
    );
  }

  static void launchingAndListingDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.2),
      pageBuilder: (_, __, ___) {
        return  CustomDialog(
          title: 'Launching & Listing',
          image: 'assets/images/dialogBgvv.png',
          subtitle: '2025-Q1',
          items: [

            DialogItem(text: 'Launching Multi Trading Platform', icon: Icons.timer),
            DialogItem(text: 'CEX (Centralized Exchange) launch -bCoinMart.com', icon: Icons.timer),
            DialogItem(text: 'Tier 1 CEX listings', icon: Icons.timer),
            DialogItem(text: 'Tier 2 CEX listings (ECM COIN LISTING)', icon: Icons.timer),
            DialogItem(text: 'CoinMarketCap Listing', icon: Icons.timer),
            DialogItem(text: 'CoinGecko Listing', icon: Icons.timer),
            DialogItem(text: 'Activity open Androverse Platform for VA & Access Holder V0.1', icon: Icons.timer),

          ],
        );
      },
    );
  }

  static void moreProjectDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.2),
      pageBuilder: (_, __, ___) {
        return  CustomDialog(
          title: 'More Project Launching',
          subtitle: '2025-Q2',
          image: 'assets/images/dialogBgvv.png',

          items: [

            DialogItem(text: 'Launching Multi Copy Trading Platform', icon: Icons.timer),
            DialogItem(text: 'ECM COIN LISTING Other CEX (Binance , Bybit , Kucoin & others)', icon: Icons.timer),
            DialogItem(text: 'Staking Project Launching', icon: Icons.timer),
            DialogItem(text: 'Androverse Platform Update V0.2', icon: Icons.timer),
            DialogItem(text: 'MyCoinPoll Listing Others Coin or Token', icon: Icons.timer),

          ],
        );
      },
    );
  }


}


