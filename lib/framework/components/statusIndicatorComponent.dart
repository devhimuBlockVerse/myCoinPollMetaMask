import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/dynamicFontSize.dart';

class StatusIndicator extends StatelessWidget {
  final String statusText;
  final String statusLabel;
  final Color statusColor;
  final String iconPath;

  const StatusIndicator({
    super.key,
    required this.statusText,
    this.statusLabel = 'Status:',
    required this.statusColor,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              statusLabel,
              style: TextStyle(
                color: Colors.white,
                fontSize: getResponsiveFontSize(context, 10),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: statusColor, width: 0.25),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (iconPath.isNotEmpty) ...[
                    SvgPicture.asset(
                      iconPath,
                      width: getResponsiveFontSize(context, 10),
                      height: getResponsiveFontSize(context, 10),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    statusText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getResponsiveFontSize(context, 10),
                      fontFamily: 'Poppins',
                    ),
                    softWrap: true,
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
