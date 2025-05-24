import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';


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
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/icons/dialogFrame.png',
                  fit: BoxFit.fill,
                ),
              ),

              // Foreground content
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
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

                    // Info box
                    FullWidthInfoBox(
                      svgAssetPath: 'assets/icons/tnx_hash.svg',
                      label: 'Txn Hash',
                      value: '0xac6d8ae0a1dcX',
                      useSvgCopyIcon: true,
                      // height: 120,
                      // width: 300,
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
  final String value;
  final double? contentPadding;
  final bool enableCopy;
  final double? svgHeight;
  final double? svgWidth;
  final bool useSvgCopyIcon;
  final double? height;
  final double? width;

  const FullWidthInfoBox({
    Key? key,
    required this.svgAssetPath,
    required this.label,
    required this.value,
    this.contentPadding,
    this.enableCopy = true,
    this.svgHeight,
    this.svgWidth,
    this.useSvgCopyIcon = false,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = width ?? MediaQuery.of(context).size.width;
    final screenHeight = height ?? MediaQuery.of(context).size.height;

    final padding = contentPadding ?? screenWidth * 0.03;
    final iconSize = svgHeight ?? screenWidth * 0.03;
     final copyIconSize = screenHeight * 0.018;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/icons/bgFrame.png',
              fit: BoxFit.fill,
            ),
          ),

          // Foreground content
          Container(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Row(
                  children: [
                    SvgPicture.asset(
                      svgAssetPath,
                      height: iconSize,
                      width: svgWidth ?? iconSize,
                      color: const Color(0xff7D8FA9),
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Text(
                      label,
                      style: TextStyle(
                        color: const Color(0xff7D8FA9),
                        fontSize: getResponsiveFontSize(context, 12),
                        fontWeight: FontWeight.w400,//regular
                        fontFamily: 'Poppins',
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          height: 1.6,
                          fontSize: getResponsiveFontSize(context, 14),
                        ),
                      ),
                    ),
                    if (enableCopy && useSvgCopyIcon)
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/copyImg.svg',
                          height: copyIconSize,
                          width: copyIconSize,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: value));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied to clipboard')),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






