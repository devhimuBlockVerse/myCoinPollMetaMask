import 'package:flutter/material.dart';

import 'BlockButton.dart';


 /**
 class RoadmapContainerComponent extends StatelessWidget {
  final List<String> labels;
  final String title;


  const RoadmapContainerComponent({super.key, required this.labels, required this.title});

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isPortrait = screenHeight > screenWidth;

    double baseSize = isPortrait ? screenWidth : screenHeight;

    // 🔼 Increased ratios for bigger visuals
    double widthRatio = 0.85; // wider image
    double imageWidth = screenWidth * widthRatio;
    double roadmapFrameHeight = baseSize * 0.55;
    double stackHeight = baseSize * 0.42;
    double bottomOffset = -baseSize * 0.010;
    double yearImageWidth = baseSize * 0.15;
    double yearImageHeight = baseSize * 0.15;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          width: double.infinity,

          child: Column(
            children: [
              SizedBox(
                height: stackHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: bottomOffset,
                      left: (screenWidth - imageWidth) / 2.2,
                      child: Container(
                        width: imageWidth,
                        height: roadmapFrameHeight,
                         decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icons/roadmapFrame.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.only(  left: 35.0,  top: 35),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    title,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      // fontSize: baseSize * 0.030,
                                      fontSize: screenWidth / 375  * 10,
                                      // fontSize: baseSize * 0.025,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),

                                  // Dynamic checkboxes
                                  ...labels.map(
                                        (label) => CheckboxWithLabel(
                                          containerHeight: roadmapFrameHeight * 0.7,
                                          labelText: label,
                                          isChecked: true,
                                          onChanged: (value) {},
                                    ),
                                  ),


                                ],
                              ),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: BlockButton(
                                  height: screenHeight * 0.035,
                                  width: screenWidth * 0.28,
                                  label: 'Show Other Roadmap',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: baseSize * 0.020,
                                  ),
                                  gradientColors: const [
                                    Color(0xFF2680EF),
                                    Color(0xFF1CD494),
                                  ],
                                  onTap: () {

                                  },
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                    ),

                    // Roadmap vertical line
                    Positioned(
                      left: -15,
                      top: 10,
                      child: Image.asset(
                        'assets/icons/roadMapLineXX.png',
                        width: imageWidth,
                        height: screenHeight,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Year Circular Image
                    Positioned(
                      left: -18,
                      top: 0,
                      child: Image.asset(
                        'assets/icons/yearCircular.png',
                        width: yearImageWidth,
                        height: yearImageHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

 }
**/


