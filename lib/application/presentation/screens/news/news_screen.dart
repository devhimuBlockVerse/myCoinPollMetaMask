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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'News',
          style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF01090B),
            image: DecorationImage(
              image: AssetImage('assets/icons/gradientBgImage.png'),
              fit: BoxFit.contain,
              alignment: Alignment.topRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: screenHeight * 0.06),

                ],
              ),
            ),
          ),
        ),
      ),

     );
  }
}




//CardNewsComponent(
//                   imageUrl:"assets/icons/addSourceImage.png",
//                   source: "Mycoinpoll",
//                   timeAgo: "47mnt ago",
//                   headline:"Trump crypto soars as president offers dinner to top holders...",
//                 ),