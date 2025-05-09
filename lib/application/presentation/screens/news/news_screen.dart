import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../digital_model_screen.dart';
import '../home/home_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() =>
      _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
            children: [
              Center(
                child: BlockButtonContainer(
                  label: "Show Other Roadmap",
                  // width: screenWidth * 0.9,
                  height: screenHeight * 0.4,
                  onTap: () {},
                  gradientColors: [
                    Color(0xFF3EC6FF), // blue
                    Color(0xFF5CFFB1), // greenish
                  ],
                ),
              )

            ],
          )
      ),
    );
  }
}

class BlockButtonContainer extends StatelessWidget {
  final String? label;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final List<Color> gradientColors;

  final String? iconPath;
  final double? iconSize;
  final double iconRotation;
  final TextStyle? textStyle;

  const BlockButtonContainer({
    super.key,
      this.label,
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

    final calculatedFontSize = buttonHeight * 0.07;
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
                    label!,
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
    final double cut = 10;
    final double notchW = 14;
    final double notchH = 7;

    final double leftNotchX = size.width * 0.12;
    final double rightNotchX = size.width * 0.88;

    Path path = Path();

    // Start at top-left corner
    path.moveTo(cut, 0);

    // Top-left notch
    path.lineTo(leftNotchX - notchW, 0);
    path.lineTo(leftNotchX - notchW, notchH);
    path.lineTo(leftNotchX + notchW, notchH);
    path.lineTo(leftNotchX + notchW, 0);

    // Top-right line and cut
    path.lineTo(size.width - cut, 0);
    path.lineTo(size.width, cut);
    path.lineTo(size.width, size.height - cut);
    path.lineTo(size.width - cut, size.height);

    // Bottom-right notch
    path.lineTo(rightNotchX + notchW, size.height);
    path.lineTo(rightNotchX + notchW, size.height - notchH);
    path.lineTo(rightNotchX - notchW, size.height - notchH);
    path.lineTo(rightNotchX - notchW, size.height);

    // Bottom-left line and notch
    path.lineTo(leftNotchX + notchW, size.height);
    path.lineTo(leftNotchX + notchW, size.height - notchH);
    path.lineTo(leftNotchX - notchW, size.height - notchH);
    path.lineTo(leftNotchX - notchW, size.height);

    // Final left edge and top
    path.lineTo(cut, size.height);
    path.lineTo(0, size.height - cut);
    path.lineTo(0, cut);
    path.lineTo(cut, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
