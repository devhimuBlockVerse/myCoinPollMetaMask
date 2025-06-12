import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/login/sign_in.dart';

import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/CustomRadioSelection.dart';
import '../../../../framework/components/ListingFields.dart';

class ApplyForListingScreen extends StatefulWidget {
  const ApplyForListingScreen({super.key});

  @override
  _ApplyForListingScreenState createState() => _ApplyForListingScreenState();
}

class _ApplyForListingScreenState extends State<ApplyForListingScreen> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDetailsController = TextEditingController();
  TextEditingController projectStatusController = TextEditingController();

 TextEditingController backersAndAdvisorsController = TextEditingController();
 TextEditingController smartContractAuditController = TextEditingController();
 TextEditingController litepaperLinkController = TextEditingController();
 TextEditingController websiteLinkController = TextEditingController();
 TextEditingController mediumLinkController = TextEditingController();
 TextEditingController githubLinkController = TextEditingController();
 TextEditingController twitterLinkController = TextEditingController();
 TextEditingController telegramLinkController = TextEditingController();
 TextEditingController additionalDetailsController = TextEditingController();



  String selectedOptionPlatform = 'Solana';
  String selectedOptionTeam = 'Solana';

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
          decoration: const BoxDecoration(
            // color: const Color(0xFF0B0A1E),
            color: Color(0xFF01090B),
            image: DecorationImage(
              // image: AssetImage('assets/icons/gradientBgImage.png'),
              // fit: BoxFit.contain,
              image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              // SizedBox(height: screenHeight * 0.01),

              ///Back Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/back_button.svg',
                    color: Colors.white,
                      width: screenWidth * 0.04,
                      height: screenWidth * 0.04
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
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                             _headerSection(context),

                            SizedBox(height: screenHeight * 0.02),

                            /// Login Button Section

                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SignIn()),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.06),


                            /// Listing  Section Form

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0XFF040C16),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xff000000),
                                    width: 1,

                                  )
                                ),
                               
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Container(
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
                                               // width: screenWidth* 0.88,
                                               expandable: false,
                                               keyboard: TextInputType.name,
                                            ),
                                
                                             SizedBox(height: screenHeight * 0.02),
                                
                                             ListingField(
                                              controller: emailAddressController,
                                               labelText: 'Email Address',
                                               height: screenHeight * 0.05,
                                               // width: screenWidth* 0.88,
                                               expandable: false,
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
                                               // width: screenWidth* 0.88,
                                               expandable: false,
                                               keyboard: TextInputType.name,
                                             ),
                                
                                             SizedBox(height: screenHeight * 0.02),
                                
                                             ListingField(
                                               controller: projectDetailsController,
                                               labelText: 'Project Details',
                                               height:  screenHeight * 0.2,
                                               expandable: false,
                                               keyboard: TextInputType.multiline,
                                             ),
                                
                                             SizedBox(height: screenHeight * 0.02),
                                
                                             ListingField(
                                               controller: projectStatusController,
                                               labelText: 'Project Status',
                                               height: screenHeight * 0.1,
                                               // width: screenWidth* 0.88,
                                               expandable: false,
                                               keyboard: TextInputType.multiline,
                                             ),
                                
                                
                                             SizedBox(height: screenHeight * 0.05),
                                
                                             ///Blockchain/Platform Radio Buttons
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
                                             SizedBox(height: screenHeight * 0.02),
                                             CustomRadioOption(
                                               label: 'Blockchain/Platform',
                                               value: 'Blockchain/Platform',
                                               selectedValue: selectedOptionPlatform,
                                               onTap: () {
                                                 setState(() {
                                                   selectedOptionPlatform = 'Blockchain/Platform';
                                                 });
                                               },
                                             ),
                                             SizedBox(height: screenHeight * 0.02),
                                
                                             CustomRadioOption(
                                               label: 'Solana',
                                               value: 'Solana',
                                               selectedValue: selectedOptionPlatform,
                                               onTap: () {
                                                 setState(() {
                                                   selectedOptionPlatform = 'Solana';
                                                 });
                                               },
                                             ),
                                             SizedBox(height: screenHeight * 0.02),
                                
                                             CustomRadioOption(
                                               label: 'Ethereum',
                                               value: 'Ethereum',
                                               selectedValue: selectedOptionPlatform,
                                               onTap: () {
                                                 setState(() {
                                                   selectedOptionPlatform = 'Ethereum';
                                                 });
                                               },
                                             ),
                                             SizedBox(height: screenHeight * 0.02),
                                             CustomRadioOption(
                                               label: 'Polygon (Matic)',
                                               value: 'Polygon (Matic)',
                                               selectedValue: selectedOptionPlatform,
                                               onTap: () {
                                                 setState(() {
                                                   selectedOptionPlatform = 'Polygon (Matic)';
                                                 });
                                               },
                                             ),
                                             SizedBox(height: screenHeight * 0.02),
                                              CustomRadioOption(
                                               label: 'Other',
                                               value: 'Other',
                                               selectedValue: selectedOptionPlatform,
                                               onTap: () {
                                                 setState(() {
                                                   selectedOptionPlatform = 'Other';
                                                 });
                                               },
                                             ),
                                             SizedBox(height: screenHeight * 0.05),
                                
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
                                
                                             SizedBox(height: screenHeight * 0.02),
                                             CustomRadioOption(
                                               label: 'Anon',
                                               value: 'Anon',
                                               selectedValue: selectedOptionTeam,
                                               onTap: () {
                                                 setState(() {
                                                   selectedOptionTeam = 'Anon';
                                                 });
                                               },
                                             ),
                                             SizedBox(height: screenHeight * 0.02),
                                             CustomRadioOption(
                                               label: 'Fully Public',
                                               value: 'Fully Public',
                                               selectedValue: selectedOptionTeam,
                                               onTap: () {
                                                 setState(() {
                                                   selectedOptionTeam = 'Fully Public';
                                                 });
                                               },
                                             ),
                                             SizedBox(height: screenHeight * 0.02),
                                             CustomRadioOption(
                                               label: 'Mixed',
                                               value: 'Mixed',
                                               selectedValue: selectedOptionTeam,
                                               onTap: () {
                                                 setState(() {
                                                   selectedOptionTeam = 'Mixed';
                                                 });
                                               },
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
                                               controller: backersAndAdvisorsController ,
                                               labelText: 'Backers & Advisors',
                                               height: screenHeight * 0.05,
                                               expandable: false,
                                               keyboard: TextInputType.name,
                                             ),
                                
                                             SizedBox(height: screenHeight * 0.02),
                                
                                             ListingField(
                                               controller: smartContractAuditController ,
                                               labelText: 'Smart Contract Audit (with link if any)',
                                               height: screenHeight * 0.05,
                                               expandable: false,
                                               keyboard: TextInputType.name,
                                             ),
                                
                                             SizedBox(height: screenHeight * 0.02),
                                
                                             ListingField(
                                               controller: litepaperLinkController ,
                                               labelText: 'Litepaper/Whitepaper Link',
                                               height: screenHeight * 0.05,
                                               expandable: false,
                                               keyboard: TextInputType.name,
                                             ),
                                             SizedBox(height: screenHeight * 0.02),
                                
                                             ListingField(
                                               controller: websiteLinkController,
                                               labelText: 'Website Link (if any)',
                                               height: screenHeight * 0.05,
                                               expandable: false,
                                               keyboard: TextInputType.name,
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
                                               controller: mediumLinkController ,
                                               labelText: 'Medium Link:',
                                               height: screenHeight * 0.05,
                                               expandable: false,
                                               keyboard: TextInputType.name,
                                             ),
                                             SizedBox(height: screenHeight * 0.02),
                                             ListingField(
                                               controller: githubLinkController ,
                                               labelText: 'Github Link:',
                                               height: screenHeight * 0.05,
                                               expandable: false,
                                               keyboard: TextInputType.name,
                                             ),
                                             SizedBox(height: screenHeight * 0.02),
                                             ListingField(
                                               controller: twitterLinkController ,
                                               labelText: 'Twitter Link:',
                                               height: screenHeight * 0.05,
                                               expandable: false,
                                               keyboard: TextInputType.name,
                                             ),
                                             SizedBox(height: screenHeight * 0.02),
                                             ListingField(
                                               controller: telegramLinkController ,
                                               labelText: 'Telegram Link:',
                                               height: screenHeight * 0.05,
                                               expandable: false,
                                               keyboard: TextInputType.name,
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
                                               controller: additionalDetailsController,
                                               labelText: 'Write in details',
                                               height: screenHeight * 0.05,

                                               expandable: false,
                                               keyboard: TextInputType.name,
                                             ),
                                
                                
                                
                                
                                
                                           ],
                                        ),
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

                                            setState(() {
                                              // Clear all text fields
                                              fullNameController.clear();
                                              emailAddressController.clear();
                                              projectNameController.clear();
                                              projectDetailsController.clear();
                                              projectStatusController.clear();
                                              backersAndAdvisorsController.clear();
                                              smartContractAuditController.clear();
                                              litepaperLinkController.clear();
                                              websiteLinkController.clear();
                                              mediumLinkController.clear();
                                              githubLinkController.clear();
                                              twitterLinkController.clear();
                                              telegramLinkController.clear();
                                              additionalDetailsController.clear();

                                              // Reset all selected options to their initial values
                                              selectedOptionPlatform = 'Solana';
                                              selectedOptionTeam = 'Solana';
                                            });

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
                                              color: const Color(0XFF1CD494),
                                              decorationColor: const Color(0XFF1CD494),
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


                          ],
                        ),
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
                    'MyCoinPoll IDO Launch Application',
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
                // 'assets/icons/applyForLisitngImg.png',
                'assets/icons/applyForLisitngImg1.png',
                height: screenHeight * 0.9,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }


}



