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
    return Scaffold(
       extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFF0B0A1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Androverse',
          style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),

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
           SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),


                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [

                       const Text(
                         'Welcome to Androverse',
                         style: TextStyle(
                           fontFamily: 'Poppins',
                           fontWeight: FontWeight.w600, // SemiBold in Figma
                           fontSize: 20,
                           height: 0.8, // Line height = 80%
                           color: Colors.white,
                         ),
                         textAlign: TextAlign.center,
                       ),

                       const SizedBox(height: 10),
                      const  Text(
                         'The Future is Loading...',
                         style: TextStyle(
                           fontFamily: 'Poppins',
                           fontSize: 14,
                           height: 1.2,
                           color: Colors.white70,
                         ),
                         textAlign: TextAlign.center,
                       ),


                       SizedBox(height: screenHeight * 0.05),


                      Image.asset(
                        'assets/icons/androverseHumanImg.png',
                        width: screenWidth ,
                        height: screenHeight * 0.4,
                        fit: BoxFit.contain,
                      ),

                       SizedBox(height: screenHeight * 0.08),
                       const Text(
                         'This page isn\'t available right now..',
                         style: TextStyle(
                           fontFamily: 'Poppins',
                           fontWeight: FontWeight.w600,
                           fontStyle: FontStyle.italic,
                           fontSize: 14,
                           height: 0.8,
                           color: Colors.white,
                         ),
                          textAlign: TextAlign.center,
                       ),
                       const SizedBox(height: 10),

                       const Text(
                         'Explore digital ownership, trade NFTs, and unlock a new world coming back soon!',
                         style: TextStyle(
                           fontFamily: 'Poppins',
                           color: Colors.white,
                           fontWeight: FontWeight.w400,
                           fontSize: 12,
                           height: 1.23,
                         ),
                         textAlign: TextAlign.center,
                       ),
                       const SizedBox(height: 20),

                       BlockButton(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.4,
                        label: 'Go Back to Home',
                        textStyle:  TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: screenWidth * 0.030,
                        ),
                        gradientColors: const [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494)
                          // 1CD494
                        ],
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => HomeScreen(),
                          //   ),
                          // );
                          Provider.of<BottomNavProvider>(context, listen: false).setIndex(0); // News tab

                        },
                        iconPath: 'assets/icons/arrowIcon.png',
                        iconSize : screenHeight * 0.028,
                      ),

                    ],
                  ),
                ),
              ),
            ),


          )

        ],
      ),

     );
  }
}
