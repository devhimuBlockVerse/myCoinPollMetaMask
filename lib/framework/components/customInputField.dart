import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final String iconAssetPath;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;


  const CustomInputField({
    super.key,
    required this.hintText,
    required this.iconAssetPath,
    required this.controller,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    final containerHeight = screenHeight * 0.065;
    final iconSize = screenWidth * 0.06;
    final fontSize = screenWidth * 0.04 * textScale;
    final dividerHeight = containerHeight * 0.6;
    final fieldHeight = containerHeight * 0.65;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      height: containerHeight,
      width: screenWidth * 0.75, // 85% width
      decoration: BoxDecoration(
        color: const Color(0xFF191D26),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x7F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: iconSize,
            height: iconSize,
            margin: EdgeInsets.only(right: screenWidth * 0.025),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(iconAssetPath),
                fit: BoxFit.cover,
              ),

            ),
          ),

          // Token text
          Text(
            hintText,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontFamily: 'Poppins',
            ),
          ),

          // Divider
          SizedBox(width: screenWidth * 0.135),
          Container(
            height: dividerHeight,
            width: 1,
            color: const Color(0xFF13161E),
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          ),

          // Input field
          Expanded(
            child: Container(
              height: fieldHeight,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: const Color(0xFF2B2D40),
                  width: 0.25,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF191D26),
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.centerRight,
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: inputFormatters,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: '0.000',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: fontSize * 0.95),
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                cursorColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
