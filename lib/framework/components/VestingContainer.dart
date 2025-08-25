
import 'package:flutter/material.dart';

class VestingContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  static const Color defaultBackgroundColor = Color(0xE5040C16);
  static const Color defaultBorderColor = Color(0x4C2682EE);
  static final BorderRadiusGeometry defaultBorderRadius = BorderRadius.circular(8);

  const VestingContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final effectiveBackgroundColor = backgroundColor ?? defaultBackgroundColor;
    final effectiveBorderColor = borderColor ?? defaultBorderColor;
    final effectiveBorderRadius = borderRadius ?? defaultBorderRadius;
    return Container(
      width: width ?? screenWidth,
      height: height,
      padding: padding,
      decoration: ShapeDecoration(
        color: effectiveBackgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.80, color: effectiveBorderColor),
          borderRadius: effectiveBorderRadius,
        ),
      ),
      child: child,
    );
  }
}
