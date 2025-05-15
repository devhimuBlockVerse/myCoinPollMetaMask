import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {



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
                        'Settings',
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
                          SizedBox(height: screenHeight * 0.05),



                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),

                            child: Column(
                              children: [
                                CustomLogoutButton(
                                  icon: 'assets/icons/languageImg.svg',
                                  text: 'Language',
                                  onPressed: (){},
                                ),

                                CustomLogoutButton(
                                  icon: 'assets/icons/rateImg.svg',
                                  text: 'Rate App',
                                  onPressed: (){},
                                ),
                                CustomLogoutButton(
                                  icon: 'assets/icons/shareImg.svg',
                                  text: 'Share App',
                                  onPressed: (){},
                                ),
                                CustomLogoutButton(
                                  icon: 'assets/icons/privecyImg.svg',
                                  text: 'Privacy Policy',
                                  onPressed: (){},
                                ),
                                CustomLogoutButton(
                                  icon: 'assets/icons/termsImg.svg',
                                  text: 'Terms and Conditions',
                                  onPressed: (){},
                                ),
                                CustomLogoutButton(
                                  icon: 'assets/icons/contactImg.svg',
                                  text: 'Contact',
                                  onPressed: (){},
                                ),

                                CustomLogoutButton(
                                  icon: 'assets/icons/feedbackImg.svg',
                                  text: 'Feedback',
                                  onPressed: (){},
                                ),

                                CustomLogoutButton(
                                  icon: 'assets/icons/logoutImg.svg',
                                  text: 'Logout',
                                  onPressed: (){},
                                ),


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

class CustomLogoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String icon;
   final Color foregroundColor;
  final double borderRadius;

  const CustomLogoutButton({
    Key? key,
    required this.onPressed,
    required this.text ,
    required this.icon , // Default icon
     this.foregroundColor = Colors.white, // White text and icon
    this.borderRadius = 10.0, // Default border radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        image: DecorationImage(

          image: AssetImage('assets/icons/settingActionBg.png'),
          fit: BoxFit.fill,
          alignment: Alignment.topRight,
        ),

      ),
      child: InkWell(
        onTap: onPressed,
         child: Padding(
           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
             mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                icon,
                color: foregroundColor,
                height: 24,
                width: 24,
              ),
               SizedBox(width: 12,),
               Text(
                text,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 18, // Adjust font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}