import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/framework/components/badgeComponent_V2.dart';

import '../../../../framework/components/BlockButton.dart';


class LearnEarnScreen extends StatefulWidget {
  const LearnEarnScreen({super.key});

  @override
  State<LearnEarnScreen> createState() => _LearnEarnScreenState();
}

class _LearnEarnScreenState extends State<LearnEarnScreen> {


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
                        'Learn & Earn',
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
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                           _headerSection(context),
                          SizedBox(height: screenHeight * 0.03),
                          Text(
                            'Learn & Earn',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: baseSize * 0.045,
                              height: 1.2,
                              color: Colors.white,
                            ),
                          ),


                          // _learnAndEarnContainer(),

                          LearnAndEarnContainer(
                            title: 'Blockchain Fundamentals & Analysis',
                            description: 'Explore how blockchain is revolutionizing industries with secure, transparent, and efficient data handling.',
                            imagePath: 'assets/icons/learnAndEarnImg.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LearnEarnScreen()),
                              );
                            },
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
                  Flexible(
                    child: AutoSizeText(
                       'Grow Your Crypto Knowledge',
                      style: TextStyle(
                        color: const Color(0xFFFFF5ED),
                        fontFamily: 'Poppins',
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  Flexible(
                    child: AutoSizeText(
                      'Earn free crypto by completing short courses on blockchain, DeFi, and emerging tech.',
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
              flex: 2,
              child: Image.asset(
                'assets/icons/headerFrameContainer.png',
                height: screenHeight * 0.12,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _learnAndEarnContainer(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.22,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/learnAndEarnBgContainer.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: baseSize * 0.02,
          horizontal: baseSize * 0.02,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: screenWidth * 0.39,
              child: Image.asset('assets/icons/learnAndEarnImg.png',fit: BoxFit.contain,),
            ),

            // Right Side: Text and Button
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: baseSize * 0.015,
                  horizontal: baseSize * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                   children: <Widget>[
                    AutoSizeText(
                      'Blockchain Fundamentals & Analysis',
                      textAlign: TextAlign.right,

                      style: TextStyle(
                        color: Color(0XFFFFF5ED),
                        fontSize: baseSize * 0.040,
                        fontWeight: FontWeight.w500,
                        height: 1.3,

                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: baseSize * 0.01),
                    Expanded(
                      child: AutoSizeText(
                        'Explore how blockchain is revolutionizing industries with secure, transparent, and efficient data handling.',
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(
                          color: Color(0XFFFFF5ED),
                          fontSize: baseSize * 0.030,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: baseSize * 0.03),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlockButton(
                        height: baseSize * 0.08,
                        width: screenWidth * 0.3,
                        label: "Get Started",
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: baseSize * 0.030,
                        ),
                        gradientColors: const [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494),
                        ],
                        onTap: () {
                          print('Button tapped');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LearnEarnScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}

class LearnAndEarnContainer extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback onTap;

  const LearnAndEarnContainer({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.22,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/learnAndEarnBgContainer.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: baseSize * 0.02,
          horizontal: baseSize * 0.02,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// 👇 Stack for Image and Badge
            Container(
              width: screenWidth * 0.39,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 10,
                    child: BadgeComponentV2(
                      text: "Blockchain",
                      leadingIcon: Icons.school,
                      svgAssetPath: 'assets/icons/linkArrow.svg', // You will handle this next
                      width: screenWidth * 0.210,
                      height: screenHeight * 0.028,
                      iconSize: 10,
                      onTap: () {
                        print("Tapped");
                      },
                      gradientColors: [
                        Color(0xFF00C6FF),
                        Color(0xFF0072FF),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Right side: title, description, button
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: baseSize * 0.015,
                  horizontal: baseSize * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    AutoSizeText(
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFFFFF5ED),
                        fontSize: baseSize * 0.040,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: baseSize * 0.01),
                    Expanded(
                      child: AutoSizeText(
                        description,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(
                          color: const Color(0xFFFFF5ED),
                          fontSize: baseSize * 0.030,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: baseSize * 0.03),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlockButton(
                        height: baseSize * 0.08,
                        width: screenWidth * 0.3,
                        label: "Start Learning",
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: baseSize * 0.030,
                        ),
                        gradientColors: const [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494),
                        ],
                        onTap: onTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
