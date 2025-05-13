import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      body: SafeArea(
          top: false,

          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF01090B),
              image: DecorationImage(
                // image: AssetImage('assets/icons/starGradientBg.png'),
                image: AssetImage('assets/icons/solidBackGround.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topRight,

              ),
            ),


            child: Column(

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
                          'Personal Information',
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


                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.02),

                          // Frame1321314678(),

                          SizedBox(height: screenHeight * 0.03),

                          /// Profile Action Buttons =>
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              // color: const Color(0xFF01090B),
                              image: DecorationImage(
                                image: AssetImage('assets/icons/profileFrameBg.png'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Color(0XFFFFF5ED),
                                width: 0.1,
                              ),
                            ),

                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                                vertical: screenHeight * 0.02,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [


                                  SizedBox(height: screenHeight * 0.02),

                                  SizedBox(
                                    width: screenWidth * 0.8, // Responsive width
                                    child: Opacity(
                                      opacity: 0.50,
                                      child: Text(
                                        'This service is provided by Team.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.028,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.04),


                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )

      ),
    );
  }
}




class Frame1321314678 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 134,
          height: 126,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: NetworkImage("https://picsum.photos/90/90"),
                            fit: BoxFit.fill,
                          ),
                          shape: OvalBorder(
                            side: BorderSide(width: 1, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 61,
                      top: 74,
                      child: Container(
                        width: 15,
                        height: 15,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF01090B),
                                  shape: OvalBorder(
                                    side: BorderSide(width: 0.50, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 4.50,
                              top: 3,
                              child: Container(
                                width: 6,
                                height: 8,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Abdur Salam',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  height: 0.07,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}