import 'package:flutter/material.dart';

import '../utils/dynamicFontSize.dart';

class BadgeComponent extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? selectedColor;
  final Color? unselectedColor;

  const BadgeComponent({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.width,
    this.height,
    this.fontSize,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final double responsiveWidth = width ?? MediaQuery.of(context).size.width * 0.16;
    final double responsiveHeight = height ?? MediaQuery.of(context).size.height * 0.025;
    final double responsiveFontSize = fontSize ?? MediaQuery.of(context).size.width * 0.026;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: responsiveWidth,
          height: responsiveHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? (selectedColor ?? Colors.blueAccent)
                : (unselectedColor ?? Colors.white.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(4),
            border: !isSelected ? Border.all(color: Colors.white54, width: 0.5) : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: responsiveFontSize,
              height: 0.8,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


