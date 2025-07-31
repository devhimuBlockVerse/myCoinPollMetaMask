import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../framework/utils/dynamicFontSize.dart';

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
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,


                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              "Terms and Conditions outline the rules, responsibilities, and legal protections between users and a service provider, ensuring clarity, transparency, and fair use while protecting both parties from disputes or misunderstandings.",
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
                                "Terms of Service",
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
                            SizedBox(height: screenHeight * 0.02),


                            AutoSizeText(
                              "Last Updated: [January, 2024]\n\n"
                                  "Welcome to MyCoinPoll! Before using our services, please read these Terms of Service (Agreement) carefully. By accessing or using MyCoinPoll's website and services, you agree to be bound by this Agreement",
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
                                "1. General Conditions of Use",
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
                              '''1.1 By creating an account on MyCoinPoll, you agree to comply with and be legally bound by this Agreement. If you disagree with any terms, kindly refrain from accessing or using MyCoinPoll's services.
                              
1.2 MyCoinPoll reserves the right to amend this Agreement by posting revisions on the website or emailing users. Continued use of our services after such changes constitutes acceptance of the revised terms.

1.3 To use MyCoinPoll, you must be at least 18 or meet the applicable age of majority in your jurisdiction. By using our services, you confirm that you meet the age requirement.

1.4 MyCoinPoll provides its services "as is" without warranties. We do not guarantee the service's quality, fitness for purpose, completeness, or accuracy.

1.5 All MyCoinPoll trademarks and site content are MyCoinPoll's exclusive property. Users may not use trademarks or site content without prior written consent.

1.6 Mycoinpoll reserves all the rights to make changes, modify or cancel any offer without any further notice.''',
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
                                "2. Authority/Terms of Service",
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
                              '''2.1 By accessing and using MyCoinpoll's services on https://mycoinpoll.com, you agree to adhere to the rules outlined on our website. MyCoinpoll retains full authority over the service's issuance, maintenance, and termination. Our management's decisions regarding service use and dispute resolution are final, with no opportunity for review or appeal.''',
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
                                "3. Your Representations and Warranties",
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
                              ''' 3.1 Acknowledgment of Risk: You recognize the risk of potential cryptocurrency or value loss when utilizing our service, absolving ChainGPT Pad of any responsibility for such losses.

3.2 Sole Responsibility: Your use of the service is voluntary, and you bear full responsibility for any consequences arising from it. ChainGPT Pad holds no liability in this regard.

3.3 Tax Obligations: You are solely responsible for any applicable taxes related to cryptocurrency trades or transactions through our service.

3.4 Market Forces and Technology: You understand and accept that cryptocurrency-related projects involve risks beyond our control, including market changes, technology developments, and regulatory impacts, relieving us of responsibility in such circumstances.

3.5 Legal Compliance: You confirm that you are of legal age, accessing the service from a permissible jurisdiction, and complying with all applicable laws. You are responsible for all activities under your User Account.
                              ''',
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

                             Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "4. Prohibited Uses & Termination",
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
                              ''' 4.1 Illicit Activities: You agree not to engage in illegal, unauthorized, or improper activities, including infringing proprietary rights, creating multiple accounts for collusion, transmitting harmful code, or making unauthorized copies.

4.2 Termination Rights: MyCoinpoll reserves the right to modify or discontinue services and suspend or terminate user access for certain circumstances without notice. We hold no liability for such actions except as expressly stated herein.
                              ''',
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
                                "5. Know Your Customer (KYC) and Anti-Money Laundering (AML) Policy",
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
                             "MyCoinpoll operates as a decentralized token sales, swaps, and exchange platform. While MyCoinpoll, a software development company, does not enforce KYC by default, fundraising entities using our platform can implement KYC/AML tools on their users.",
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
                                "6. Retention of Intellectual Property Rights",
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
                              '''MyCoinpoll, including the platform and services, is the intellectual property of MyCoinpoll and its clients. All rights, title, and interest, including trademarks, are protected by intellectual property laws. Users may not engage in Unauthorized Use, including copying, distributing, reverse engineering, or modifying the platform, and are solely responsible for any resulting damage, costs, or expenses.''',
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
                                "7. Jurisdiction and Governing Law",
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
                              '''7.1 The laws of Panama govern this Agreement.

7.2 MyCoinpoll services are unavailable to citizens and residents of the United States of America, China, Hong Kong, and sanctioned OFAC countries.''',
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
                                "8. Third-Party Services",
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
                              '''MyCoinpoll may incorporate or link to Third-Party Services, including content and information owned by third parties. Users acknowledge that the responsibility for these services lies with the third party, and using them is at the user's own risk. MyCoinpoll makes no representations or warranties regarding Third-Party Services and disclaims all liabilities associated with their accuracy or completeness. Intellectual property rights for Third-Party Services belong to the respective third parties.''',
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
                                "9. Breach and Indemnification",
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
                              '''MyCoinpoll reserves the right to take action, including terminating the Agreement, in case of a user breach. Users agree to indemnify and hold harmless MyCoinpoll from claims and expenses arising from their use of services, breaches of these Terms, or violations of applicable laws.''',
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
                                "10. Force Majeure",
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
                              '''MyCoinpoll is not liable for delays or service interruptions caused by factors beyond our control, such as acts of God, civil disturbances, strikes, or equipment failures.''',
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
                                "11. Miscellaneous",
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
                              '''11.1 Severability: If any provision becomes illegal or unenforceable, it won't affect the validity of other provisions.

11.2 Assignment: MyCoinpoll may assign this Agreement without notice, but users cannot assign their rights or obligations.

11.3 Third-Party Rights: Individuals not party to this Agreement have no rights to enforce its terms. No consent from non-parties is needed for waiver, variation, or termination.''',
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
                                "11. Miscellaneous",
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
                              '''11.1 Severability: If any provision becomes illegal or unenforceable, it won't affect the validity of other provisions.

11.2 Assignment: MyCoinpoll may assign this Agreement without notice, but users cannot assign their rights or obligations.

11.3 Third-Party Rights: Individuals not party to this Agreement have no rights to enforce its terms. No consent from non-parties is needed for waiver, variation, or termination.''',
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
