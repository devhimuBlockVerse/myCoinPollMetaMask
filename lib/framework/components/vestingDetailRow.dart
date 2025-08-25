import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/dynamicFontSize.dart';

class VestingDetailInfoRow extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;
  final double? iconSize;

  const VestingDetailInfoRow({
    super.key,
    required this.iconPath,
    required this.title,
    required this.value,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(
          iconPath,
          fit: BoxFit.contain,
          height: iconSize ?? screenHeight * 0.03,
        ),
        SizedBox(width: screenWidth * 0.02),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF7D8FA9),
                  fontSize: getResponsiveFontSize(context, 12),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,

                ),

              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                value,
                style:  TextStyle(
                  color: const Color(0xFFFFF5ED),
                  fontSize: getResponsiveFontSize(context, 13),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),

              ),
            ],
          ),
        ),
      ],
    );
  }
}
