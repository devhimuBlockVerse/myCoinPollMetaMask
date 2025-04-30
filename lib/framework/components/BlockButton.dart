import 'package:flutter/material.dart';
import 'dart:math' as math;



// class BlockButton extends StatelessWidget {
//   final String label;
//   final double? width;
//   final double? height;
//   final VoidCallback onTap;
//   final List<Color> gradientColors;
//
//   const BlockButton({
//     super.key,
//     required this.label,
//     this.width,
//     this.height,
//     required this.onTap,
//     required this.gradientColors,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final screenWidth = MediaQuery.of(context).size.width;
//         final screenHeight = MediaQuery.of(context).size.height;
//         final textScale = MediaQuery.of(context).textScaleFactor;
//
//         final buttonWidth = width ?? screenWidth * 0.8;
//         final buttonHeight = height ?? screenHeight * 0.065;
//
//         return GestureDetector(
//           onTap: onTap,
//           child: ClipPath(
//             clipper: BlockButtonclipper(),
//             child: Container(
//               width: buttonWidth,
//               height: buttonHeight,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: gradientColors,
//                 ),
//               ),
//               child: Center(
//                 child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     label,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontSize: screenWidth * 0.045 * textScale, // responsive text
//                     ),
//                     maxLines: 1,
//                     textAlign: TextAlign.center,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


/**

class BlockButton extends StatelessWidget {
  final String label;
  final double? width;
  final double? height;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  // 🔥 New parameters
  final String? iconPath; // User can pass icon/image asset path
  final double iconSize;  // Icon size
  final double iconRotation; // Rotation in degrees

  const BlockButton({
    super.key,
    required this.label,
    this.width,
    this.height,
    required this.onTap,
    required this.gradientColors,

    // New parameters (optional)
    this.iconPath,
    this.iconSize = 24.0,
    this.iconRotation = 0.0, // default no rotation
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final textScale = MediaQuery.of(context).textScaleFactor;

        final buttonWidth = width ?? screenWidth * 0.8;
        final buttonHeight = height ?? screenHeight * 0.065;

        return GestureDetector(
          onTap: onTap,
          child: ClipPath(
            clipper: BlockButtonclipper(),
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // 🔥 Only show if iconPath is provided
                    if (iconPath != null)
                      Transform.rotate(
                        angle: iconRotation * math.pi / 180, // Convert degrees to radians
                        child: Image.asset(
                          iconPath!,
                          width: iconSize,
                          height: iconSize,
                          color: Colors.white, // optional: tint icon white
                        ),
                      ),

                    if (iconPath != null)
                      SizedBox(width: 8), // space between icon & text

                    // Text
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: screenWidth * 0.045 * textScale,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BlockButtonclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double notchWidth = 30;
    const double notchHeight = 2;
    const double cutSize = 20;

    // Offset amounts
    const double topNotchOffset = 60; // move right
    const double bottomNotchOffset = -60; // move left

    // Top-left angled start
    path.moveTo(cutSize, 0);

    // Top notch (slightly right of center)
    double topNotchCenter = (size.width / 2) + topNotchOffset;
    path.lineTo(topNotchCenter - (notchWidth / 2), 0);
    path.lineTo(topNotchCenter - (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), 0);

    // Top-right corner (no cut)

    path.lineTo(size.width, 0);

    // Right side down
    path.lineTo(size.width, size.height - cutSize);

    // Bottom-right corner with cut
    path.lineTo(size.width - cutSize, size.height);

    // Bottom notch (slightly left of center)
    double bottomNotchCenter = (size.width / 2) + bottomNotchOffset;
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height);
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height);

    // Bottom-left corner (no cut)
    path.lineTo(0, size.height);

    // Left side up to top-left (cut)
    path.lineTo(0, cutSize);
    path.lineTo(cutSize, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
**/


class BlockButton extends StatelessWidget {
  final String label;
  final double? width;
  final double? height;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  final String? iconPath;
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
    this.iconRotation = 0.0, this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final buttonWidth = width ?? screenWidth * 0.8;
    final buttonHeight = height ?? screenHeight * 0.065;

     final calculatedIconSize = iconSize ?? buttonHeight * 0.6;

     final calculatedFontSize = buttonHeight * 0.4;
    final effectiveTextStyle = (textStyle ?? TextStyle())
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
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

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

                if (iconPath != null)
                  Transform.rotate(
                    angle: iconRotation * math.pi / 180,
                    child: Image.asset(
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

class BlockButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    // Scaled based on size
    final double cutSize = size.height * 0.25;
    final double notchWidth = size.width * 0.1;
    final double notchHeight = size.height * 0.08;

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
