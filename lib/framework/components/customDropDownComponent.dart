import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final double? width;  // Made nullable
  final double? height; // Made nullable

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double responsiveWidth = width ?? screenWidth * 0.4;
    final double responsiveHeight = height ?? screenHeight * 0.040;

    final double fontSize = screenHeight * 0.016;
    final double horizontalPadding = screenWidth * 0.025;
    final double borderRadius = screenWidth * 0.008;

    return Container(
      width: responsiveWidth,
      height: responsiveHeight,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: ShapeDecoration(
        color: const Color(0xFF101A29),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF141317)),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xFFC7E0FF),
            blurRadius: 0,
            offset: Offset(0.10, 0.50),
            spreadRadius: 0,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: const Color(0xFF101A29),
          value: selectedValue,
          isExpanded: true,
          iconSize: screenHeight * 0.025,
          icon: SvgPicture.asset(
            'assets/icons/dropDownIcon.svg',
            height: screenHeight * 0.01,
            colorFilter: const ColorFilter.mode(Color(0xFF7D8FA9), BlendMode.srcIn),
          ),
          hint: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: fontSize,
              height: 1.6,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
          onChanged: onChanged,

          items: items.map((String value) {

            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize,
                  height: 1.6,
                  color: Colors.white.withOpacity(0.8),

                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}



