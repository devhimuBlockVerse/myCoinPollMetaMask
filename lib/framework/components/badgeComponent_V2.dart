import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class BadgeComponentV2 extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double? fontSize;
  final IconData? leadingIcon;
  final double? iconSize;
  final Color? iconColor;
  final List<Color>? gradientColors;
  final String? svgAssetPath; // NEW

  const BadgeComponentV2({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.height,
    this.fontSize,
    this.leadingIcon,
    this.iconSize,
    this.iconColor,
    this.gradientColors,
    this.svgAssetPath, // NEW
  });

  @override
  Widget build(BuildContext context) {
    final double responsiveWidth = width ?? MediaQuery.of(context).size.width * 0.18;
    final double responsiveHeight = height ?? MediaQuery.of(context).size.height * 0.035;
    final double responsiveFontSize = fontSize ?? MediaQuery.of(context).size.width * 0.024;
    final double responsiveIconSize = iconSize ?? responsiveFontSize + 2;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: ClipPath(
        clipper: BadgetButtonClipperV2(),
        child: Center(
          child: Container(
            width: responsiveWidth,
            height: responsiveHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/blockChainBg.png'),
                fit: BoxFit.fill,
              ),

              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (svgAssetPath != null) ...[
                  SvgPicture.asset(
                    svgAssetPath!,
                    height: responsiveIconSize,
                    width: responsiveIconSize,
                    colorFilter: ColorFilter.mode(iconColor ?? Colors.white, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 4),
                ] else if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    size: responsiveIconSize,
                    color: iconColor ?? Colors.white,
                  ),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: responsiveFontSize,
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BadgetButtonClipperV2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Scaled based on size
    final double cutSize = size.height * 0.18;
    final double notchWidth = size.width * 0.1;
    final double notchHeight = size.height * 0.05;

    // Notch offsets
    final double topNotchOffset = size.width * 0.15;
    final double bottomNotchOffset = -size.width * 0.15;

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

