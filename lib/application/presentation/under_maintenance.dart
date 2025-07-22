import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/bottom_nav_provider.dart';
import 'package:provider/provider.dart';

import '../../framework/components/BlockButton.dart';
import '../../framework/utils/dynamicFontSize.dart';
 import 'viewmodel/countdown_provider.dart';

class UnderMaintenance extends StatelessWidget {
  const UnderMaintenance({super.key});


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const baseWidth = 375.0;
    const baseHeight = 812.0;

    double scaleWidth(double size) => size * screenWidth / baseWidth;
    double scaleHeight(double size) => size * screenHeight / baseHeight;
    double scaleText(double size) => size * screenWidth / baseWidth;


    return SafeArea(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
           color: Color(0xFF01090B),
          image: DecorationImage(
            image: AssetImage('assets/images/starGradientBg.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topRight,
            filterQuality: FilterQuality.medium,

          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Center(
            child: Container(
              width: scaleWidth(320),
              padding: EdgeInsets.all(scaleWidth(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(scaleWidth(12)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image with transparent background
                  Container(
                    width: double.infinity,
                    height: scaleHeight(300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(scaleWidth(10)),
                    ),
                    child: Image.asset(
                      'assets/images/underMaintainance.png',
                      fit: BoxFit.contain,

                    ),
                  ),
                  SizedBox(height: scaleHeight(20)),

                  // Maintenance message
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Under Maintenance',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: scaleText(26),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: scaleHeight(15)),
                      Text(
                        'Scheduled updates in progress.\nWe\'ll be back soon — thanks for your patience.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: scaleText(12),
                          fontFamily: 'Poppins',
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: scaleHeight(30)),

                  // Countdown timer row with overflow fix
                  _MaintenanceCountdownTimer(
                    scaleWidth: scaleWidth,
                    scaleHeight: scaleHeight,
                    scaleText: scaleText,
                  ),

                  SizedBox(height: scaleHeight(30)),
                  BlockButton(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.5,
                    label: 'Go Back to Home',
                    textStyle:  TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                       fontSize: getResponsiveFontSize(context, 15),
                      height: 1.6,
                    ),
                    gradientColors: const [
                      Color(0xFF2680EF),
                      Color(0xFF1CD494)
                      // 1CD494
                    ],
                    onTap: () {
                      Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    iconPath: 'assets/icons/arrowIcon.svg',
                    iconSize : screenHeight * 0.013,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MaintenanceCountdownTimer extends StatelessWidget {
  final double Function(double) scaleWidth;
  final double Function(double) scaleHeight;
  final double Function(double) scaleText;

  String _format(int n) => n.toString().padLeft(2, '0');

  const _MaintenanceCountdownTimer({
    required this.scaleWidth,
    required this.scaleHeight,
    required this.scaleText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<CountdownTimerProvider>();
    final remaining = timer.remaining;

    final days = _format(remaining.inDays);
    final hours = _format(remaining.inHours.remainder(24));
    final minutes = _format(remaining.inMinutes.remainder(60));
    final seconds = _format(remaining.inSeconds.remainder(60));


    Widget timeUnit(String value, String label) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: scaleWidth(5), vertical: scaleHeight(1)),
          decoration: BoxDecoration(
            // color: Colors.red,
            gradient: LinearGradient(
              colors: [
                Color(0xFF2F384D),
                Color(0xFF0A0F11).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,            ),
            borderRadius: BorderRadius.circular(scaleWidth(2.31)),

          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: scaleText(18.45),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 1.2,
              letterSpacing: scaleWidth(0.18),
            ),
          ),
        ),
        SizedBox(height: scaleHeight(4)),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFB0B0B0), // Remains light grey
            fontSize: scaleText(6.92),
            fontFamily: 'Poppins',
            height: 1.2,
          ),
        ),
      ],
    );

    Widget dotSeparator() => Padding(
      padding: EdgeInsets.only(
        left: scaleWidth(3),
        right: scaleWidth(3),
        bottom: scaleHeight(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Dot(),
          SizedBox(height: scaleHeight(5.77)),
          const _Dot(),
        ],
      ),
    );

// The main container for the entire countdown timer.
    return ClipRRect(
      borderRadius: BorderRadius.circular(scaleWidth(2.31)),
      child: BackdropFilter(
         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: scaleWidth(12), vertical: scaleHeight(10)),
          decoration: BoxDecoration(
             gradient: LinearGradient(
              colors: [
                Color(0xFF2F384D),
                Color(0xFF0A0F11).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

              border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
             borderRadius: BorderRadius.circular(scaleWidth(6.31)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              timeUnit(days, 'Days'),
              dotSeparator(),
              timeUnit(hours, 'Hours'),
              dotSeparator(),
              timeUnit(minutes, 'Minutes'),
              dotSeparator(),
              timeUnit(seconds, 'Seconds'),
            ],
          ),
        ),
      ),
    );
    //
    // final double cornerRadius = scaleWidth(2.31);
    // final Color fillColor = const Color(0xFF1F1F1F).withOpacity(0.30);
    // final double strokeWeight = scaleWidth(0.35);
    //
    // final List<Color> strokeGradientColors = [
    //   Color(0xFF191D26).withOpacity(0.8), // Start of linear stroke, 80% opacity
    // Color(0xFF191D26).withOpacity(0.8),   // End of linear stroke, 80% opacity
    // ];
    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(cornerRadius),
    //   child: BackdropFilter(
    //     filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Figma Effect: Background blur
    //     child: Container(
    //       // This outer Container creates the space for the gradient border.
    //       // Its decoration will be the gradient.
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(cornerRadius),
    //         gradient: LinearGradient(
    //           colors: strokeGradientColors,
    //           begin: Alignment.topLeft, // Common direction for subtle linear borders
    //           end: Alignment.bottomRight,
    //         ),
    //       ),
    //       child: Padding(
    //         padding: EdgeInsets.all(strokeWeight), // This creates the "inside" stroke effect
    //         child: Container(
    //           // This inner Container has the actual fill color.
    //           padding: EdgeInsets.symmetric(
    //               horizontal: scaleWidth(12), vertical: scaleHeight(10)),
    //           decoration: BoxDecoration(
    //             color: fillColor, // Figma Fill: #1F1F1F at 30%
    //             borderRadius: BorderRadius.circular(cornerRadius - (strokeWeight > 0 ? strokeWeight / 2 : 0)), // Adjust inner radius slightly for smoother appearance
    //             // No border here, as the outer container creates the visual border
    //           ),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               timeUnit('02', 'Days'),
    //               dotSeparator(),
    //               timeUnit('23', 'Hours'),
    //               dotSeparator(),
    //               timeUnit('05', 'Minutes'),
    //               dotSeparator(),
    //               timeUnit('56', 'Seconds'),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
///
    // return Container(
    //   padding: EdgeInsets.symmetric(
    //       horizontal: scaleWidth(12), vertical: scaleHeight(10)),
    //   decoration: BoxDecoration(
    //      color: const Color.fromRGBO(28, 30, 36, 0.3), // Dark grey/blue with 30% opacity
    //     borderRadius: BorderRadius.circular(scaleWidth(2.31)),
    //   ),
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       timeUnit('02', 'Days'),
    //       dotSeparator(),
    //       timeUnit('23', 'Hours'),
    //       dotSeparator(),
    //       timeUnit('05', 'Minutes'),
    //       dotSeparator(),
    //       timeUnit('56', 'Seconds'),
    //     ],
    //   ),
    // );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: OvalBorder(),
      ),
    );
  }
}

