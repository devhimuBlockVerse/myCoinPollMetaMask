import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';

class FeatureCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String? description;
  final bool isSvg;
  final List<String>? bulletPoints;
  const FeatureCard({
    super.key,
    required this.iconPath,
    required this.title,
     this.description,
    this.isSvg = false,
    this.bulletPoints,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double iconWidth = screenWidth * 0.15;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.015,
        horizontal: screenWidth * 0.03,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0x33FFFFFF),
          width: 1,
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0x22FFFFFF),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.09],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 2,
            offset: Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
           isSvg
              ? SvgPicture.asset(
            iconPath,
            width: iconWidth,
            fit: BoxFit.contain,

          )
              : Image.asset(
            iconPath,
            width: iconWidth,
            fit: BoxFit.contain, filterQuality: FilterQuality.medium,

           ),
          SizedBox(width: screenWidth * 0.01),
          // Text
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Wrap height
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getResponsiveFontSize(context, 14),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: screenHeight * 0.006),
                if (description != null)
                  Opacity(
                  opacity: 0.7,
                  child: Text(
                    description  ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getResponsiveFontSize(context, 12),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                    ),
                  ),
                ),

                if (bulletPoints != null && bulletPoints!.isNotEmpty) ...[
                   ...bulletPoints!.map(
                        (point) => Padding(
                          padding: const EdgeInsets.all(1.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white70, size: 16),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                child: Text(
                                  point,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: getResponsiveFontSize(context, 12),
                                    fontFamily: 'Poppins',
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                ]

              ],
            ),
          ),
        ],
      ),
    );
  }
}

