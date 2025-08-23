import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';

class InfoCard extends StatelessWidget {
  final String label1;
  final String label2;
  final String description;
  final String imagePath;
  final String? backgroundImagePath;
  final double? width;

  const InfoCard({
    super.key,
    required this.label1,
    required this.label2,
    required this.description,
    required this.imagePath,
    this.backgroundImagePath,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double baseSize = screenWidth < 600 ? screenWidth : screenHeight;

          return Container(
            width: width ?? screenWidth * 0.9,
            padding: EdgeInsets.symmetric(
              horizontal: baseSize * 0.04,
              vertical: baseSize * 0.04,
            ),
            decoration: BoxDecoration(
              color: backgroundImagePath == null ? const Color(0xFF12171C) : null,
              image: backgroundImagePath != null
                  ? DecorationImage(
                image: AssetImage(backgroundImagePath!),
                fit: BoxFit.cover,
              )
                  : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Labels
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              label1,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600, // Medium
                                fontSize: getResponsiveFontSize(context, 16),
                                height: 1.3, // 130%
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              label2,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400, // Regular
                                fontSize: getResponsiveFontSize(context, 14),

                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Logo
                    const SizedBox(width: 12),
                    Container(
                      width: baseSize * 0.12,
                      height: baseSize * 0.12,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          // image: AssetImage(imagePath),
                          image: imagePath.startsWith('http')
                              ? NetworkImage(imagePath)
                              : AssetImage(imagePath) as ImageProvider,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.medium,

                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: baseSize * 0.03),

                /// Description
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400, // Regular
                    fontSize: getResponsiveFontSize(context, 12),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
