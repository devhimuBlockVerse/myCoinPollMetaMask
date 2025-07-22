import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'dart:math';

// class ECMProgressIndicator extends StatelessWidget {
//   final int stageIndex;
//   final double currentECM;
//   final double maxECM;
//
//   const ECMProgressIndicator({
//     super.key,
//     required this.currentECM,
//     required this.maxECM,
//     required this.stageIndex,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//      final progress = (maxECM > 0) ? (currentECM / maxECM).clamp(0.0, 1.0) : 0.0;
//     final percentage = (progress * 100).toStringAsFixed(1);
//
//     final size = MediaQuery.of(context).size;
//     final isPortrait = size.height > size.width;
//
//     final width = size.width;
//     final height = size.height;
//     final containerHeight = (isPortrait ? height * 0.017 : height * 0.025).clamp(6.0, 20.0);
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: width * 0.04),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Flexible(
//                 child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     'Stage $stageIndex: ${currentECM.toStringAsFixed(4)} ECM',
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       fontSize: getResponsiveFontSize(context, 14),
//                       color: Colors.white,
//                       height: 1.0,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                 ),
//               ),
//               Flexible(
//                 child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     'Max: ${maxECM.toStringAsFixed(1)} ECM',
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.end,
//                     style: TextStyle(
//                       fontSize: getResponsiveFontSize(context, 14),
//                       color: Colors.white,
//                       height: 1.0,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: height * 0.01),
//           // Progress bar
//           Stack(
//             children: [
//                Container(
//                 height: containerHeight,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white12,
//                   borderRadius: BorderRadius.circular(containerHeight / 2),
//                 ),
//               ),
//
//                LayoutBuilder(
//                 builder: (context, constraints) {
//                   final maxWidth = constraints.maxWidth;
//                   final progressWidth = maxWidth * progress;
//                   final textFontSize = getResponsiveFontSize(context, 12);
//                   final minWidth = textFontSize * 3.8;
//                    final finalWidth = progress > 0 ? max(minWidth, progressWidth).toDouble() : 0.0;
//
//                   return Container(
//
//                     height: containerHeight,
//                     width: finalWidth,
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                       borderRadius: BorderRadius.circular(containerHeight / 2),
//                     ),
//                     child: Center(
//                        child: Transform.translate(
//                          offset: const Offset(0, -0.9),
//                          child: Text(
//                           '$percentage%',
//                           maxLines: 1,
//                           overflow: TextOverflow.clip,
//                           textAlign: TextAlign.end,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: textFontSize,
//                             fontFamily: 'Poppins',
//                           ),
//                          ),
//                        ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
class ECMProgressIndicator extends StatelessWidget {
  final int stageIndex;
  final double currentECM;
  final double maxECM;

  const ECMProgressIndicator({
    super.key,
    required this.stageIndex,
    required this.currentECM,
    required this.maxECM,
  });

  // @override
  // Widget build(BuildContext context) {
  //   final size = MediaQuery.of(context).size;
  //   final isPortrait = size.height > size.width;
  //   final containerHeight = (isPortrait ? size.height * 0.017 : size.height * 0.025).clamp(20.0, 20.0);
  //   // final containerHeight = (isPortrait ? size.height * 0.017 : size.height * 0.025).clamp(28.0, 28.0);
  //
  //   final progress = (maxECM > 0) ? (currentECM / maxECM).clamp(0.0, 1.0) : 0.0;
  //   final percentage = (progress * 100).toStringAsFixed(1);
  //   final textFontSize = getResponsiveFontSize(context, 14);
  //
  //   TextStyle infoStyle = TextStyle(
  //     fontSize: textFontSize,
  //     color: Colors.white,
  //     height: 1.0,
  //     fontWeight: FontWeight.w400,
  //     fontFamily: 'Poppins',
  //   );
  //
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Top row with ECM values
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Flexible(
  //               child: Text(
  //                 'Stage $stageIndex: ${currentECM.toStringAsFixed(4)} ECM',
  //                 overflow: TextOverflow.ellipsis,
  //                 style: infoStyle,
  //               ),
  //             ),
  //             SizedBox(width: 8),
  //             Flexible(
  //               child: Text(
  //                 'Max: ${maxECM.toStringAsFixed(1)} ECM',
  //                 overflow: TextOverflow.ellipsis,
  //                 textAlign: TextAlign.end,
  //                 style: infoStyle,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: size.height * 0.01),
  //
  //         // Progress bar
  //         Stack(
  //           children: [
  //             Container(
  //               height: containerHeight,
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                 color: Colors.white12,
  //                 borderRadius: BorderRadius.circular(containerHeight / 2),
  //               ),
  //             ),
  //             LayoutBuilder(
  //               builder: (context, constraints) {
  //                 final progressWidth = (constraints.maxWidth * progress).clamp(0.0, constraints.maxWidth);
  //                 final minWidth = getResponsiveFontSize(context, 12) * 3.8;
  //                 final barWidth = progress > 0 ? max(minWidth, progressWidth) : 0.0;
  //
  //                 return Container(
  //                   height: containerHeight,
  //                   width: barWidth,
  //                   decoration: BoxDecoration(
  //                     gradient: const LinearGradient(
  //                       colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
  //                       begin: Alignment.centerLeft,
  //                       end: Alignment.centerRight,
  //                     ),
  //                     borderRadius: BorderRadius.circular(containerHeight / 2),
  //                   ),
  //                   child: Center(
  //                     child: Text(
  //                       '$percentage%',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: getResponsiveFontSize(context, 10),
  //                         fontFamily: 'Poppins',
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;
    final screenShortestSide = size.longestSide;

    final containerHeight = screenShortestSide * 0.019;
    final progress = (maxECM > 0) ? (currentECM / maxECM).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).toStringAsFixed(1);
    final textFontSize = getResponsiveFontSize(context, 14);

    TextStyle infoStyle = TextStyle(
      fontSize: textFontSize,
      color: Colors.white,
      height: 1.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'Poppins',
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ECM Info Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Stage $stageIndex: ${currentECM.toStringAsFixed(4)} ECM',
                  overflow: TextOverflow.ellipsis,
                  style: infoStyle,
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Max: ${maxECM.toStringAsFixed(1)} ECM',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: infoStyle,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),

          /// Progress Bar
          Stack(
            children: [
              /// Background
              Container(
                height: containerHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(containerHeight / 2),
                ),
              ),

              /// Filled Progress
              LayoutBuilder(
                builder: (context, constraints) {
                  final progressWidth = (constraints.maxWidth * progress).clamp(0.0, constraints.maxWidth);
                  final minWidth = getResponsiveFontSize(context, 12) * 3.8;
                  final barWidth = progress > 0 ? max(minWidth, progressWidth) : 0.0;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: containerHeight,
                    width: barWidth,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(containerHeight / 2),
                    ),
                    child: Center(
                      child: Text(
                        '$percentage%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: getResponsiveFontSize(context, 9),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}


