import 'package:flutter/material.dart';

import 'dart:ui';

// class CustomDialog extends StatelessWidget {
//   final List<String> items;
//   final String title;
//   final String subtitle;
//
//   const CustomDialog({
//     super.key,
//     required this.items,
//     required this.title,
//     required this.subtitle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.of(context).pop(), // Close when tapped outside
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Stack(
//           children: [
//             // Background blur
//             BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//               child: Container(color: Colors.transparent),
//             ),
//
//             // Center Dialog
//             Center(
//               child: GestureDetector(
//                 onTap: () {}, // Prevent dismiss when tapping dialog
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//                   decoration: BoxDecoration(
//                     image: const DecorationImage(
//                       image: AssetImage('assets/icons/dialogBg.png'),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(20.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Title Row
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               title,
//                               style: TextStyle(
//                                 color: const Color(0xFFFFF5ED),
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: getResponsiveFontSize(context, 14),
//                                 height: 1.3,
//                               ),
//                             ),
//                             Text(
//                               subtitle,
//                               style: TextStyle(
//                                 color: const Color(0xFFFFF5ED),
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: getResponsiveFontSize(context, 14),
//                                 height: 1.3,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         // Items
//                         ...items.asMap().entries.map((entry) {
//                           int index = entry.key;
//                           String item = entry.value;
//                           IconData icon = index < 7 ? Icons.check : Icons.timer;
//                           return _buildItem(context, icon, item);
//                         }).toList(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildItem(BuildContext context, IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.white, size: 16),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: const Color(0xFFFFF5ED),
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w400,
//                 fontSize: getResponsiveFontSize(context, 10),
//                 height: 1.6,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   double getResponsiveFontSize(BuildContext context, double baseFontSize) {
//     double scaleFactor = MediaQuery.of(context).textScaleFactor;
//     double screenWidth = MediaQuery.of(context).size.width;
//     return (baseFontSize * (screenWidth / 375)) * scaleFactor;
//   }
// }


import 'dart:ui';
import 'package:flutter/material.dart';

import '../../application/domain/model/DialogModel.dart';

class CustomDialog extends StatelessWidget {
  final List<DialogItem> items;
  final String title;
  final String subtitle;

  const CustomDialog({
    super.key,
    required this.items,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(), // Close when tapped outside
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Background blur
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(color: Colors.transparent),
            ),

            // Center Dialog
            Center(
              child: GestureDetector(
                onTap: () {}, // Prevent dismiss when tapping dialog
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/dialogBg.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: const Color(0xFFFFF5ED),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: getResponsiveFontSize(context, 14),
                                height: 1.3,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: const Color(0xFFFFF5ED),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: getResponsiveFontSize(context, 14),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Dynamic Items
                        ...items.map((item) => _buildItem(context, item.icon, item.text)).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xFFFFF5ED),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: getResponsiveFontSize(context, 10),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    double screenWidth = MediaQuery.of(context).size.width;
    return (baseFontSize * (screenWidth / 375)) * scaleFactor;
  }
}
