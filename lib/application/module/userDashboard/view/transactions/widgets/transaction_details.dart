import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';

import '../../../../../../framework/utils/status_styling_utils.dart';


class TransactionDetailsDialog extends StatelessWidget {
  const TransactionDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/icons/dialogFrame.png', // Ensure this aset exists
                  fit: BoxFit.fill,
                ),
              ),
              Padding(

                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Important for dialog content
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transactions Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getResponsiveFontSize(context, 16),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                             size: screenWidth * 0.06,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Use Expanded to make them share the available width
                        Expanded(
                          child: FullWidthInfoBox(
                            svgAssetPath: 'assets/icons/tnx_hash.svg',
                            label: 'Serial Number',
                            value: '01',
                            explicitHeight: screenHeight * 0.09,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: FullWidthInfoBox(
                            svgAssetPath: 'assets/icons/tnx_hash.svg',
                            label: 'Status',
                            statusText: 'In',
                            explicitHeight: screenHeight * 0.09,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    FullWidthInfoBox(
                      svgAssetPath: 'assets/icons/tnx_hash.svg', // Ensure asset exists
                      label: 'Txn Hash',
                      value: '0xac6d8ae0a1dcX', // Longer example
                      useSvgCopyIcon: true,
                     ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FullWidthInfoBox extends StatelessWidget {
  final String svgAssetPath;
  final String label;
  final String? value;
  final double? explicitContentPadding; // Renamed for clarity
  final bool enableCopy;
  final double? explicitSvgHeight; // Renamed
  final double? explicitSvgWidth;  // Renamed
  final bool useSvgCopyIcon;
  final double? explicitHeight; // Renamed
  final double? explicitWidth;  // Renamed
  final String? statusText;

  const FullWidthInfoBox({
    Key? key,
    required this.svgAssetPath,
    required this.label,
    this.value,
    this.explicitContentPadding,
    this.enableCopy = true,
    this.explicitSvgHeight,
    this.explicitSvgWidth,
    this.useSvgCopyIcon = false,
    this.explicitHeight,
    this.explicitWidth,
    this.statusText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {

        final screenWidth = MediaQuery.of(context).size.width;
        final availableWidth = explicitWidth ?? constraints.maxWidth;

        final double dynamicPadding = explicitContentPadding ?? availableWidth * 0.01;
        final double dynamicIconSize = explicitSvgHeight ?? availableWidth * 0.06;
        final double dynamicCopyIconSize = availableWidth * 0.04;

         assert(statusText != null || value != null, 'Either statusText or value must be provided.');

        return SizedBox(
          width: explicitWidth,
          height: explicitHeight,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/icons/bgFrame.png',
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: EdgeInsets.all(dynamicPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Wrap content vertically if no explicit height
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          svgAssetPath,
                          // height: dynamicIconSize,
                          // width: dynamicIconSize,
                          height: screenWidth * 0.03,
                          colorFilter: const ColorFilter.mode(Color(0xff7D8FA9), BlendMode.srcIn),
                        ),
                        SizedBox(width: availableWidth * 0.02),
                        Text(
                          label,
                          style: TextStyle(
                            color: const Color(0xff7D8FA9),
                            fontSize: getResponsiveFontSize(context, 12),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: availableWidth * 0.05),
                    if (statusText != null)
                      _buildStatusChip(context, statusText!, availableWidth)
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              value!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                                fontSize: getResponsiveFontSize(context, 14),
                              ),
                            ),
                          ),
                          if (enableCopy && useSvgCopyIcon && value != null)
                            Padding(
                              padding: EdgeInsets.only(left: availableWidth * 0.004),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/copyImg.svg',
                                  height: dynamicCopyIconSize,
                                  width: dynamicCopyIconSize,
                                  colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.srcIn),
                                ),
                                visualDensity: VisualDensity.compact, // Reduce IconButton padding
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: value!));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Copied to clipboard')),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(BuildContext context, String status, double availableWidth) {
    final StatusStyling statusStyle = getTransactionStatusStyling(status);

    return Container(
      margin: EdgeInsets.only(top: availableWidth * 0.01),
      padding: EdgeInsets.symmetric(
        horizontal: getResponsiveFontSize(context, 22),
        vertical: getResponsiveFontSize(context, 4),
      ),
      decoration: BoxDecoration(
        color: statusStyle.backgroundColor,
        border: Border.all(color: statusStyle.borderColor, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text( // Removed IntrinsicWidth, it can sometimes cause issues with overflow
        status,
        style: TextStyle(
          color: statusStyle.textColor,
          fontSize: getResponsiveFontSize(context, 12),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
        softWrap: false, // Keep this if you want it on one line
        overflow: TextOverflow.ellipsis, // Add ellipsis if it's too long
      ),
    );
  }
}

///
// class FullWidthInfoBox extends StatelessWidget {
//   final String svgAssetPath;
//   final String label;
//   final String value;
//   final double? contentPadding;
//   final bool enableCopy;
//   final double? svgHeight;
//   final double? svgWidth;
//   final bool useSvgCopyIcon;
//   final double? height;
//   final double? width;
//
//   const FullWidthInfoBox({
//     Key? key,
//     required this.svgAssetPath,
//     required this.label,
//     required this.value,
//     this.contentPadding,
//     this.enableCopy = true,
//     this.svgHeight,
//     this.svgWidth,
//     this.useSvgCopyIcon = false,
//     this.height,
//     this.width,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = width ?? MediaQuery.of(context).size.width;
//     final screenHeight = height ?? MediaQuery.of(context).size.height;
//
//     final padding = contentPadding ?? screenWidth * 0.03;
//     final iconSize = svgHeight ?? screenWidth * 0.03;
//      final copyIconSize = screenHeight * 0.018;
//
//     return SizedBox(
//       width: width,
//       height: height,
//       child: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/icons/bgFrame.png',
//               fit: BoxFit.fill,
//             ),
//           ),
//
//           // Foreground content
//           Container(
//             padding: EdgeInsets.all(padding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                  Row(
//                   children: [
//                     SvgPicture.asset(
//                       svgAssetPath,
//                       height: iconSize,
//                       width: svgWidth ?? iconSize,
//                       color: const Color(0xff7D8FA9),
//                     ),
//                     SizedBox(width: screenWidth * 0.01),
//                     Text(
//                       label,
//                       style: TextStyle(
//                         color: const Color(0xff7D8FA9),
//                         fontSize: getResponsiveFontSize(context, 12),
//                         fontWeight: FontWeight.w400,//regular
//                         fontFamily: 'Poppins',
//                         height: 1.6,
//                       ),
//                     ),
//                   ],
//                 ),
//                  Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Flexible(
//                       child: Text(
//                         value,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: 'Poppins',
//                           height: 1.6,
//                           fontSize: getResponsiveFontSize(context, 14),
//                         ),
//                       ),
//                     ),
//                     if (enableCopy && useSvgCopyIcon)
//                       IconButton(
//                         icon: SvgPicture.asset(
//                           'assets/icons/copyImg.svg',
//                           height: copyIconSize,
//                           width: copyIconSize,
//                           color: Colors.white.withOpacity(0.8),
//                         ),
//                         onPressed: () {
//                           Clipboard.setData(ClipboardData(text: value));
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('Copied to clipboard')),
//                           );
//                         },
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






