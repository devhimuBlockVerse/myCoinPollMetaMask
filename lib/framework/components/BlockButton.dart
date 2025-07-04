import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';



class BlockButton extends StatelessWidget {
  final String label;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final List<Color> gradientColors;

  final String? iconPath;
  final String? leadingIconPath;
  final double? iconSize;
  final double iconRotation;
  final TextStyle? textStyle;

  const BlockButton({
    super.key,
    required this.label,
    this.width,
    this.height,
    required this.onTap,
    required this.gradientColors,
    this.iconPath,
    this.iconSize,
    this.iconRotation = 0.0, this.textStyle, this.leadingIconPath,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final buttonWidth = width ?? screenWidth * 0.8;
    final buttonHeight = height ?? screenHeight * 0.065;

     final calculatedIconSize = iconSize ?? buttonHeight * 0.6;

     final calculatedFontSize = buttonHeight * 0.4;
    final effectiveTextStyle = (textStyle ?? const TextStyle())
        .copyWith(
      fontSize: textStyle?.fontSize ?? calculatedFontSize,
      color: textStyle?.color ?? Colors.white,
    );

    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: BlockButtonClipper(),
        child: Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(9),

          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIconPath != null)
                Transform.rotate(
                    angle: iconRotation * math.pi / 180,
                    child: SvgPicture.asset(
                      leadingIconPath!,
                      width: calculatedIconSize,
                      height: calculatedIconSize,
                      color: Colors.white,
                    ),
                  ),
                SizedBox(width: buttonWidth * 0.03),


                if (iconPath != null)
                  SizedBox(width: buttonWidth * 0.03),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: effectiveTextStyle,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: buttonWidth * 0.03),

                if (iconPath != null)
                  Transform.rotate(
                    angle: iconRotation * math.pi / 180,
                    child: SvgPicture.asset(
                      iconPath!,
                      width: calculatedIconSize,
                      height: calculatedIconSize,
                      color: Colors.white,
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
// class BlockButton extends StatelessWidget {
//   final String label;
//   final double? width;
//   final double? height;
//   final VoidCallback? onTap;
//   final List<Color> gradientColors;
//   final String? iconPath;
//   final String? leadingIconPath;
//   final double? iconSize;
//   final double iconRotation;
//   final TextStyle? textStyle;
//
//   const BlockButton({
//     super.key,
//     required this.label,
//     this.width,
//     this.height,
//     required this.onTap,
//     required this.gradientColors,
//     this.iconPath,
//     this.iconSize,
//     this.iconRotation = 0.0,
//     this.textStyle,
//     this.leadingIconPath,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     final buttonWidth = width ?? screenWidth * 0.8;
//     final buttonHeight = height ?? screenHeight * 0.065;
//
//     final calculatedIconSize = iconSize ?? buttonHeight * 0.6;
//     final calculatedFontSize = (screenWidth + screenHeight) * 0.0125;
//
//     final effectiveTextStyle = (textStyle ?? const TextStyle()).copyWith(
//       fontSize: textStyle?.fontSize ?? calculatedFontSize,
//       color: textStyle?.color ?? Colors.white,
//     );
//
//     return GestureDetector(
//       onTap: onTap,
//       child: ClipPath(
//         clipper: BlockButtonClipper(),
//         child: Container(
//           width: buttonWidth,
//           height: buttonHeight,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: gradientColors),
//             borderRadius: BorderRadius.circular(9),
//           ),
//           child: Center(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 if (leadingIconPath != null)
//                   Padding(
//                     padding: EdgeInsets.only(right: screenWidth * 0.015),
//                     child: Transform.rotate(
//                       angle: iconRotation * math.pi / 180,
//                       child: SvgPicture.asset(
//                         leadingIconPath!,
//                         width: calculatedIconSize,
//                         height: calculatedIconSize,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 Flexible(
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(
//                       label,
//                       style: effectiveTextStyle,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//                 if (iconPath != null)
//                   Padding(
//                     padding: EdgeInsets.only(left: screenWidth * 0.015),
//                     child: Transform.rotate(
//                       angle: iconRotation * math.pi / 180,
//                       child: SvgPicture.asset(
//                         iconPath!,
//                         width: calculatedIconSize,
//                         height: calculatedIconSize,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class BlockButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Scaled based on size
    final double cutSize = size.height * 0.0;
    final double notchWidth = size.width * 0.0;
    final double notchHeight = size.height * 0.0;

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
