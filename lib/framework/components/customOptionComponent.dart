import 'package:flutter/material.dart';
class CustomOptionComponent extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSquare;

  const CustomOptionComponent({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isSquare = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Screen dimensions for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // Responsive sizes
    double boxSize = isPortrait ? screenWidth * 0.05 : screenHeight * 0.05;
    double innerBoxSize = boxSize * 0.6;
    double fontSize = isPortrait ? screenWidth * 0.030 : screenHeight * 0.030;
    double spacing = isPortrait ? screenWidth * 0.01 : screenHeight * 0.01;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Outer box
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              border: Border.all(
                width: 1,
                color: const Color(0xFF277BF5).withOpacity(0.50),
              ),
              borderRadius: isSquare ? BorderRadius.circular(4) : null,
            ),
            child: isSelected
                ? Center(
              child: isSquare
                  ? Icon(
                Icons.check,
                size: innerBoxSize,
                color: Colors.white,
              )
                  : Container(
                width: innerBoxSize,
                height: innerBoxSize,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color(0xFF277BF5),
                      Color(0xFF1CD691),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            )
                : null,
          ),
          SizedBox(width: spacing),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              letterSpacing: -0.5,
              // height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
