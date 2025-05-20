import 'package:flutter/material.dart';

import '../utils/dynamicFontSize.dart';
class MilestoneLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool padRight;

  const MilestoneLegendItem({
    super.key,
    required this.color,
    required this.label,
    this.padRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
        bottom: screenHeight * 0.005,
        right: padRight ? screenWidth * 0.17 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: screenWidth * 0.04,
            height: screenWidth * 0.04,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFFFFF5ED),
              fontSize: getResponsiveFontSize(context, 12),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1.25,
              letterSpacing: -0.32,
            ),
          ),
        ],
      ),
    );
  }
}
