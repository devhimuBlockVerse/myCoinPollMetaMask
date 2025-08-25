import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/dynamicFontSize.dart';

class CustomLabeledInputField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? controller;
  final bool isReadOnly;
  final String? trailingIconAsset;
  final VoidCallback? onTrailingIconTap;
  final bool expands;
  final double? containerWidth;

  const CustomLabeledInputField({
    super.key,
    required this.labelText,
    required this.hintText,
      this.controller,
    this.isReadOnly = false,
    this.trailingIconAsset,
    this.onTrailingIconTap,
    this.expands = false,
    this.containerWidth,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    final baseFontSize = screenWidth < screenHeight
        ? screenWidth * 0.03
        : screenHeight * 0.04;

    final fontSize = baseFontSize * textScale;

    double getResponsiveFontSize(BuildContext context, double baseSize) {
      return baseSize;
    }

    return Container(
      width: containerWidth ?? double.infinity,
      decoration: BoxDecoration(
      color: Colors.white12,
        borderRadius: BorderRadius.circular(screenWidth * 0.02),

    ),

      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.022,
        vertical: screenHeight * 0.009,
       ),

       child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [ Color(0xFF2EE4A4),Color(0xFF2D8EFF)],
              ).createShader(bounds),
              child: Text(
                labelText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(context, 14),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: isReadOnly,
                      controller: controller,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        // fontSize: fontSize,
                        fontSize: getResponsiveFontSize(context, 14),
                                    ),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                           fontSize: getResponsiveFontSize(context, 12),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffFFF5ED),

                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      cursorColor: Colors.white,
                      maxLines: 1,
                      minLines: 1,
                    ),
                  ),
                  if (trailingIconAsset != null)
                    GestureDetector(
                      onTap: onTrailingIconTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: SvgPicture.asset(
                          trailingIconAsset!,
                          // height: fontSize * 1.1,
                          height: getResponsiveFontSize(context,18),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





