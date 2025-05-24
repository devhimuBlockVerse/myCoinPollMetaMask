import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

   TextEditingController controller = TextEditingController();

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
                        'Feedback',
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          SizedBox(height: screenHeight * 0.02),


                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.05,
                              vertical: MediaQuery.of(context).size.height * 0.02,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff040C16),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min, // Content height
                              children: [

                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Write your Feedback!',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: const Color(0xFFF4F4F5),
                                      fontWeight: FontWeight.w600,
                                      fontSize: getResponsiveFontSize(context, 16),
                                      height: 1.6,
                                      letterSpacing: -0.40,
                                    ),),
                                ),
                                SizedBox(height: screenHeight * 0.02),

                                Container(
                                  width: screenWidth ,
                                  height: screenHeight * 0.25,
                                  padding: EdgeInsets.all(screenWidth * 0.03),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF101A29),
                                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x3F9C9C9C),
                                        blurRadius: 6.4,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: controller,
                                    maxLines: null,
                                    expands: true,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.035,
                                      fontFamily: 'Poppins',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Feel free to write what you say...',
                                      hintStyle: TextStyle(
                                        color: const Color(0xFF7D8FA9),
                                        fontSize: screenWidth * 0.035,
                                        fontFamily: 'Poppins',
                                        letterSpacing: -0.4,
                                        height: 1.6,
                                      ),
                                      border: InputBorder.none,
                                      isCollapsed: true,
                                    ),
                                    cursorColor: Colors.tealAccent,
                                  ),
                                ),


                                SizedBox(height: screenHeight * 0.03),

                                BlockButton(
                                  height: screenHeight * 0.045,
                                  width: screenWidth * 0.6,
                                  label: 'Submit',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: baseSize * 0.044,
                                  ),
                                  gradientColors: const [
                                    Color(0xFF2680EF),
                                    Color(0xFF1CD494),
                                  ],
                                  onTap: () {

                                  },
                                ),

                                SizedBox(height: screenHeight * 0.01),



                              ],
                            ),
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
