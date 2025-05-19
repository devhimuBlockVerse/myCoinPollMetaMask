import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/wallet_view_model.dart';
import 'package:provider/provider.dart';

import '../../../framework/components/AddressFieldComponent.dart';
import '../../../framework/components/BlockButton.dart';
import '../../../framework/components/walletAddressComponent.dart';
import '../../../framework/utils/dynamicFontSize.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {



  @override
  void initState() {
    super.initState();
    _setGreeting();


  }




  String greeting = "";

  void _setGreeting() {
    final hour = DateTime.now().hour;
    greeting = hour >= 5 && hour < 12
        ? "Good Morning"
        : hour >= 12 && hour < 17
        ? "Good Afternoon"
        : hour >= 17 && hour < 21
        ? "Good Evening"
        : "Good Night";
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    // Dynamic multipliers
    final baseSize = isPortrait ? screenWidth : screenHeight;
    return Scaffold(

      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
             image: DecorationImage(
               image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  /// User Name Data & Wallet Address
                  _headerSection(),
                  SizedBox(height: screenHeight * 0.03),



                  _EcmWithGraphChart(),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff040C16),
                    borderRadius: BorderRadius.circular(12)
                    ),

                    child: ClipRRect(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CustomLabeledInputField(
                        labelText: 'Referral Link:',
                        hintText: ' https://mycoinpoll.com?ref=125482458661',
                         isReadOnly: true,
                        trailingIconAsset: 'assets/icons/copyImg.svg',
                        onTrailingIconTap: () {
                          debugPrint('Trailing icon tapped');
                        },
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _headerSection(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    // Dynamic multipliers
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Consumer<WalletViewModel>(
    builder: (context, model, _){
     return   Container(
       width: double.infinity,
       decoration: BoxDecoration(
         color: Colors.transparent.withOpacity(0.1),
       ),
       child: ClipRRect(
         child: BackdropFilter(
           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
           child: Padding(
             padding: EdgeInsets.symmetric(
               horizontal: screenWidth * 0.03,
               vertical: screenHeight * 0.015,
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 /// User Info & Ro Text + Notification
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       "$greeting",
                       style: TextStyle(
                         fontFamily: 'Poppins',
                         fontWeight: FontWeight.w400,
                         fontSize: getResponsiveFontSize(context, 14),
                         height: 1.6,
                         color: Color(0xffFFF5ED),
                       ),
                     ),
                     Text(
                       'Ro', // your Ro text
                       style: TextStyle(
                         fontFamily: 'Poppins',
                         fontWeight: FontWeight.w600,
                         fontSize: getResponsiveFontSize(context, 18),
                         height: 1.3,
                         color: Color(0xffFFF5ED),
                       ),
                     ),
                     SizedBox(width: 8),

                   ],
                 ),

                 /// Wallet Address
                 Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                     Transform.translate(
                       offset: Offset(screenWidth * 0.025, 0),
                       child:  WalletAddressComponent(
                         // address: formatAddress(model.walletAddress),
                         address: "0xe2...e094",
                       ),
                     ),

                     GestureDetector(
                       onTap: (){},
                       child: SvgPicture.asset(
                         'assets/icons/nofitication.svg',
                         height: getResponsiveFontSize(context, 24),
                       ),
                     ),
                   ],
                 ),
               ],
             ),
           ),
         ),
       ),
     );
    });

  }


  // Widget _EcmWithGraphChart(){
  //
  //   double screenWidth = MediaQuery.of(context).size.width;
  //   double screenHeight = MediaQuery.of(context).size.height;
  //   final isPortrait = screenHeight > screenWidth;
  //
  //   // Dynamic multipliers
  //   final baseSize = isPortrait ? screenWidth : screenHeight;
  //
  //   return Container(
  //     width: screenWidth,
  //     height: screenHeight * 0.16,
  //     // height: screenHeight * 0.30,
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //           color: Colors.transparent
  //       ),
  //       image:const DecorationImage(
  //         image: AssetImage('assets/icons/applyForListingBG.png'),
  //         fit: BoxFit.fill,
  //       ),
  //     ),
  //     child: Stack(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: screenWidth * 0.035,
  //             vertical: screenHeight * 0.015,
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Blockchain Innovation \nLaunchpad Hub',
  //                 style: TextStyle(
  //                   color: Color(0xFFFFF5ED),
  //                   fontFamily: 'Poppins',
  //                   fontSize: screenWidth * 0.04,
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //                 maxLines: 2,
  //               ),
  //               // SizedBox(height: screenHeight * 0.01), // Make this smaller the Space)
  //
  //               /// Badge Icons
  //               Padding(
  //                 padding:  EdgeInsets.only(left: screenWidth * 0.010, top: screenHeight * 0.020),
  //                 child:Text('Show Badge Icons',style: TextStyle(color: Colors.white),),
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         Align(
  //           alignment: Alignment.bottomRight,
  //           child: Padding(
  //             padding: EdgeInsets.only(left: screenWidth * 0.02),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //                children: [
  //
  //
  //                  // Frame1413372135(),
  //                  ResponsiveBadge(
  //                    label: 'Verified',
  //                    iconPath: 'assets/icons/check.svg',
  //
  //                  ),
  //
  //
  //
  //
  //                  Flexible(
  //                   child: Image.asset(
  //                     'assets/icons/staticChart.png',
  //                       width: screenWidth * 0.34,
  //                        // height: screenHeight * 0.08,
  //                        fit: BoxFit.contain,
  //
  //                   ),
  //                 ),
  //                  SizedBox(height: screenHeight * 0.04),
  //                  RichText(
  //                   text:  TextSpan(
  //                     text: 'Today up to ',
  //                     style: TextStyle(
  //                         fontFamily: 'Poppins',
  //                         fontWeight: FontWeight.normal,
  //                         color: Colors.grey, fontSize: getResponsiveFontSize(context, 10)),
  //                     children: <TextSpan>[
  //                       TextSpan(
  //                         text: '+5.34%',
  //                         style: TextStyle(color: Color(0xFF29FFA5),  fontFamily: 'Poppins',
  //                           fontWeight: FontWeight.normal,
  //                           fontSize: getResponsiveFontSize(context, 10),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                ],
  //             )
  //
  //           ),
  //         ),
  //
  //
  //       ],
  //     )
  //   );
  // }


  Widget _EcmWithGraphChart(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // final isPortrait = screenHeight > screenWidth; // baseSize is not used in this widget
    // final baseSize = isPortrait ? screenWidth : screenHeight;

    return Container(
        width: screenWidth,
        height: screenHeight * 0.16,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.transparent // This border seems unnecessary with background image
          ),
          image: const DecorationImage(
            image: AssetImage('assets/icons/applyForListingBG.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack( // Keep Stack to layer content over the background image
          children: [
            // Use a Row to distribute horizontal space between left and right content
            Padding( // Apply padding once to the Row for spacing from container edges
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.035,
                vertical: screenHeight * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out left and right
                crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the content in the Row
                children: [
                  // Left Content: Text
                  Expanded( // Allows the left column to take available space
                    flex: 2, // Give more flex to the left text if needed, adjust as required
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Vertically center text in its column
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Blockchain Innovation \nLaunchpad Hub',
                          style: TextStyle(
                            color: Color(0xFFFFF5ED),
                            fontFamily: 'Poppins',
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis, // Prevent text overflow
                        ),
                        SizedBox(height: screenHeight * 0.01), // Space below text

                        /// Badge Icons (assuming this is related to the left text)
                        // Note: The original code had Badge Icons under the Align (right side)
                        // Placing it here as it's under the left text column in the original Column structure
                        // If it belongs on the right, move this Padding block to the right Column
                        Padding(
                          padding:  EdgeInsets.only(left: screenWidth * 0.00), // Adjusted padding
                          child:Text('Show Badge Icons',style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.025),), // Added font size
                        ),
                      ],
                    ),
                  ),

                  // Right Content: Badge, Chart Image, RichText
                  Expanded( // Allows the right column to take available space
                    flex: 1, // Give less flex to the right content, adjust as required
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Badge
                        ResponsiveBadge(
                          label: 'Level-1',
                          iconPath: 'assets/icons/check.svg',
                        ),
                        // SizedBox(height: screenHeight * 0.015), // Small space between badge and chart

                         Image.asset(
                          'assets/icons/staticChart.png',
                          width: screenWidth * 0.48 ,
                          height: screenHeight * 0.08,
                          fit: BoxFit.contain,
                        ),
                        // SizedBox(height: screenHeight * 0.005),

                         RichText(
                          text:  TextSpan(
                            text: 'Today up to ',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                color: Colors.grey, fontSize: getResponsiveFontSize(context, 10)),
                            children: <TextSpan>[
                              TextSpan(
                                text: '+5.34%', // This text will be dynamically updated by the RealtimeChart widget
                                style: TextStyle(color: Color(0xFF29FFA5),  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal,
                                  fontSize: getResponsiveFontSize(context, 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
                ],
        )
    );
  }

}



class ResponsiveBadge extends StatelessWidget {
  final String label;
  final String iconPath;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double? widthFactor;
  final double? heightFactor;

  const ResponsiveBadge({
    Key? key,
    required this.label,
    required this.iconPath,
    this.backgroundColor = const Color(0xCC1CD691),
    this.borderColor = const Color.fromRGBO(255, 255, 255, 0.7),
    this.textColor = Colors.white,
    this.widthFactor,
    this.heightFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final containerWidth = widthFactor ?? baseSize * 0.18;
    final containerHeight = heightFactor ?? baseSize * 0.06;
    final horizontalPadding = baseSize * 0.013;
    final verticalPadding = baseSize * 0.005;
    final borderWidth = 0.51;
    final iconSize = baseSize * 0.04;
    final spacingBetweenIconAndText = baseSize * 0.008;
     final textHeight = 1.1;

    return Container(
      width: containerWidth,
      height: containerHeight,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
          ),
          SizedBox(width: spacingBetweenIconAndText),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: getResponsiveFontSize(context, 10),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: textHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
