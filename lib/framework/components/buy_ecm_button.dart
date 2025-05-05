import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class CustomGradientButton extends StatelessWidget {
  final String label;
  final double? width;
  final double? height;
  final VoidCallback onTap;
  final List<Color> gradientColors;
  final String? leadingImagePath;
  final String? trailingImagePath;
  const CustomGradientButton({
    super.key,
    required this.label,
    this.width,
    this.height,
    required this.onTap,
    required this.gradientColors, this.leadingImagePath, this.trailingImagePath,
  });

  Widget _buildImage(String path, double size) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final textScale = MediaQuery.of(context).textScaleFactor;

        final buttonWidth = width ?? screenWidth * 0.8;
        final buttonHeight = height ?? screenHeight * 0.065;
        final imageSize = buttonHeight * 0.5;

        return GestureDetector(
          onTap: onTap,
          child: ClipPath(
            clipper: BuyEcmClipper(),
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
                    if (leadingImagePath != null) ...[
                      _buildImage(leadingImagePath!, imageSize),
                      const SizedBox(width: 8),
                    ],
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: screenWidth * 0.045 * textScale, // responsive text
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (trailingImagePath != null) ...[
                      const SizedBox(width: 8),
                      _buildImage(trailingImagePath!, imageSize),
                    ],
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
class BuyEcmClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double notchWidth = 18;
    const double notchHeight = 3;
    const double cutSize = 8;

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
