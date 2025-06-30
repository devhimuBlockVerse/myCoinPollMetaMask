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
//     required this.maxECM, required this.stageIndex,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // final progress = currentECM / maxECM;
//     final progress = (maxECM > 0) ? (currentECM / maxECM) : 0.0;
//
//     final percentage = (progress * 100).toStringAsFixed(1);
//
//      final size = MediaQuery.of(context).size;
//     final isPortrait = size.height > size.width;
//
//      final width = size.width;
//     final height = size.height;
//     final textScale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
//     // final containerHeight = (isPortrait ? height * 0.03 : height * 0.05).clamp(6.0, 20.0);
//     final containerHeight = (isPortrait ? height * 0.015 : height * 0.025).clamp(6.0, 20.0);
//
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
//                  child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     'Stage $stageIndex: ${currentECM.toStringAsFixed(4)} ECM',
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       // fontSize: 12 * textScale,
//                       fontSize: getResponsiveFontSize(context, 14),
//                       color: Colors.white,
//                       height: 1.0,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                 ),
//               ),
//                // SizedBox(width: 90,),
//               Flexible(
//                  child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     'Max: ${maxECM.toStringAsFixed(1)} ECM',
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.end,
//                     style: TextStyle(
//                       // fontSize: 12 * textScale,
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
//             alignment: Alignment.centerLeft,
//
//             children: [
//               Container(
//                 height: containerHeight,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white12,
//                   borderRadius: BorderRadius.circular(containerHeight / 2),
//                 ),
//               ),
//               // FractionallySizedBox(
//               //   widthFactor: progress.clamp(0.0, 1.0),
//               //   child: Container(
//               //     height: containerHeight,
//               //     decoration: BoxDecoration(
//               //       gradient: const LinearGradient(
//               //         colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
//               //         begin: Alignment.centerLeft,
//               //         end: Alignment.centerRight,
//               //       ),
//               //       borderRadius: BorderRadius.circular(containerHeight / 2),
//               //     ),
//               //     child: Padding(
//               //       padding: const EdgeInsets.symmetric(horizontal: 8),
//               //       child: Text(
//               //         '$percentage%',
//               //         style: TextStyle(
//               //           color: Colors.white,
//               //           fontWeight: FontWeight.bold,
//               //           // fontSize: 12 * textScale,
//               //           fontSize: getResponsiveFontSize(context, 13),
//               //
//               //           fontFamily: 'Poppins',
//               //         ),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//
//               FractionallySizedBox(
//                 widthFactor: progress.clamp(0.0, 1.0),
//                 child: Container(
//                   height: containerHeight,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                     ),
//                     borderRadius: BorderRadius.circular(containerHeight / 2),
//                   ),
//                   child:progress >= 0.1 ? Center(
//                     child: Text(
//                       '$percentage%',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         // fontSize: 12 * textScale,
//                         fontSize: getResponsiveFontSize(context, 13),
//                         fontFamily: 'Poppins',
//                       ),
//                       textAlign: TextAlign.end,
//                     ),
//                   ): null,
//                 ),
//               ),
//               if (progress < 0.1)
//                 Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Text(
//                   '$percentage%',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     // fontSize: 12 * textScale,
//                     fontSize: getResponsiveFontSize(context, 13),
//
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
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
    required this.currentECM,
    required this.maxECM,
    required this.stageIndex,
  });

  @override
  Widget build(BuildContext context) {
     final progress = (maxECM > 0) ? (currentECM / maxECM).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).toStringAsFixed(1);

    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

    final width = size.width;
    final height = size.height;
    final containerHeight = (isPortrait ? height * 0.016 : height * 0.025).clamp(6.0, 20.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Stage $stageIndex: ${currentECM.toStringAsFixed(4)} ECM',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 14),
                      color: Colors.white,
                      height: 1.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Max: ${maxECM.toStringAsFixed(1)} ECM',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 14),
                      color: Colors.white,
                      height: 1.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          // Progress bar
          Stack(
            children: [
              // Background of the progress bar
              Container(
                height: containerHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(containerHeight / 2),
                ),
              ),

              // Use LayoutBuilder to get the max width and enforce a minimum progress width
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final progressWidth = maxWidth * progress;
                  final textFontSize = getResponsiveFontSize(context, 13);
                  final minWidth = textFontSize * 3.5;
                  final finalWidth = progress > 0 ? max(minWidth, progressWidth).toDouble() : 0.0;

                  return Container(

                    height: containerHeight,
                    width: finalWidth,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(containerHeight / 2),
                    ),
                    // Align the text inside this container
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '$percentage%',
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: textFontSize,
                            fontFamily: 'Poppins',
                          ),
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