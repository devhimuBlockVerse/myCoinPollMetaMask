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
  final BoxBorder ? border;

  const BlockButton({
    super.key,
    required this.label,
    this.width,
    this.height,
    required this.onTap,
    required this.gradientColors,
    this.iconPath,
    this.iconSize,
    this.border,
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
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(9),
          border: border
          //

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
    );
  }
}

