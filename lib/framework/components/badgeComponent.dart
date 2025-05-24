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

  const BadgeComponent({super.key, required this.text, required this.isSelected, required this.onTap, this.width, this.height, this.fontSize, this.selectedColor, this.unselectedColor});

  @override
  Widget build(BuildContext context) {
     final double responsiveWidth = width ?? MediaQuery.of(context).size.width * 0.16;
    final double responsiveHeight = height ?? MediaQuery.of(context).size.height * 0.025;
    final double responsiveFontSize = fontSize ?? MediaQuery.of(context).size.width * 0.026;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: responsiveWidth,
        height: responsiveHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? (selectedColor ?? Colors.blueAccent) : (unselectedColor ?? Colors.white.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: responsiveFontSize,
              // fontSize: getResponsiveFontSize(context, 12),
              height: 0.8,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}



class BadgetButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Scaled based on size
    final double cutSize = size.height * 0;
    final double notchWidth = size.width * 0 ;
    final double notchHeight = size.height * 0;

    // Notch offsets
    final double topNotchOffset = size.width * 0;
    final double bottomNotchOffset = -size.width * 0;

    // Start from top-left
    path.moveTo(cutSize, 0);

    // Top notch
    double topNotchCenter = (size.width / 2) + topNotchOffset;
    path.lineTo(topNotchCenter - (notchWidth / 2), 0);
    path.lineTo(topNotchCenter - (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), 0);

    // Top-right
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cutSize);

    // Bottom-right corner cut
    path.lineTo(size.width - cutSize, size.height);

    // Bottom notch
    double bottomNotchCenter = (size.width / 2) + bottomNotchOffset;
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height);
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height);

    // Bottom-left & left side cut
    path.lineTo(0, size.height);
    path.lineTo(0, cutSize);
    path.lineTo(cutSize, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

