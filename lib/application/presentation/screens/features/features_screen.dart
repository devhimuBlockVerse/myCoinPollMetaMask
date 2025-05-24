import 'package:flutter/material.dart';

import '../../../../framework/components/featureCard.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() =>
      _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
   @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return  Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,

        body:  SafeArea(
          top: false,
          child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                 color: Color(0xFF01090B),
                image: DecorationImage(
                  // image: AssetImage('assets/icons/gradientBgImage.png'),
                  // fit: BoxFit.contain,
                  image: AssetImage('assets/icons/starGradientBg.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topRight,
                ),
              ),
              child:Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: Alignment.topCenter,
                    child:  Text(
                      'Features',
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
                            // SizedBox(height: screenHeight * 0.02),
                            FeatureCard(
                              iconPath: 'assets/icons/cryptoLaunchpad.png',
                              title: 'Crypto Launchpad',
                              description: 'Discover and support new cryptocurrency projects with our secure, innovative, and user-friendly platform.',
                              isSvg: false,
                              onTap: () {
                                debugPrint('Card clicked!');
                                // Navigate or do any action here
                              },
                            ),


                            SizedBox(height: screenHeight * 0.016),
                            FeatureCard(
                              iconPath: 'assets/icons/ecmToken.png',
                              title: 'ECM Token',
                              description: 'Powering the ecosystem, ECM Token enhances the experience, offering exclusive access to investments.',
                              isSvg: false,
                              onTap: () {
                                debugPrint('Card clicked!');
                                // Navigate or do any action here
                              },
                            ),

                            SizedBox(height: screenHeight * 0.016),
                            FeatureCard(
                              iconPath: 'assets/icons/communityVoting.png',
                              title: 'Community Voting',
                              description: 'Our platform integrates community voting to allow users to participate in deciding which projects receive funding.',
                              isSvg: false,
                              onTap: () {
                                debugPrint('Card clicked!');
                                // Navigate or do any action here
                              },
                            ),
                            SizedBox(height: screenHeight * 0.016),
                            FeatureCard(
                              iconPath: 'assets/icons/educationalRes.png',
                              title: 'Educational Resources',
                              description: 'Learn about blockchain, crypto, and launchpads with our comprehensive educational content.',
                              isSvg: false,
                              onTap: () {
                                debugPrint('Card clicked!');
                                // Navigate or do any action here
                              },
                            ),
                            SizedBox(height: screenHeight * 0.016),
                            FeatureCard(
                              iconPath: 'assets/icons/metaVerseIntegration.png',
                              title: 'Metaverse Integration',
                              description: 'Access Androverse, our innovative metaverse, where users can buy virtual land and enjoy exclusive experiences with ECM Tokens.',
                              isSvg: false,
                              onTap: () {
                                debugPrint('Card clicked!');
                                // Navigate or do any action here
                              },
                            ),
                            SizedBox(height: screenHeight * 0.016),
                            FeatureCard(
                              iconPath: 'assets/icons/projectLaunch.png',
                              title: 'Project Launches',
                              description: 'Gain early access to exclusive crypto launches and opportunities for ECM Token holders and MyCoinPoll community members.',
                              isSvg: false,
                              onTap: () {
                                debugPrint('Card clicked!');
                                // Navigate or do any action here
                              },
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        )
    );
  }


}



