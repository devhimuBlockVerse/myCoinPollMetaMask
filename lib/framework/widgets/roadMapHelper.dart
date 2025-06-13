import 'package:flutter/material.dart';

import '../components/roadMapContainerComponent.dart';
import '../utils/dialog_utils.dart';


Widget buildRoadmapSection(BuildContext context, double screenHeight) {

  final List<Map<String, dynamic>> roadmapItems = [
    {
      'title': 'Start Walking',
      'labels': [
        'Plan Creation',
        'Token Concept Development',
        'Community Build Plan',
        'MyCoinPoll.Com Site Create.'
      ],
      'onTap': () => DialogUtils.startWalkingDialog(context),
      'year':"2022",

    },
    {
      'title': 'Launching Lots of Project',
      'labels': [
        'MyCoinPoll.Com Site launched',
        'MyCoinPoll.Com ETH Community Donation Program launched',
        'MyCoinPoll.Com USDT Community Donation Program launched',
        '1000+ MyCoinPoll.Com Community Member',
      ],
      'onTap': () => DialogUtils.launchingProjectDialog(context),
      'year':"2023",
    },
    {
      'title': 'Launching ICO or Androverse',
      'labels': [
        'Launching ICO or Androverse',
        'MyCoinPoll.Com Site Update 2.0.',
        'MyCoinPoll.Com Site Update 2.0.2',
        'MyCoinPoll.Com Site Update 2.0.3 (Web3 Connected)',
      ],
      'onTap': () => DialogUtils.launchingIcoDialog(context),
      'year':"2024-Q1",
    },
    {
      'title': 'ECM COIN',
      'labels': [
        'ECM COIN Public Presale (Round 03)',
        'ECM COIN Public Presale (Round 04)',
        'Smart Contracts Development',
        'Smart Contracts Development'
      ],
      'onTap': () => DialogUtils.ecmCoinDialog(context),
      'year':"2024-Q2",
    },
    {
      'title': 'Update & Development',
      'labels': [
        'Community building',
        'MyCoinPoll.Com Site Update 2.0.4',
        'MyCoinPoll.Com Site Update 2.0.5',
        'ECM Token Distribute Private Holder',
      ],
      'onTap': () => DialogUtils.updateAndDevelopmentDialog(context),
      'year':"2024-Q3",
    },
    {
      'title': 'ECM ICO launch',
      'labels': [
        'The founder company has done business registration as a crypto exchanger.',
        'Telegram Tap to Earn Game Development Planning',
        'Androverse Access & VA Selling Planning',
        'ECM ICO Launch(www.mycoinpoll.com)',
      ],
      'onTap': () => DialogUtils.ecmIcoLaunchDialog(context),
      'year':"2024-Q4",
    },
    {
      'title': 'Launching & Listing',
      'labels': [
        'Launching Multi Trading Platform',
        'CEX (Centralized Exchange) launch -bCoinMart.com',
        'Tier 1 CEX listings',
        'Tier 2 CEX listings (ECM COIN LISTING)',
      ],
      'onTap': () => DialogUtils.launchingAndListingDialog(context),
      'year':"2025-Q1",
    },
    {
      'title': 'More Project Launching',
      'labels': [
        'Launching Multi Copy Trading Platform',
        'ECM COIN LISTING Other CEX (Binance , Bybit , Kucoin & others)',
        'Staking Project Launching',
        'Androverse Platform Update V0.2',
      ],
      'onTap': () => DialogUtils.moreProjectDialog(context),
      'year':"2025-Q2",
    },
    {
      'title': 'ECM Blockchain',
      'labels': [
        'ECM launches own BlockChain',
        'ECM COIN transactions will be connected to the e-commerce sites',
        'Androverse Platform Update V0.3',
        'More to be announced',
      ],
      'year':"2025-Q3",
    },
    {
      'title': 'More to be announced',
      'labels': ['More to be announced'],
      'year':"2025-Q4",
    },
  ];

  List<Widget> roadmapWidgets = [];

  for (int i = 0; i < roadmapItems.length; i++) {
    roadmapWidgets.add(
      RoadmapContainerComponent(
        title: roadmapItems[i]['title'],
        labels: roadmapItems[i]['labels'],
        onTap: roadmapItems[i]['onTap'],
        mapYear: roadmapItems[i]['year'],
      ),
    );

    // Add the line image between items (not after the last one)
    if (i < roadmapItems.length - 1) {
      roadmapWidgets.add(SizedBox(height: screenHeight * 0.03));
      roadmapWidgets.add(
        Center(
          child: Transform.translate(
            offset: const Offset(3, -28),
            child: Image.asset(
              'assets/icons/line.png',
              height: screenHeight * 0.07,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );

      roadmapWidgets.add(SizedBox(height: screenHeight * 0.03));
    }
  }

  return SizedBox(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: roadmapWidgets,
    ),
  );

}
