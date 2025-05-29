import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/dynamicFontSize.dart';

// class UserActivityProgressBar extends StatelessWidget {
//   final String title;
//   final double currentValue;
//   final double maxValue;
//   final Color barColor;
//
//   final double? screenWidth;
//   final double? screenHeight;
//
//   const UserActivityProgressBar({
//     super.key,
//     required this.title,
//     required this.currentValue,
//     required this.maxValue,
//     this.barColor = Colors.green,
//     this.screenWidth,
//     this.screenHeight,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final double effectiveScreenWidth = screenWidth ?? MediaQuery.of(context).size.width;
//     final double effectiveScreenHeight = screenHeight ?? MediaQuery.of(context).size.height;
//
//     double calculatedPercentage = 0;
//     if (maxValue > 0) {
//       calculatedPercentage = (currentValue / maxValue * 100).clamp(0.0, 100.0);
//     }
//
//     final String displayedProgressText = '${calculatedPercentage.toStringAsFixed(0)}%';
//
//     final double fillPercent = calculatedPercentage / 100;
//
//     final baseTextStyle = TextStyle(
//       color: Colors.white,
//       fontFamily: 'Poppins', // Ensure Poppins font is added
//       fontWeight: FontWeight.w500,
//       height: 1.6,
//     );
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset('assets/icons/loadingProgress.svg',fit: BoxFit.contain,width: 14),
//                   SizedBox(width: effectiveScreenWidth * 0.02),
//                   Text(
//                     title,
//                     style: baseTextStyle.copyWith(
//                       fontSize: getResponsiveFontSize(context, 16),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               displayedProgressText, // Show calculated percentage string
//               style: baseTextStyle.copyWith(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w400,
//                 height: 1.6,
//                 fontSize: getResponsiveFontSize(context, 12),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: effectiveScreenHeight * 0.012),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(effectiveScreenWidth * 0.02),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(effectiveScreenWidth * 0.02),
//
//             child: LinearProgressIndicator(
//
//               value: fillPercent,
//               backgroundColor: const Color(0xff1CD494).withOpacity(0.20),
//               valueColor: AlwaysStoppedAnimation<Color>(barColor),
//
//               minHeight: effectiveScreenHeight * 0.012,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }



class UserActivityProgressBar extends StatelessWidget {
  final String title;
  final double currentValue;
  final double maxValue;
  final Color barColor;

  final double? screenWidth;
  final double? screenHeight;

  const UserActivityProgressBar({
    super.key,
    required this.title,
    required this.currentValue,
    required this.maxValue,
    this.barColor = Colors.green,
    this.screenWidth,
    this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final double sw = screenWidth ?? MediaQuery.of(context).size.width;
    final double sh = screenHeight ?? MediaQuery.of(context).size.height;

    final double progressPercent = maxValue > 0 ? (currentValue / maxValue).clamp(0.0, 1.0) : 0.0;
    final String progressText = '${(progressPercent * 100).toStringAsFixed(0)}%';

    final textStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      height: 1.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/loadingProgress.svg',
                    fit: BoxFit.contain,
                    width: sw * 0.04,
                  ),
                  SizedBox(width: sw * 0.02),
                  Flexible(
                    child: Text(
                      title,
                      style: textStyle.copyWith(
                        fontSize: getResponsiveFontSize(context, 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              progressText,
              style: textStyle.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: getResponsiveFontSize(context, 12),
              ),
            ),
          ],
        ),
        SizedBox(height: sh * 0.012),
        ClipRRect(
          borderRadius: BorderRadius.circular(sw * 0.02),
          child: LinearProgressIndicator(
            value: progressPercent,
            backgroundColor: barColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: sh * 0.012,
          ),
        ),
      ],
    );
  }
}