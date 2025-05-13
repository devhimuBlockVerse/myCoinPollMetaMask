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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return  Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:  Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF01090B),
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
                          SizedBox(height: screenHeight * 0.01),

                          Center(child: _profileHeaderSection()),

                          SizedBox(height: screenHeight * 0.03),

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




  Widget _profileHeaderSection(){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Scale factors (tweak if needed)
    double scale = screenWidth / 375;
    return Column(
       children: [
        Container(
          width: screenWidth * 0.5,
          padding: EdgeInsets.symmetric(vertical: 10 * scale),
          child: Column(

            children: [
              // Show User Profile Image
              Container(
                width: screenWidth * 0.26,
                height: screenWidth * 0.26,
                decoration: ShapeDecoration(
                  image: const DecorationImage(
                    image: NetworkImage("https://picsum.photos/90/90"), // Show User Profile
                    fit: BoxFit.fill,
                  ),
                  shape: OvalBorder(
                    side: BorderSide(width: 1 * scale, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 10 * scale),

              // Name
              Text(
                'Abdur Salam',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20 * scale,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),



            ],
          ),
        ),
      ],
    );
  }



}




