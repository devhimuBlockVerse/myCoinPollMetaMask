import 'package:flutter/material.dart';

import '../../../../../framework/components/VestingContainer.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';

class VestingItem extends StatelessWidget {
  final String imagePath;
  final String text;
  final double height;

  const VestingItem({
    super.key,
    required this.imagePath,
    required this.text,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return VestingContainer(
      borderColor: const Color(0XFF2C2E41),
      backgroundColor: const Color(0XFF101A29),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: height * 0.01,
      ),
      borderRadius: BorderRadius.circular(2.0),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.contain,
            height: height * 0.04,
          ),
          const SizedBox(width: 12),
          Container(
              margin: EdgeInsets.symmetric(horizontal: height * 0.001),
              width: 1, height: 30, color: Colors.white24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style:  TextStyle(
                color: Colors.white,
                fontSize: getResponsiveFontSize(context, 12),
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
