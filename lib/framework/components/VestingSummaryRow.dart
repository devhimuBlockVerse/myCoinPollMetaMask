import 'package:flutter/material.dart';

import '../utils/dynamicFontSize.dart';

class VestingSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  const VestingSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final defaultLabelStyle = TextStyle(
      color: const Color(0xFF7D8FA9),
      fontSize: getResponsiveFontSize(context, 12),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    );

    final defaultValueStyle = TextStyle(
      color: const Color(0XFFFFF5ED),
      fontSize: getResponsiveFontSize(context, 14),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    );

    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Expanded(
          child: Text(
            label,
            style: labelStyle ?? defaultLabelStyle,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: valueStyle ?? defaultValueStyle,
          ),
        ),
      ],
    );
  }
}
