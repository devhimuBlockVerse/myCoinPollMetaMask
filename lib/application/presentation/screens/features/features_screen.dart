import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/androverse/androverse_screen.dart';
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
        // extendBodyBehindAppBar: true,
        // backgroundColor: Colors.transparent,

        body:  SafeArea(
          top: false,
          child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                 color: Color(0xFF01090B),
                image: DecorationImage(

                  image: AssetImage('assets/images/starGradientBg.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topRight,
                  filterQuality: FilterQuality.medium,

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
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                              const FeatureCard(
                                iconPath: 'assets/images/cryptoLaunchpad.png',
                                title: 'Crypto Launchpad',
                                description: 'Discover and support new cryptocurrency projects with our secure, innovative, and user-friendly platform.',
                                isSvg: false,

                              ),


                              SizedBox(height: screenHeight * 0.016),
                             const FeatureCard(
                                iconPath: 'assets/images/ecmToken.png',
                                title: 'ECM Token',
                                description: 'Powering the ecosystem, ECM Token enhances the experience, offering exclusive access to investments.',
                                isSvg: false,

                              ),

                              SizedBox(height: screenHeight * 0.016),
                             const FeatureCard(
                                iconPath: 'assets/images/communityVoting.png',
                                title: 'Community Voting',
                                description: 'Our platform integrates community voting to allow users to participate in deciding which projects receive funding.',
                                isSvg: false,

                              ),
                              SizedBox(height: screenHeight * 0.016),
                             const FeatureCard(
                                iconPath: 'assets/images/educationalRes.png',
                                title: 'Educational Resources',
                                description: 'Learn about blockchain, crypto, and launchpads with our comprehensive educational content.',
                                isSvg: false,

                              ),
                              SizedBox(height: screenHeight * 0.016),
                             const FeatureCard(
                                iconPath: 'assets/images/metaVerseIntegration.png',
                                title: 'Metaverse Integration',
                                description: 'Access Androverse, our innovative metaverse, where users can buy virtual land and enjoy exclusive experiences with ECM Tokens.',
                                isSvg: false,

                              ),
                              SizedBox(height: screenHeight * 0.016),
                             const FeatureCard(
                                iconPath: 'assets/images/projectLaunch.png',
                                title: 'Project Launches',
                                description: 'Gain early access to exclusive crypto launches and opportunities for ECM Token holders and MyCoinPoll community members.',
                                isSvg: false,

                              ),


                            ],
                          ),
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



