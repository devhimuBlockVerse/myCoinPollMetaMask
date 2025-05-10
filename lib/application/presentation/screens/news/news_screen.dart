import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../framework/components/CardNewsComponent.dart';
import '../digital_model_screen.dart';
import '../home/home_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() =>
      _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
            children: [
              Center(
                // child: CardNewsComponent(),
                child: CardNewsComponent(
                  imageUrl:"assets/icons/addSourceImage.png",
                  source: "Mycoinpoll",
                  timeAgo: "47mnt ago",
                  headline:"Trump crypto soars as president offers dinner to top holders...",
                ),
              )

            ],
          )
      ),
    );
  }
}
