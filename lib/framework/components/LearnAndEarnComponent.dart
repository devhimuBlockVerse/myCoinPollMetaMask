import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'BlockButton.dart';
import 'badgeComponent_V2.dart';

class LearnAndEarnContainer extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback onTap;

  const LearnAndEarnContainer({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.22,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/learnAndEarnBgContainer.png'),
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
          children: <Widget>[
            /// 👇 Stack for Image and Badge
            SizedBox(
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
                    top: baseSize * 0.04,
                    left: baseSize * 0.015,
                    child: BadgeComponentV2(
                      text: "Blockchain",
                      leadingIcon: Icons.school,
                      svgAssetPath: 'assets/icons/linkArrow.svg',
                      width: screenWidth * 0.21,
                      height: screenHeight * 0.035,
                      fontSize: baseSize * 0.025,
                      iconSize: baseSize * 0.020,
                      iconColor: Colors.white,
                      onTap: () => print("Badge tapped"),
                      gradientColors: const [
                        Color(0xFF00C6FF),
                        Color(0xFF0072FF),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Right side content
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
