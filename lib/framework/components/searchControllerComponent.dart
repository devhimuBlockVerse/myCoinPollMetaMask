import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/dynamicFontSize.dart';

class ResponsiveSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final String? svgAssetPath;

  const ResponsiveSearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'search...',this.svgAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double containerWidth = screenWidth * 0.55;
    double containerHeight = screenHeight * 0.040;
    double iconSize = screenHeight * 0.0135;
     double fontSize = getResponsiveFontSize(context, 13);

    return Container(
      width: containerWidth,
      height: containerHeight,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      decoration: ShapeDecoration(
        color: const Color(0xFF101A29),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF141317)),
          borderRadius: BorderRadius.circular(3),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xFFC7E0FF),
            blurRadius: 0,
            offset: Offset(0.10, 0.50),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [

          Opacity(
            opacity: 0.80,
            child: SvgPicture.asset(
              svgAssetPath!,
              width: iconSize,
              height: iconSize,
              colorFilter: const ColorFilter.mode(
                Color(0xFF7D8FA9),
                BlendMode.srcIn,
              ),
            ),
          ),          SizedBox(width: screenWidth * 0.015),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                color: const Color(0xFF7D8FA9),
                fontSize: fontSize,
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: hintText,
                hintStyle: TextStyle(
                    color: const Color(0xFF7D8FA9).withOpacity(0.8),
                    fontSize: fontSize,
                    fontFamily: 'Poppins',
                    height: 1.6
                ),
              ),
              cursorColor: const Color(0xFF7D8FA9),
            ),
          ),
        ],
      ),
    );
  }
}
