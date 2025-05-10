import 'package:flutter/material.dart';


// class CardNewsComponent extends StatelessWidget {
//   final String imageUrl;
//   final String source;
//   final String timeAgo;
//   final String headline;
//
//   const CardNewsComponent({
//     Key? key,
//     required this.imageUrl,
//     required this.source,
//     required this.timeAgo,
//     required this.headline,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 327,
//       height: 188,
//       clipBehavior: Clip.antiAlias,
//       decoration: const BoxDecoration(),
//       child: Stack(
//         children: [
//           // Background image
//           Positioned(
//             left: 0,
//             top: 0,
//             child: Container(
//               width: 327,
//               height: 156,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                   image: AssetImage(imageUrl),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//
//           // News card overlay
//           Positioned(
//             left: 24,
//             top: 80,
//             child: Container(
//               width: 279,
//               height: 108,
//               decoration: BoxDecoration(
//                 color: const Color(0xF2040C16),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Source and time
//                   Row(
//                     children: [
//                       Text(
//                         source,
//                         style: const TextStyle(
//                           color: Color(0xFF5CA4FF),
//                           fontSize: 14,
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         timeAgo,
//                         style: const TextStyle(
//                           color: Color(0xFF77798D),
//                           fontSize: 12,
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   // Headline
//                   Text(
//                     headline,
//                     style: const TextStyle(
//                       color: Color(0xFFFFF5ED),
//                       fontSize: 14,
//                       fontFamily: 'Poppins',
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CardNewsComponent extends StatelessWidget {
  final String imageUrl;
  final String source;
  final String timeAgo;
  final String headline;

  const CardNewsComponent({
    Key? key,
    required this.imageUrl,
    required this.source,
    required this.timeAgo,
    required this.headline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.9;
    final imageHeight = containerWidth * 0.48;
    final overlayTopOffset = imageHeight * 0.5;
    final overlayHeight = imageHeight * 0.7;

    return Container(
      width: containerWidth,
      height: imageHeight + overlayHeight * 0.6,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: Stack(
        children: [
          // Background image
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: containerWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // News card overlay
          Positioned(
            left: screenWidth * 0.05,
            top: overlayTopOffset,
            child: Container(
              width: containerWidth - screenWidth * 0.1,
              height: overlayHeight,
              decoration: BoxDecoration(
                color: const Color(0xF2040C16),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: containerWidth * 0.05,
                vertical: overlayHeight * 0.15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and time
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          source,
                          style: TextStyle(
                            color: const Color(0xFF5CA4FF),
                            fontSize: containerWidth * 0.04,
                            fontFamily: 'Poppins',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: const Color(0xFF77798D),
                          fontSize: containerWidth * 0.035,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Headline
                  Text(
                    headline,
                    style: TextStyle(
                      color: const Color(0xFFFFF5ED),
                      fontSize: containerWidth * 0.04,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
