import 'package:flutter/material.dart';



class CustomRadioOption extends StatelessWidget {
  final String label;
  final String selectedValue;
  final String value;
  final VoidCallback onTap;

  const CustomRadioOption({
    super.key,
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == selectedValue;
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

     double baseFontSize = 14.0;
    double fontSize = baseFontSize * (screenWidth / 400);

     fontSize = fontSize.clamp(12.0, 20.0);

     double baseSpacing = 10.0;
    double spacing = baseSpacing * (screenWidth / 400);
    spacing = spacing.clamp(6.0, 14.0);

     double baseCircleSize = 10.0;
    double circleSize = baseCircleSize * (screenWidth / 300);
    circleSize = circleSize.clamp(8.0, 14.0);

     double baseBorderWidth = 1.5;
    double borderWidth = baseBorderWidth * (screenWidth / 400);
    borderWidth = borderWidth.clamp(1.0, 2.0);

     double lineHeight = 1.2;

     const Gradient borderGradient = LinearGradient(
      colors: [Color(0xFF1CD494), Color(0xFF2680EF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
               border: Border.all(
                color: Colors.transparent,
                width: borderWidth,
              ),
              gradient: isSelected ? borderGradient : null,
              color: isSelected ? null : Colors.transparent,
            ),
            child: isSelected
                ? null
                : ShaderMask(
              shaderCallback: (bounds) => borderGradient.createShader(bounds),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: borderWidth,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: spacing),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: lineHeight,
            ),
          ),
        ],
      ),
    );
  }
}