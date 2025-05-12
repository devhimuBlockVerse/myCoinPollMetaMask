import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                           Container(
                             width: screenWidth,
                             decoration: BoxDecoration(
                               color: const Color(0xFF01090B),
                               image: DecorationImage(
                                 // image: AssetImage('assets/icons/gradientBgImage.png'),
                                 // fit: BoxFit.contain,
                                 image: AssetImage('assets/icons/profileFrameBg.png'),
                                 fit: BoxFit.contain,
                                 alignment: Alignment.topRight,
                               ),
                             ),

                             child: Column(
                               children: [
                                 SizedBox(height: screenHeight * 0.02),
                                 SizedBox(height: screenHeight * 0.02),
                                 SizedBox(height: screenHeight * 0.02),
                                 SizedBox(height: screenHeight * 0.02),

                                 ProfileOptionContainer(
                                  labelText: 'Tax Statements',
                                  leadingIconPath: 'assets/icons/taxStatement.svg',
                                  trailingIconPath: 'assets/icons/rightArrow.svg',
                                  onTrailingIconTap: () {
                                    print("Trailing icon tapped");
                                  },
                                 ),
                                 ProfileOptionContainer(
                                  labelText: 'Tax Statements',
                                  leadingIconPath: 'assets/icons/taxStatement.svg',
                                  trailingIconPath: 'assets/icons/rightArrow.svg',
                                  onTrailingIconTap: () {
                                    print("Trailing icon tapped");
                                  },
                                 ),
                                 ProfileOptionContainer(
                                  labelText: 'Tax Statements',
                                  leadingIconPath: 'assets/icons/taxStatement.svg',
                                  trailingIconPath: 'assets/icons/rightArrow.svg',
                                  onTrailingIconTap: () {
                                    print("Trailing icon tapped");
                                  },
                                 ),
                               ],
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



class ProfileOptionContainer extends StatelessWidget {
  final String labelText;
  final String leadingIconPath;
  final String trailingIconPath;
  final VoidCallback? onTrailingIconTap;

  const ProfileOptionContainer({
    super.key,
    required this.labelText,
    required this.leadingIconPath,
    required this.trailingIconPath,
    this.onTrailingIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375;

    return GestureDetector(
      onTap: onTrailingIconTap,
      child: Container(
        width: screenWidth * 0.82,
        height: 42 * scaleFactor,
        padding: EdgeInsets.symmetric(
          horizontal: 20 * scaleFactor,
        ),
        decoration: ShapeDecoration(
          // color: const Color(0xFF12161D),
          color: const Color(0xFF12161D),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFF141317)),
            borderRadius: BorderRadius.circular(8 * scaleFactor),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Leading Icon
            Center(
              child: SvgPicture.asset(
                leadingIconPath,
                width: 18 * scaleFactor,
                height: 18 * scaleFactor,
                color: Colors.white.withOpacity(0.8),
              ),
            ),

            SizedBox(width: 12 * scaleFactor),

            /// Label Text
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  labelText,
                  style: TextStyle(
                    color: const Color(0xffFFF5ED).withOpacity(0.8),
                    fontSize: 14 * scaleFactor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.2, // Slightly lower for vertical centering
                  ),
                ),
              ),
            ),

            /// Trailing Icon
            Center(
              child: SvgPicture.asset(
                trailingIconPath,
                width: 10 * scaleFactor,
                height: 10 * scaleFactor,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
