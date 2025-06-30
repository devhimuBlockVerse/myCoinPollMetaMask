import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/utils/dynamicFontSize.dart';
import '../../viewmodel/bottom_nav_provider.dart';

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

    return Scaffold(
      extendBodyBehindAppBar: true,
       // backgroundColor: Color(0xFF01090B),
      backgroundColor: Colors.transparent,
      body: SafeArea(
          top: false,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              color: Color(0xFF01090B),
              image: DecorationImage(
                // image: AssetImage('assets/icons/gradientBgImage.png'),
                // fit: BoxFit.contain,
                image: AssetImage('assets/icons/starGradientBg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topRight,
              ),
            ),
            child: SingleChildScrollView(
              // padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.09,
                  ),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      Text(
                        'Welcome to Androverse',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600, // SemiBold in Figma
                          // fontSize: baseSize * 0.05,
                          fontSize: getResponsiveFontSize(context, 20),
                          height: 1.6,
                          // height: 0.8,
                          color: const Color(0xFFFFF5ED),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      Text(
                        'The Future is Loading...',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          // fontSize: baseSize * 0.035,
                          // height: 1.2,
                          fontSize: getResponsiveFontSize(context, 14),
                          height: 1.6,
                          color:const Color(0xCCFFF5ED),
                        ),
                        textAlign: TextAlign.center,
                      ),


                      SizedBox(height: screenHeight * 0.02),


                      Image.asset(
                        // 'assets/icons/androverseHumanImg.png',
                        'assets/icons/metaversworld.png',
                        width: isPortrait ? screenWidth * 0.8 : screenWidth * 0.5,
                        height: isPortrait ? screenHeight * 0.38 : screenHeight * 0.5,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      Text(
                        'This page isn\'t available right now..',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          // fontSize: baseSize * 0.038,
                          // height: 0.8,
                          fontSize: getResponsiveFontSize(context, 14),
                          height: 1.6,
                          color: const Color(0xFFFFF5ED),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.015),

                      Text(
                        'Explore digital ownership, trade NFTs, and unlock a new world coming back soon!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color:const Color(0xCCFFF5ED),
                          fontWeight: FontWeight.w400,
                          // fontSize: baseSize * 0.032,
                          // height: 1.23,
                          fontSize: getResponsiveFontSize(context, 12),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      BlockButton(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.5,
                        label: 'Go Back to Home',
                        textStyle:  TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          // fontSize: baseSize * 0.035,
                          fontSize: getResponsiveFontSize(context, 15),
                          height: 1.6,
                        ),
                        gradientColors: const [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494)
                          // 1CD494
                        ],
                        onTap: () {
                          Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);  // Go to Home Screen
                        },
                        iconPath: 'assets/icons/arrowIcon.svg',
                        iconSize : screenHeight * 0.013,
                      ),

                    ],
                  ),
                ),
              ),
            ),
          )

      )

    );
  }

 }
