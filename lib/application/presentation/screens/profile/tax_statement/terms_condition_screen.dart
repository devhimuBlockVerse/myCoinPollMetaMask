import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../framework/utils/dynamicFontSize.dart';


class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
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

              image: AssetImage('assets/icons/solidBackGround.png'),
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
                // crossAxisAlignment: CrossAxisAlignment.center,
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
                        'Terms and Conditions',
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
                  SizedBox(width: screenWidth * 0.12), // Responsive spacer for balance
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


                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "1. Types data we collect",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: const Color(0xffFEFEFE),
                                fontWeight: FontWeight.w600,
                                fontSize: getResponsiveFontSize(context, 16),
                                height: 1.3,
                                letterSpacing: 0.1,
                              ),),
                          ),
                          SizedBox(height: screenHeight * 0.02),


                          AutoSizeText(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident.",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: getResponsiveFontSize(context, 12),
                              height: 1.6,
                              letterSpacing: getResponsiveFontSize(context, 12) * 0.0025,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),


                          SizedBox(height: screenHeight * 0.02),

                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "2. Use of your personal data",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: const Color(0xffFEFEFE),
                                fontWeight: FontWeight.w600,
                                fontSize: getResponsiveFontSize(context, 16),
                                height: 1.3,
                                letterSpacing: 0.1,
                              ),),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          AutoSizeText(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: getResponsiveFontSize(context, 12),
                              height: 1.6,
                              letterSpacing: getResponsiveFontSize(context, 12) * 0.0025,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),

                          SizedBox(height: screenHeight * 0.02),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "3. Disclosure of your personal data",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: const Color(0xffFEFEFE),
                                fontWeight: FontWeight.w600,
                                fontSize: getResponsiveFontSize(context, 16),
                                height: 1.3,
                                letterSpacing: 0.1,
                              ),),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          AutoSizeText(

                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: getResponsiveFontSize(context, 12),
                              height: 1.6,
                              letterSpacing: getResponsiveFontSize(context, 12) * 0.0025,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "4. Disclosure of your personal data",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: const Color(0xffFEFEFE),
                                fontWeight: FontWeight.w600,
                                fontSize: getResponsiveFontSize(context, 16),
                                height: 1.3,
                                letterSpacing: 0.1,
                              ),),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          AutoSizeText(
                            "Lorem ipsum dolor sit amen, consectetur adipescent alit, sed do eiusmod temper incident ut labored et dolore magna aliquant. Ut enim ad minim veniam, quips nostrum exercitation ullamco laboris nisi ut aliquip ex ea commode consequent.",
                             style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: getResponsiveFontSize(context, 12),
                              height: 1.6,
                              letterSpacing: getResponsiveFontSize(context, 12) * 0.0025,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),


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

}
