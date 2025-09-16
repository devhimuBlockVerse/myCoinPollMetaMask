import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/customToastMessage.dart';
import '../utils/dynamicFontSize.dart';
import '../utils/enums/toast_type.dart';
import 'buy_Ecm.dart';

// class ClaimHistoryCard extends StatelessWidget {
//   final String amount;           // e.g. "ECM 258.665"
//   final String dateTime;         // e.g. "06 Nov 2025 21:30:48"
//   final String walletAddress;    // e.g. "0x9a6f...7bc1"
//   final String buttonLabel;      // e.g. "Explore"
//   final VoidCallback onButtonTap; // button click handler
//
//   const ClaimHistoryCard({
//     super.key,
//     required this.amount,
//     required this.dateTime,
//     required this.walletAddress,
//     this.buttonLabel = "Explore",
//     required this.onButtonTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Container(
//       width: screenWidth,
//       padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
//       decoration: ShapeDecoration(
//         shape: RoundedRectangleBorder(
//           side: BorderSide(
//             width: 0.50,
//             color: Colors.white.withOpacity(0.2),
//           ),
//           borderRadius: BorderRadius.circular(5),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Top Row: Amount + Date
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 amount,
//                 style:  TextStyle(
//                   color: Colors.white,
//                   fontSize: getResponsiveFontSize(context, 14),
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.access_time, size: screenHeight * 0.025, color: Colors.white70),
//                   Text(
//                     dateTime,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.8),
//                       fontSize: getResponsiveFontSize(context, 12),
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           SizedBox(height: screenHeight * 0.01),
//
//           /// Bottom Row: Wallet + Button
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     "${walletAddress.substring(0, 6)}...${walletAddress.substring(walletAddress.length - 4)}",
//                     style:  TextStyle(
//                       color: Color(0xFF7D8FA9),
//                       fontSize: getResponsiveFontSize(context, 12),
//                       fontFamily: 'Poppins',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   SizedBox(width: screenWidth * 0.01),
//                   GestureDetector(
//                     onTap: () async {
//                       await Clipboard.setData(ClipboardData(text: walletAddress)); // Replace with your address variable
//                       ToastMessage.show(
//                           message: 'Address copied to clipboard',
//                           type: MessageType.success);
//                     },
//                     child:  Icon(Icons.file_copy_rounded, size: screenHeight * 0.025, color: Color(0XFF7D8FA9)),
//                   ),
//                 ],
//               ),
//
//               BlockButtonV2(
//                 text: 'Explore',
//                 onPressed: onButtonTap,
//                 height: screenHeight * 0.045,
//                 width: screenWidth * 0.25,
//                 leadingImagePath: "assets/icons/arrowIcon.svg",
//
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }




class ClaimHistoryCard extends StatelessWidget {
  final String amount;           // e.g. "ECM 258.665"
  final String dateTime;         // e.g. "06 Nov 2025 21:30:48"
  final String walletAddress;    // e.g. "0x9a6f...7bc1"
  final String buttonLabel;      // e.g. "Explore"
  final VoidCallback onButtonTap; // button click handler

  const ClaimHistoryCard({
    super.key,
    required this.amount,
    required this.dateTime,
    required this.walletAddress,
    this.buttonLabel = "Explore",
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate available width accounting for padding (3% horizontal padding on each side)
    final paddingTotal = screenWidth * 0.06; // 3% left + 3% right
    final availableWidth = screenWidth - paddingTotal;

    return Container(
      constraints: BoxConstraints(
        maxWidth: availableWidth, // Constrain to available space after padding
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.01,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.50,
            color: Colors.white.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row: Amount + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(context, 14),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded( // Allow the date row to take available space
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: screenWidth * 0.15),

                    Icon(
                      Icons.access_time,
                      size: screenHeight * 0.025,
                      color: Colors.white70,
                    ),
                    // SizedBox(width: screenWidth * 0.01),
                    Flexible( // Flexible for text overflow
                      child: Text(
                        dateTime,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: getResponsiveFontSize(context, 12),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.01),

          /// Bottom Row: Wallet + Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded( // Expanded for dynamic width
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible( // Flexible for wallet text
                      child: Text(
                        "${walletAddress.substring(0, 6)}...${walletAddress.substring(walletAddress.length - 4)}",
                        style: TextStyle(
                          color: Color(0xFF7D8FA9),
                          fontSize: getResponsiveFontSize(context, 12),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: walletAddress));
                        ToastMessage.show(
                          message: 'Address copied to clipboard',
                          type: MessageType.success,
                        );
                      },
                      child: Icon(
                        Icons.file_copy_rounded,
                        size: screenHeight * 0.025,
                        color: Color(0xFF7D8FA9),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth * 0.22, // Reduced to 0.22 for more space
                child: BlockButtonV2(
                  text: buttonLabel,
                  onPressed: onButtonTap,
                  height: screenHeight * 0.045,
                  leadingImagePath: "assets/icons/arrowIcon.svg",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}