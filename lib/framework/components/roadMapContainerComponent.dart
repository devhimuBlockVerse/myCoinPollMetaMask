import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'BlockButton.dart';
import 'buy_Ecm.dart';

// class RoadmapContainerComponent extends StatelessWidget {
//   final String title;
//   final List<String> labels;
//   final VoidCallback? onTap;
//   final String mapYear;
//
//   const RoadmapContainerComponent({
//     super.key,
//     required this.title,
//     required this.labels, this.onTap, required this.mapYear,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final baseSize = MediaQuery.of(context).size.shortestSide;
//
//     const double widthRatio = 0.85;
//     final double imageWidth = screenWidth * widthRatio;
//     final double yearImageWidth = baseSize * 0.21;
//     final double yearImageHeight = baseSize * 0.21;
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return SizedBox(
//           width: double.infinity,
//             child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               // Background image that expands with content
//               Positioned.fill(
//                 child: Image.asset(
//                    // "assets/icons/roadMapBox.png",
//                    "assets/icons/roadmapFrame.png",
//                   fit: BoxFit.fill,
//                   alignment: Alignment.topCenter,
//                 ),
//               ),
//
//               Positioned(
//                 top: -baseSize * 0.17,
//                 left: (screenWidth - yearImageWidth) / 2.2, // Center horizontally
//                 child: Container(
//                   width: yearImageWidth,
//                   height: yearImageHeight,
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/icons/yearCircular.png'),
//                       fit: BoxFit.fitWidth,
//                     ),
//                   ),
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(
//                       mapYear,
//                       textAlign: TextAlign.center,
//                        style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w600,
//                         fontSize: yearImageHeight * 0.25,
//                         height: 10,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Foreground content
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: screenWidth * 0.038,
//                   vertical: baseSize * 0.025,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      SizedBox(height: baseSize * 0.015),
//
//                      Text(
//                       title,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'Poppins',
//                         // fontSize: screenWidth / 375 * 11,
//                         fontSize: screenWidth / 375 * 16,
//                           fontWeight: FontWeight.w700,
//                       ),
//                     ),
//
//                      SizedBox(height: baseSize * 0.015),
//
//                      ...labels.map(
//                            (label) => Padding(
//                              padding: EdgeInsets.only(bottom: baseSize * 0.012),
//                              child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Icon(
//                                     Icons.check_box,
//                                     size: baseSize * 0.034,
//                                     color: Colors.white
//                                 ),
//                                 SizedBox(width: baseSize * 0.015),
//                                 Expanded(
//                                   child: Text(
//                                     label,
//                                     textAlign: TextAlign.start,
//                                     style: TextStyle(
//                                       color: Colors.white54,
//                                       fontFamily: 'Poppins',
//                                       fontSize: baseSize * 0.040,
//                                       height: 1.6,
//                                       fontWeight: FontWeight.w300,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                              ),
//                            ),
//                      ),
//
//                      SizedBox(height: baseSize * 0.15),
//                   ],
//                 ),
//               ),
//
//               if (onTap != null)
//                 Positioned(
//                 bottom: baseSize * 0.05,
//                 left: screenWidth * 0.04,
//                 child: BlockButtonV2(
//                   text: 'Show Other Roadmap',
//                   onPressed: onTap,
//                   height: screenHeight * 0.035,
//                   width: screenWidth * 0.28,
//                 ),
//               ),
//
//              ],
//                       ),
//         );
//       },
//     );
//   }
// }
class RoadmapContainerComponent extends StatelessWidget {
  final String title;
  final List<String> labels;
  final VoidCallback? onTap;
  final String mapYear;

  const RoadmapContainerComponent({
    super.key,
    required this.title,
    required this.labels,
    required this.mapYear,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseSize = MediaQuery.of(context).size.shortestSide;

    final double yearImageWidth = baseSize * 0.21;
    final double yearImageHeight = baseSize * 0.21;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            width: screenWidth * 0.78,
            constraints: const BoxConstraints(maxWidth: 540),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Background image
                Positioned.fill(
                  child: Image.asset(
                    "assets/icons/roadmapFrame.png",
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                  ),
                ),

                // Year badge
                Positioned(
                  top: -baseSize * 0.17,
                  left: (screenWidth * 0.78 - yearImageWidth) / 2,
                  child: Container(
                    width: yearImageWidth,
                    height: yearImageHeight,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/yearCircular.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        mapYear,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: yearImageHeight * 0.25,
                          height: 10,
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: baseSize * 0.025,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                      SizedBox(height: baseSize * 0.018),

                      Text(
                        title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: baseSize * 0.048,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: baseSize * 0.020),

                      ...labels.map(
                            (label) => Padding(
                          padding: EdgeInsets.only(bottom: baseSize * 0.012),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_box,
                                size: baseSize * 0.034,
                                color: Colors.white54,
                              ),
                              SizedBox(width: baseSize * 0.015),
                              Expanded(
                                child: Text(
                                  label,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontFamily: 'Poppins',
                                    fontSize: baseSize * 0.037,
                                    height: 1.6,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: baseSize * 0.15),
                    ],
                  ),
                ),

                if (onTap != null)
                  Positioned(
                    bottom: baseSize * 0.05,
                    left: screenWidth * 0.03,
                    child: BlockButtonV2(
                      text: 'Show Other Roadmap',
                      onPressed: onTap,
                      height: screenHeight * 0.035,
                      width: screenWidth * 0.30,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