// class RoadmapContainerComponent extends StatelessWidget {
//   final List<String> labels;
//   final String title;
//
//   const RoadmapContainerComponent({
//     super.key,
//     required this.labels,
//     required this.title,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final baseSize = screenWidth < screenHeight ? screenWidth : screenHeight;
//
//     final imageWidth = screenWidth * 0.85;
//
//     return Row(
//        children: [
//         // Year Circular Image
//         Positioned(
//           top: 80,
//           child: Image.asset(
//             'assets/icons/yearCircular.png',
//             width: baseSize * 0.20,
//             // height: baseSize * 0.15,
//             fit: BoxFit.contain,
//           ),
//         ),
//         Flexible(
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             padding: const EdgeInsets.only(top: 20.0, left: 35, right: 20, bottom: 20),
//             width: imageWidth,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/icons/roadmapFrame.png'),
//                 fit: BoxFit.fill,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontFamily: 'Poppins',
//                     fontSize: screenWidth / 375 * 12,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//
//                 // Dynamic Labels
//                 ...labels.map(
//                       (label) => Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4.0),
//                     child: CheckboxWithLabel(
//                       labelText: label,
//                       isChecked: true,
//                       onChanged: (_) {},
//                       containerHeight: baseSize, // Use base for sizing ratio
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // Button aligned bottom-right
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: BlockButton(
//                     height: screenHeight * 0.035,
//                     width: screenWidth * 0.28,
//                     label: 'Show Other Roadmap',
//                     textStyle: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                       fontSize: baseSize * 0.020,
//                     ),
//                     gradientColors: const [
//                       Color(0xFF2680EF),
//                       Color(0xFF1CD494),
//                     ],
//                     onTap: () {},
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class RoadmapContainerComponent extends StatelessWidget {
  final List<String> labels;
  final String title;

  const RoadmapContainerComponent({
    super.key,
    required this.labels,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final baseSize = screenWidth < screenHeight ? screenWidth : screenHeight;

    final imageWidth = screenWidth * 0.80;

    return Stack(
      children: [
        // The roadmap frame container
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.only(top: 20.0, left: 35, right: 20, bottom: 20),
            width: imageWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/roadmapFrame.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: screenWidth / 375 * 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                // Dynamic Labels
                ...labels.map(
                      (label) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: CheckboxWithLabel(
                      labelText: label,
                      isChecked: true,
                      onChanged: (_) {},
                      containerHeight: baseSize,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Button aligned bottom-right
                Align(
                  alignment: Alignment.bottomRight,
                  child: BlockButton(
                    height: screenHeight * 0.035,
                    width: screenWidth * 0.28,
                    label: 'Show Other Roadmap',
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: baseSize * 0.020,
                    ),
                    gradientColors: const [
                      Color(0xFF2680EF),
                      Color(0xFF1CD494),
                    ],
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),

        // Year Circular Image positioned at top-right of the container
        Positioned(
          top: screenHeight * 0.03,
          // left: screenWidth * 0.0,
          child: Container(
            width: baseSize * 0.20,
            height: baseSize * 0.20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/icons/yearCircular.png',
                  width: baseSize * 0.18,
                   fit: BoxFit.contain,
                ),
                Text(
                  '2025', // <-- You can make this dynamic
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: baseSize * 0.04,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



// class RoadmapContainerComponent extends StatelessWidget {
//   final String title;
//   final List<String> labels;
//   final VoidCallback? onTap;
//
//   const RoadmapContainerComponent({
//     super.key,
//     required this.title,
//     required this.labels, this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final baseSize = MediaQuery.of(context).size.shortestSide;
//
//     final double widthRatio = 0.85;
//     final double imageWidth = screenWidth * widthRatio;
//     final double yearImageWidth = baseSize * 0.15;
//     final double yearImageHeight = baseSize * 0.15;
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return SizedBox(
//           width: double.infinity,
//            child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//
//               // Background image that expands with content
//               Positioned.fill(
//                 child: Image.asset(
//                   "assets/icons/roadmapFrame.png",
//                   // "assets/icons/bgRoadMapFrame.png",
//                   fit: BoxFit.fill,
//                   alignment: Alignment.topCenter,
//                 ),
//               ),
//
//
//
//               // Foreground content
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: screenWidth * 0.21,
//                   vertical: baseSize * 0.025,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                     SizedBox(height: baseSize * 0.015),
//
//                     Text(
//                       title,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'Poppins',
//                         fontSize: screenWidth / 375 * 11,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//
//                     SizedBox(height: baseSize * 0.015),
//
//                     ...labels.map(
//                           (label) => Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Icon(Icons.check_box,
//                                   size: baseSize * 0.038, color: Colors.white),
//                               SizedBox(width: baseSize * 0.015),
//                               Expanded(
//                                 child: Text(
//                                   label,
//                                   textAlign: TextAlign.start,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontFamily: 'Poppins',
//                                     fontSize: baseSize * 0.028,
//                                     height: 1.6,
//                                     fontWeight: FontWeight.w300,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                     ),
//
//                     SizedBox(height: baseSize * 0.12),
//                   ],
//                 ),
//               ),
//
//               if (onTap != null)
//                 Positioned(
//                 bottom: baseSize * 0.05,
//                 right: screenWidth * 0.04,
//                 child: BlockButton(
//                   height: screenHeight * 0.035,
//                   width: screenWidth * 0.28,
//                   label: 'Show Other Roadmap',
//                   textStyle: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                     fontSize: baseSize * 0.020,
//                   ),
//                   gradientColors: const [
//                     Color(0xFF2680EF),
//                     Color(0xFF1CD494),
//                   ],
//                   onTap: onTap,
//                 ),
//               ),
//
//              ],
//           ),
//         );
//       },
//     );
//   }
// }

class CheckboxWithLabel extends StatelessWidget {
  final String labelText;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final double containerHeight;

  const CheckboxWithLabel({
    Key? key,
    required this.labelText,
    required this.isChecked,
    required this.onChanged,
    required this.containerHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double checkboxSize = containerHeight * 0.01; // Adjust this ratio as needed
    double fontSize = containerHeight * 0.01; // Adjust this ratio for font size

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: checkboxSize,
            height: checkboxSize,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
              checkColor: Colors.black,
              activeColor: Colors.grey,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              labelText,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: fontSize,
                height: 1.4,
                fontWeight: FontWeight.w400,

              ),
              maxLines: 2,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

