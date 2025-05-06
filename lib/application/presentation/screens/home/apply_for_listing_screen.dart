import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../../framework/components/BlockButton.dart';

class ApplyForListingScreen extends StatefulWidget {
  @override
  _ApplyForListingScreenState createState() => _ApplyForListingScreenState();
}

class _ApplyForListingScreenState extends State<ApplyForListingScreen> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDetailsController = TextEditingController();
  TextEditingController projectStatusController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,

      backgroundColor: Colors.transparent,
       body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF0B0A1E),
            image: DecorationImage(
              image: AssetImage('assets/icons/gradientBgImage.png'),
              fit: BoxFit.contain,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              ///Back Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/back_button.svg',
                    color: Colors.white,
                    width: 15,
                    height: 15,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              /// Main Scrollable Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.01,
                    right: screenWidth * 0.01,
                    bottom: screenHeight * 0.02,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                         _headerSection(context),

                        SizedBox(height: screenHeight * 0.02),

                        /// Login Button Section

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0x232c2e41),
                           ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.012,
                              left: screenWidth * 0.04,
                              right: screenWidth * 0.04,
                              bottom: screenHeight * 0.012,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                // Smaller Image
                                Image.asset(
                                  'assets/icons/warningImg.png',
                                  width: screenWidth * 0.07,
                                  height: screenWidth * 0.07,
                                  fit: BoxFit.contain,
                                ),

                                SizedBox(width: screenWidth * 0.02),

                                 Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: screenWidth * 0.027,
                                        height: 1.23,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Connect your '),
                                        WidgetSpan(
                                          alignment: PlaceholderAlignment.baseline,
                                          baseline: TextBaseline.alphabetic,
                                          child: ShaderMask(
                                            shaderCallback: (bounds) => const LinearGradient(
                                              colors: [Color(0xFF2680EF), Color(0xFF1CD494)],
                                            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                            blendMode: BlendMode.srcIn,
                                            child: Text(
                                              'Web3 wallet',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                fontSize: screenWidth * 0.027,
                                                height: 1.23,
                                                color: Colors.white, // Required by ShaderMask
                                              ),
                                            ),
                                          ),
                                        ),
                                        const TextSpan(text: ' to apply and verify.'),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: screenWidth * 0.02),

                                /// Login Now Button
                                BlockButton(
                                  height: screenHeight * 0.038,
                                  width: screenWidth * 0.28,
                                  label: 'Login Now',
                                  textStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth * 0.028,
                                    height: 0.8,
                                    color: Colors.white,
                                  ),
                                  gradientColors: const [
                                    Color(0xFF2680EF),
                                    Color(0xFF1CD494),
                                  ],
                                  onTap: () {
                                    // Action
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.06),


                        /// Listing  Section Form

                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisSize: MainAxisSize.min,
                             children: [

                               /// Personal Information

                               Text(
                                'Personal Information:',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: baseSize * 0.045,
                                  height: 1.2,
                                  color: Colors.white,
                                ),
                              ),

                               SizedBox(height: screenHeight * 0.02),

                               ListingField(
                                controller: fullNameController,
                                 labelText: 'Full Name',
                                 height: screenHeight * 0.05,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.name,
                              ),

                               SizedBox(height: screenHeight * 0.02),

                               ListingField(
                                controller: emailAddressController,
                                 labelText: 'Email Address',
                                 height: screenHeight * 0.05,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.emailAddress,
                              ),

                               SizedBox(height: screenHeight * 0.05),

                               /// Project Information
                               Text(
                                 'Project Information:',
                                 textAlign: TextAlign.start,
                                 style: TextStyle(
                                   fontFamily: 'Poppins',
                                   fontWeight: FontWeight.w500,
                                   fontSize: baseSize * 0.045,
                                   height: 1.2,
                                   color: Colors.white,
                                 ),
                               ),

                               SizedBox(height: screenHeight * 0.02),

                               ListingField(
                                 controller: projectNameController,
                                 labelText: 'Project Name',
                                 height: screenHeight * 0.05,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.name,
                               ),

                               SizedBox(height: screenHeight * 0.02),

                               ListingField(
                                 controller: projectDetailsController,
                                 labelText: 'Project Details',
                                 height: screenHeight * 0.09,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.multiline,
                               ),

                               SizedBox(height: screenHeight * 0.02),

                               ListingField(
                                 controller: projectStatusController,
                                 labelText: 'Project Status',
                                 height: screenHeight * 0.12,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.multiline,
                               ),


                               SizedBox(height: screenHeight * 0.05),

                               ///Blockchain/Platform
                               Text(
                                 'Blockchain/Platform:',
                                 textAlign: TextAlign.start,
                                 style: TextStyle(
                                   fontFamily: 'Poppins',
                                   fontWeight: FontWeight.w500,
                                   fontSize: baseSize * 0.045,
                                   height: 1.2,
                                   color: Colors.white,
                                 ),
                               ),
                               SizedBox(height: screenHeight * 0.05),
                               Frame1321314803(),


                               ///Is your team Anon or Public?
                               Text(
                                 'Is your team Anon or Public?',
                                 textAlign: TextAlign.start,
                                 style: TextStyle(
                                   fontFamily: 'Poppins',
                                   fontWeight: FontWeight.w500,
                                   fontSize: baseSize * 0.045,
                                   height: 1.2,
                                   color: Colors.white,
                                 ),
                               ),


                               SizedBox(height: screenHeight * 0.05),

                               Text(
                                 'Additional Project Details:',
                                 textAlign: TextAlign.start,
                                 style: TextStyle(
                                   fontFamily: 'Poppins',
                                   fontWeight: FontWeight.w500,
                                   fontSize: baseSize * 0.045,
                                   height: 1.2,
                                   color: Colors.white,
                                 ),
                               ),
                               SizedBox(height: screenHeight * 0.02),

                               ListingField(
                                 // controller: ,
                                 labelText: 'Backers & Advisors',
                                 height: screenHeight * 0.12,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.multiline,
                               ),

                               SizedBox(height: screenHeight * 0.02),

                               ListingField(
                                 // controller: ,
                                 labelText: 'Smart Contract Audit (with link if any)',
                                 height: screenHeight * 0.12,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.multiline,
                               ),

                               SizedBox(height: screenHeight * 0.02),

                               ListingField(
                                 // controller: ,
                                 labelText: 'Litepaper/Whitepaper Link',
                                 height: screenHeight * 0.12,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.multiline,
                               ),
                               SizedBox(height: screenHeight * 0.02),

                               ListingField(
                                 // controller: ,
                                 labelText: 'Website Link (if any)',
                                 height: screenHeight * 0.12,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.multiline,
                               ),

                               SizedBox(height: screenHeight * 0.05),

                               ///Social Links:
                               Text(
                                 'Social Links:',
                                 textAlign: TextAlign.start,
                                 style: TextStyle(
                                   fontFamily: 'Poppins',
                                   fontWeight: FontWeight.w500,
                                   fontSize: baseSize * 0.045,
                                   height: 1.2,
                                   color: Colors.white,
                                 ),
                               ),

                               SizedBox(height: screenHeight * 0.02),

                               ListingField(
                                 // controller: ,
                                 labelText: 'Medium Link:',
                                 height: screenHeight * 0.12,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.multiline,
                               ),
                               SizedBox(height: screenHeight * 0.02),
                               ListingField(
                                 // controller: ,
                                 labelText: 'Github Link:',
                                 height: screenHeight * 0.12,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.multiline,
                               ),
                               SizedBox(height: screenHeight * 0.02),
                               ListingField(
                                 // controller: ,
                                 labelText: 'Twitter Link:',
                                 height: screenHeight * 0.12,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.multiline,
                               ),
                               SizedBox(height: screenHeight * 0.02),
                               ListingField(
                                 // controller: ,
                                 labelText: 'Telegram Link:',
                                 height: screenHeight * 0.12,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.multiline,
                               ),
                               SizedBox(height: screenHeight * 0.05),

                               ///Additional Comments:
                               Text(
                                 'Additional Comments:',
                                 textAlign: TextAlign.start,
                                 style: TextStyle(
                                   fontFamily: 'Poppins',
                                   fontWeight: FontWeight.w500,
                                   fontSize: baseSize * 0.045,
                                   height: 1.2,
                                   color: Colors.white,
                                 ),
                               ),
                               SizedBox(height: screenHeight * 0.02),
                               ListingField(
                                 // controller: ,
                                 labelText: 'Write in details',
                                 height: screenHeight * 0.12,
                                 width: screenWidth* 0.88,
                                 expandable: true,
                                 keyboard: TextInputType.multiline,
                               ),

                             ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),


                        /// Submit & Clear Button Section
                        Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {

                               },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child:  Text(
                                'Clear form',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600, // SemiBold
                                  fontSize: MediaQuery.of(context).size.height * 0.015,
                                  height: 0.6,
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF3890FF),
                                  decorationColor: Color(0xFF3890FF),
                                  decorationThickness: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03,),

                            BlockButton(
                              height: screenHeight * 0.039,
                              width: screenWidth * 0.32,
                              label: 'Submit For Apply',
                              textStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.028,
                                height: 0.8,
                                color: Colors.white,
                              ),
                              gradientColors: const [
                                Color(0xFF2680EF),
                                Color(0xFF1CD494),
                              ],
                              onTap: () {
                                // Action
                              },
                            ),

                          ],
                        ),

                        SizedBox(height: screenHeight * 0.02),


                      ],
                    ),
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
                  Text(
                    'MyCoinPoll IDO Launch \nApplication',
                    style: TextStyle(
                      color: const Color(0xFFFFF5ED),
                      fontFamily: 'Poppins',
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Flexible(
                    child: Text(
                      'Apply to launch your project—our team ensures thorough review and investor protection',
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
              flex: 1,
              child: Image.asset(
                'assets/icons/applyForLisitngImg.png',
                height: screenHeight * 0.09,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }


}


class Frame1321314803 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 62,
          height: 10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.50,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: ShapeDecoration(
                    shape: OvalBorder(
                      side: BorderSide(width: 1.50, color: Color(0xFF1CD494)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Solana',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
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

class ListingField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final double? height;
  final double? width;
  final bool expandable;
  final TextInputType? keyboard;

  const ListingField({
    Key? key,
    this.controller,
    this.labelText,
    this.height,
    this.width,
    this.expandable = false, this.keyboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: width ?? screenWidth * 0.85,
      height: expandable ? null : height ?? screenHeight * 0.06,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.045,
        vertical: screenHeight * 0.012,
      ),
      decoration: ShapeDecoration(
        color: const Color(0xFF12161D),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF141317)),
          borderRadius: BorderRadius.circular(3),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xFFC7E0FF),
            blurRadius: 0,
            offset: Offset(0.10, 0.50),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        keyboardType:keyboard,
        controller: controller,
        maxLines: expandable ? null : 1,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: screenHeight * 0.015,
          // height: 0.8,
          height: 1.2,
          color: Colors.white.withOpacity(0.4),
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: labelText,
          hintStyle: TextStyle(
            color: Colors.white70,
            fontSize: screenHeight * 0.015,
            fontFamily: 'Poppins',

          ),
        ),
      ),
    );
  }
}
