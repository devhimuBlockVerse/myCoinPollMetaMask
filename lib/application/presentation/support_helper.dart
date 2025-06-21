import 'dart:ui';

import 'package:flutter/material.dart';



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
                height: scaleHeight(200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(scaleWidth(10)),
                ),
                child: Image.asset(
                  'assets/icons/underMaintainance.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: scaleHeight(30)),

              // Countdown timer row with overflow fix
              _CountdownTimer(
                scaleWidth: scaleWidth,
                scaleHeight: scaleHeight,
                scaleText: scaleText,
              ),

              SizedBox(height: scaleHeight(30)),

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
            ],
          ),
        ),
      ),
    );
  }
}

class _CountdownTimer extends StatelessWidget {
  final double Function(double) scaleWidth;
  final double Function(double) scaleHeight;
  final double Function(double) scaleText;

  const _CountdownTimer({
    required this.scaleWidth,
    required this.scaleHeight,
    required this.scaleText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget timeUnit(String value, String label) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: scaleWidth(8), vertical: scaleHeight(4)),
          decoration: BoxDecoration(
            color: Colors.black, // Remains black as per the visual
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
          padding: EdgeInsets.symmetric(
              horizontal: scaleWidth(12), vertical: scaleHeight(10)),
          decoration: BoxDecoration(
             color: Colors.white.withOpacity(0.15),
             border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
             borderRadius: BorderRadius.circular(scaleWidth(2.31)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              timeUnit('02', 'Days'),
              dotSeparator(),
              timeUnit('23', 'Hours'),
              dotSeparator(),
              timeUnit('05', 'Minutes'),
              dotSeparator(),
              timeUnit('56', 'Seconds'),
            ],
          ),
        ),
      ),
    );
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
// class _CountdownTimer extends StatelessWidget {
//   final double Function(double) scaleWidth;
//   final double Function(double) scaleHeight;
//   final double Function(double) scaleText;
//
//   const _CountdownTimer({
//     required this.scaleWidth,
//     required this.scaleHeight,
//     required this.scaleText,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     Widget timeUnit(String value, String label) => Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           padding: EdgeInsets.all(scaleWidth(3.46)),
//           decoration: ShapeDecoration(
//             gradient: RadialGradient(
//               center: const Alignment(0.16, 0.75),
//               radius: 0,
//               colors: [Colors.white, Colors.white.withOpacity(0)],
//             ),
//             shape: RoundedRectangleBorder(
//               side: BorderSide(width: scaleWidth(0.29), color: Colors.white),
//               borderRadius: BorderRadius.circular(scaleWidth(2.31)),
//             ),
//           ),
//           child: Text(
//             value,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: scaleText(18.45),
//               fontFamily: 'Poppins',
//               height: 1.2,
//               letterSpacing: scaleWidth(0.18),
//             ),
//           ),
//         ),
//         SizedBox(height: scaleHeight(2)),
//         Text(
//           label,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: scaleText(6.92),
//             fontFamily: 'Poppins',
//             height: 1.2,
//           ),
//         ),
//       ],
//     );
//
//     Widget dotSeparator() => Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: scaleWidth(2.31), vertical: scaleHeight(9.23)),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const _Dot(),
//           SizedBox(height: scaleHeight(5.77)),
//           const _Dot(),
//         ],
//       ),
//     );
//
//     return ConstrainedBox(
//       constraints: BoxConstraints(
//         maxWidth: scaleWidth(320), // allow more width to avoid overflow
//       ),
//       child: Container(
//         clipBehavior: Clip.antiAlias,
//         decoration: ShapeDecoration(
//           color: const Color(0x1F1F1F).withOpacity(0.3),
//           shape: RoundedRectangleBorder(
//             side: BorderSide(
//               width: scaleWidth(0.35),
//               color: Colors.white.withOpacity(0.8),
//             ),
//             borderRadius: BorderRadius.circular(scaleWidth(2.31)),
//           ),
//           shadows: const [
//             BoxShadow(
//               // color: Color(0x7FFFFFFF),
//               color: Color(0xff2C2E41),
//               blurRadius: 1.15,
//               offset: Offset(0, 0.58),
//             ),
//             BoxShadow(
//               // color: Color(0x7F010227),
//               color: Color(0x7F010227),
//               offset: Offset(0, 0.58),
//             ),
//           ],
//         ),
//         padding: EdgeInsets.symmetric(
//             horizontal: scaleWidth(17.3), vertical: scaleHeight(6.92)),
//         child: FittedBox(
//           fit: BoxFit.scaleDown,
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
//     );
//   }
// }

// class _Dot extends StatelessWidget {
//   const _Dot({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 2.31,
//       height: 2.31,
//       decoration: const ShapeDecoration(
//         color: Colors.white,
//         shape: OvalBorder(),
//       ),
//     );
//   }
// }
