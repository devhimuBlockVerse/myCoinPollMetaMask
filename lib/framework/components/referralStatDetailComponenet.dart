import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/status_styling_utils.dart';

class ReferralDetailsComponent extends StatelessWidget {
  final String label;
  final String value;
  final String? svgIconPath;
  final double? spacing;
  final String? status;

  const ReferralDetailsComponent({super.key, required this.label, required this.value, this.svgIconPath, this.spacing, this.status});

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied: $value")),
    );
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = width * 0.031;
    final showStatus = status != null && status!.isNotEmpty;
    final styling = showStatus ? getReferralUserStatusStyle(status!) : null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.018),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF7D8FA9),
              fontSize: fontSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: spacing ?? 10,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width * 0.6),
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                if (svgIconPath != null)
                  GestureDetector(
                    onTap: () => _copyToClipboard(context),
                    child: SvgPicture.asset(
                      svgIconPath!,
                      width: fontSize + 3,
                      height: fontSize + 3,
                      fit: BoxFit.contain,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                if (showStatus)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                    decoration: BoxDecoration(
                      color: styling!.backgroundColor,
                      border: Border.all(color: styling.borderColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status!,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: styling.textColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        height: 0.8,
                      ),
                    ),
                  ),
              ],
            ),
          ),

         ],
      ),
    );
  }
}
