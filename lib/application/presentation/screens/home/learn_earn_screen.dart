import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../framework/components/LearnAndEarnComponent.dart';


class LearnEarnScreen extends StatefulWidget {
  const LearnEarnScreen({super.key});

  @override
  State<LearnEarnScreen> createState() => _LearnEarnScreenState();
}

class _LearnEarnScreenState extends State<LearnEarnScreen> {


  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;


    return  Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:  Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Color(0xFF01090B),
            image: DecorationImage(
              image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: screenHeight * 0.01),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                        'assets/icons/back_button.svg',
                        color: Colors.white,
                        width: screenWidth * 0.04,
                        height: screenWidth * 0.04
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Learn & Earn',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.05,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.12),
                ],
              ),

              SizedBox(height: screenHeight * 0.01),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                           _headerSection(context),
                          SizedBox(height: screenHeight * 0.04),
                          Text(
                            'Learn & Earn',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: baseSize * 0.045,
                              height: 1.2,
                              color: Colors.white,
                            ),
                          ),



                          SizedBox(height: screenHeight * 0.03),

                          LearnAndEarnContainer(
                            title: 'Blockchain Fundamentals & Analysis',
                            description: 'Explore how blockchain is revolutionizing industries with secure, transparent, and efficient data handling.',
                            imagePath: 'assets/icons/learnAndEarnImg.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LearnEarnScreen()),
                              );
                            },
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          LearnAndEarnContainer(
                            title: 'Blockchain Fundamentals & Analysis',
                            description: 'Explore how blockchain is revolutionizing industries with secure, transparent, and efficient data handling.',
                            imagePath: 'assets/icons/lesson2.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LearnEarnScreen()),
                              );
                            },
                          ),

                          SizedBox(height: screenHeight * 0.05),


                          // Frame1321314874(),

                          _disclaimerSection(),

                          SizedBox(height: screenHeight * 0.03),


                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _headerSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.16,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/bgContainerImg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.035,
          vertical: screenHeight * 0.015,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: AutoSizeText(
                       'Grow Your Crypto Knowledge',
                      style: TextStyle(
                        color: const Color(0xFFFFF5ED),
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  Flexible(
                    child: AutoSizeText(
                      'Earn free crypto by completing short courses on blockchain, DeFi, and emerging tech.',
                      style: TextStyle(
                        color: const Color(0xFFFFF5ED),
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Image.asset(
                'assets/icons/headerFrameContainer.png',
                height: screenHeight * 0.12,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _disclaimerSection(){
    final screenWidth = MediaQuery.of(context).size.width;
    final baseSize = screenWidth / 375; // base size for scaling fonts and paddings

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: baseSize * 15,
        vertical: baseSize * 10,
      ),
      decoration: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF2B2D40)),
          borderRadius: BorderRadius.circular(baseSize * 8),
        ),

      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: baseSize * 27,
            height: baseSize * 27,
            child: SvgPicture.asset(
              'assets/icons/warningIcon.svg',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: baseSize * 15),
          Expanded(
            child: AutoSizeText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                    'Disclaimer and Risk Warning: This content is for educational purposes only and not financial advice. Digital assets are volatile; invest at your own risk. Binance Academy is not liable for any losses. For more information, see our ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms of Use',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,

                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // TODO: Handle Terms of Use tap
                      },
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Risk Warning',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // TODO: Handle Risk Warning tap
                      },
                  ),
                  TextSpan(
                    text: '.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: baseSize * 11,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      height: 1.6,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
              minFontSize: 8,
              maxFontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}




