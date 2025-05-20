import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const StatusChip({
    Key? key,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  }) : super(key: key);

  // Factory constructors for common statuses
  factory StatusChip.approved() {
    return const StatusChip(
      label: 'Approved',
      backgroundColor: Color(0x19359846),
      borderColor: Color(0x66359846),
      textColor: Color(0xFF1CD494),
    );
  }

  factory StatusChip.rejected() {
    return const StatusChip(
      label: 'Rejected',
      backgroundColor: Color(0x19FF3B3B),
      borderColor: Color(0x66FF3B3B),
      textColor: Color(0xFFFF3B3B),
    );
  }

  factory StatusChip.pending() {
    return const StatusChip(
      label: 'Pending',
      backgroundColor: Color(0x19FFA500),
      borderColor: Color(0x66FFA500),
      textColor: Color(0xFFFFA500),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double chipHeight = screenWidth * 0.06;
    double fontSize = screenWidth * 0.03;

    return Container(
      height: chipHeight.clamp(20.0, 32.0),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: borderColor),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: getResponsiveFontSize(context, 12),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}
