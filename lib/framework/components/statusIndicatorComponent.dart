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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              statusLabel,
              style: TextStyle(
                color: Colors.white,
                fontSize: getResponsiveFontSize(context, 12),
                fontFamily: 'Poppins',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: statusColor, width: 0.25),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (iconPath.isNotEmpty) ...[
                    SvgPicture.asset(
                      iconPath,
                      width: getResponsiveFontSize(context, 13),
                      height: getResponsiveFontSize(context, 13),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: Color(0xFFE04043),
                        fontSize: getResponsiveFontSize(context, 12),
                        fontFamily: 'Poppins',
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}





