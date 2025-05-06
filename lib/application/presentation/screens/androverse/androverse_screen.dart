import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

import '../../../../framework/components/BlockButton.dart';
import '../../viewmodel/bottom_nav_provider.dart';
import '../bottom_nav_bar.dart';

class AndroVerseScreen extends StatefulWidget {
  const AndroVerseScreen({super.key});

  @override
  State<AndroVerseScreen> createState() => _AndroVerseScreenState();
}

class _AndroVerseScreenState extends State<AndroVerseScreen> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    // Dynamic multipliers
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xFF0B0A1E),

        body: Stack(
          children: [
            Positioned(
              top: -screenHeight * 0.01,
              right: -screenWidth * 0.09,
              child: Container(
                width: screenWidth ,
                height: screenWidth ,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/icons/gradientBgImage.png',
                  width: screenWidth ,
                  height: screenHeight ,
                  fit: BoxFit.fill,
                ),
              ),

            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),


                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        'Welcome to Androverse',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600, // SemiBold in Figma
                          fontSize: baseSize * 0.05,
                          height: 0.8,
                          color: Color(0xFFFFF5ED),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      Text(
                        'The Future is Loading...',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: baseSize * 0.035,
                          height: 1.2,
                          color:Color(0xCCFFF5ED),
                        ),
                        textAlign: TextAlign.center,
                      ),


                      SizedBox(height: screenHeight * 0.04),


                      Image.asset(
                        'assets/icons/androverseHumanImg.png',
                        width: isPortrait ? screenWidth * 0.8 : screenWidth * 0.5,
                        height: isPortrait ? screenHeight * 0.35 : screenHeight * 0.5,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      Text(
                        'This page isn\'t available right now..',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          fontSize: baseSize * 0.038,
                          height: 0.8,
                          color: Color(0xFFFFF5ED),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.015),

                      Text(
                        'Explore digital ownership, trade NFTs, and unlock a new world coming back soon!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color:Color(0xCCFFF5ED),
                          fontWeight: FontWeight.w400,
                          fontSize: baseSize * 0.032,
                          height: 1.23,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      BlockButton(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.4,
                        label: 'Go Back to Home',
                        textStyle:  TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: baseSize * 0.035,
                        ),
                        gradientColors: const [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494)
                          // 1CD494
                        ],
                        onTap: () {
                          Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);  // Go to Home Screen
                        },
                        iconPath: 'assets/icons/arrowIcon.png',
                        iconSize : screenHeight * 0.028,
                      ),

                    ],
                  ),
                ),
              ),
            )

          ],
        ),

      ),
    );
  }

 }
