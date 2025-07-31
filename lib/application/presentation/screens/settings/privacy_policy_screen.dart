import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../framework/utils/dynamicFontSize.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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

              image: AssetImage('assets/images/solidBackGround.png'),
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
                        'Privacy Policy',
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
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            AutoSizeText(
                              "A Privacy policy explains how your personal information is collected, used, and protected. It ensures transparency, outlining your rights, data-sharing practices, and the security measures taken to safeguard your data",
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
                            const Divider(
                              color: Colors.white,
                              thickness: 0.9,
                              height: 20,
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Overview",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: const Color(0xffFEFEFE),
                                    fontWeight: FontWeight.w600,
                                    fontSize: getResponsiveFontSize(context, 17),
                                    height: 1.3,
                                    letterSpacing: 0.1,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white60
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            AutoSizeText(
                              "MyCoinpoll (referred to as we or us) is committed to safeguarding the privacy and security of your personal information. This Privacy Policy outlines how we collect, use, and protect your data when you visit our website and use our services. By accessing or using MyCoinpoll, you consent to the terms outlined in this Privacy Policy",
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

                            const Divider(
                              color: Colors.white,
                              thickness: 0.9,
                              height: 20,
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "I. Collection of Personal Information",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: const Color(0xffFEFEFE),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getResponsiveFontSize(context, 17),
                                  height: 1.3,
                                  letterSpacing: 0.1,
                                ),),
                            ),
                            SizedBox(height: screenHeight * 0.02),


                            AutoSizeText(
                              '''• Information Provided by You:
We collect personal data, such as name, email address, and phone number, only when necessary and with your consent. This information is used for loan mediation purposes and to enhance our services. We do not disclose this data without your permission.

• Cookies:
MyCoinpoll utilizes cookies to improve your browsing experience. These text files help store login data and track your visits to our platform. You can turn off cookies in your browser settings, although it may impact certain functionalities.

• Contact and Correspondence:
When you contact us via email, we securely store the provided information to process your inquiries and subsequent correspondence.

• Comments and Contributions:
User comments on our blog and loan listings may require storing IP addresses to prevent illegal content. This is done to ensure the safety and integrity of our platform.

• Blog Subscriptions:
If you subscribe to comments on our blog, we collect your email address for communication purposes. Your subscription data, including your IP address and date, is stored to prevent misuse and can be revoked anytime.
                              ''',
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
                                "II. Website Interaction and Data Collection",
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
                              '''• Access Data/Server Log Files:
Server log files capture your visit information, including IP address, requested files, date and time, data transmitted, browser type, referrer URL, and more. This data is used for statistical analysis and aids in resolving any illegal use of our services.

• Google Analytics:
MyCoinpoll employs Google Analytics to analyze website usage. Information generated by cookies, including IP addresses, is transmitted and stored by Google servers. Google Analytics helps us enhance user experience and improve our services.

• Liability for Links:
Our website may contain links to external providers. While we checked these links at the time of placement, the content behind them was not integrated into our offer. Any changes in linked content are addressed promptly upon identification.''',
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
                                "III. Right to Information",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: const Color(0xffFEFEFE),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getResponsiveFontSize(context, 17),
                                  height: 1.3,
                                  letterSpacing: 0.1,
                                ),),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            AutoSizeText(
                              "• You have the right to request information about the personal data we hold about you, free of charge, to a reasonable extent.",
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
                                "IV. Changes, Corrections, Updates, and Revocation",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: const Color(0xffFEFEFE),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getResponsiveFontSize(context, 17),
                                  height: 1.3,
                                  letterSpacing: 0.1,
                                ),),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            AutoSizeText(
                              '''• Review and Update:
You have the right to review and update your data. If assistance is needed, our support team is ready to help.

• Lock and Delete:
You can request the locking or deletion of your data if it is not subject to statutory retention obligations. Data is also deleted if you revoke your permission or if storage is no longer legally possible.

• Revocation:
You can withdraw your consent for future data collection, processing, and utilization by emailing us.''',
                               style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: getResponsiveFontSize(context, 13),
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
                                "V. Security Measures",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: const Color(0xffFEFEFE),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getResponsiveFontSize(context, 17),
                                  height: 1.3,
                                  letterSpacing: 0.1,
                                ),),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            AutoSizeText(
                              '''• MyCoinpoll employs industry-standard security measures to protect your personal information from unauthorized access, disclosure, alteration, and destruction. We regularly review and update our security protocols to ensure the ongoing integrity of your data.''',
                               style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: getResponsiveFontSize(context, 13),
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
                                "VI. Updates to Privacy Policy",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: const Color(0xffFEFEFE),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getResponsiveFontSize(context, 17),
                                  height: 1.3,
                                  letterSpacing: 0.1,
                                ),),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            AutoSizeText(
                              '''• We may update this Privacy Policy to reflect changes in our practices or legal requirements. It is recommended to review this policy periodically for any updates. By continuing to use MyCoinpoll after modifications, you acknowledge and agree to the revised terms.''',
                               style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: getResponsiveFontSize(context, 13),
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
                                "VII. Contact Information",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: const Color(0xffFEFEFE),
                                  fontWeight: FontWeight.w600,
                                  fontSize: getResponsiveFontSize(context, 17),
                                  height: 1.3,
                                  letterSpacing: 0.1,
                                ),),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            AutoSizeText(
                              '''• For any inquiries, concerns, or requests related to your privacy, please get in touch with us at support@mycoinpoll.com.

• By using MyCoinpoll, you acknowledge and agree to the terms outlined in this Privacy Policy. Last updated: 6th-January-2024.''',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: getResponsiveFontSize(context, 13),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

}
