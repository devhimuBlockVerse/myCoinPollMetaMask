import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/dynamicFontSize.dart';


class UserBadgeLevel extends StatelessWidget {
  final String label;
  final String iconPath;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double? widthFactor;
  final double? heightFactor;

  const UserBadgeLevel({
    super.key,
    required this.label,
    required this.iconPath,
    this.backgroundColor = const Color(0xCC1CD691),
    this.borderColor = const Color.fromRGBO(255, 255, 255, 0.7),
    this.textColor = Colors.white,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final containerWidth = widthFactor ?? baseSize * 0.18;
    final containerHeight = heightFactor ?? baseSize * 0.06;
    final horizontalPadding = baseSize * 0.013;
    final verticalPadding = baseSize * 0.005;
    const borderWidth = 0.51;
    final iconSize = baseSize * 0.04;
    final spacingBetweenIconAndText = baseSize * 0.008;
    const textHeight = 1.1;

    return Container(
      width: containerWidth,
      height: containerHeight,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
          ),
          SizedBox(width: spacingBetweenIconAndText),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: getResponsiveFontSize(context, 10),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: textHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
