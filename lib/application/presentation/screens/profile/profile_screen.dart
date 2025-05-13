import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../framework/components/profileOptionCompoent.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                image: AssetImage('assets/icons/starGradientBg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topRight,
              ),
            ),


            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 SizedBox(height: screenHeight * 0.02),
                 Align(
                   alignment: Alignment.topCenter,
                   child:  Text(
                     'Profile',
                     style: TextStyle(
                       fontFamily: 'Poppins',
                       color: Colors.white,
                       fontWeight: FontWeight.w600,
                       // fontSize: 20
                       fontSize: screenWidth * 0.05,
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ),

                 Expanded(
                   child: Padding(
                     padding: EdgeInsets.symmetric(
                       horizontal: screenWidth * 0.04,
                       vertical: screenHeight * 0.02,
                     ),
                     child: SingleChildScrollView(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           SizedBox(height: screenHeight * 0.02),

                           _profileHeaderSection(),

                           SizedBox(height: screenHeight * 0.03),

                           Container(
                             // width: screenWidth,
                             // height: screenHeight,
                             decoration: BoxDecoration(
                               color: const Color(0xFF01090B),
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
                                   ProfileOptionContainer(
                                    labelText: 'Personal Information',
                                    leadingIconPath: 'assets/icons/profile.svg',
                                    trailingIconPath: 'assets/icons/rightArrow.svg',
                                    onTrailingIconTap: () {
                                      print("Trailing icon tapped");
                                    },
                                   ),
                                   SizedBox(height: screenHeight * 0.02),

                                   ProfileOptionContainer(
                                    labelText: 'Trade Confirmation',
                                    leadingIconPath: 'assets/icons/tared.svg',
                                    trailingIconPath: 'assets/icons/rightArrow.svg',
                                    onTrailingIconTap: () {
                                      print("Trailing icon tapped");
                                    },
                                   ),
                                   SizedBox(height: screenHeight * 0.02),

                                   ProfileOptionContainer(
                                    labelText: 'Tax Statements',
                                    leadingIconPath: 'assets/icons/taxStatement.svg',
                                    trailingIconPath: 'assets/icons/rightArrow.svg',
                                    onTrailingIconTap: () {
                                      print("Trailing icon tapped");
                                    },
                                   ),
                                   SizedBox(height: screenHeight * 0.02),

                                   ProfileOptionContainer(
                                     labelText: 'Notification Settings',
                                     leadingIconPath: 'assets/icons/notify.svg',
                                     trailingIconPath: 'assets/icons/rightArrow.svg',
                                     onTrailingIconTap: () {
                                       print("Trailing icon tapped");
                                     },
                                   ),
                                   SizedBox(height: screenHeight * 0.02),

                                   ProfileOptionContainer(
                                     labelText: 'Settings',
                                     leadingIconPath: 'assets/icons/settings.svg',
                                     trailingIconPath: 'assets/icons/rightArrow.svg',
                                     onTrailingIconTap: () {
                                       print("Trailing icon tapped");
                                     },
                                   ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
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

              SizedBox(height: 10 * scale),

              // Membership Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10 * scale,
                  vertical: 6 * scale,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF7F9B7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5 * scale),
                  ),
                ),
                child: Text(
                  'Premium Member',
                  style: TextStyle(
                    color: Color(0xFF18181D),
                    fontSize: 12 * scale,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.3,

                  ),
                ),
              ),

              SizedBox(height: 5 * scale),

              // Upgrade Plan Button
              GestureDetector(
                onTap: () {
                  /// Handle upgrade tap
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10 * scale,
                    vertical: 4 * scale,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Upgrade your plan',
                        style: TextStyle(
                          color: Color(0xFFF7F9B7),
                          fontSize: 10 * scale,
                          fontFamily: 'Poppins',
                          letterSpacing: -0.3,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(width: 6 * scale),
                      Icon(
                        Icons.arrow_forward,
                        size: 12 * scale,
                        color: Color(0xFFF7F9B7),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}






