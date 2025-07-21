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
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(12),

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
                        fontSize: screenWidth * 0.045 * textScale,
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
        );
      },
    );
  }
}
