 import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodel/countdown_provider.dart';

class CountdownTimer extends StatelessWidget {
  final double Function(double) scaleWidth;
  final double Function(double) scaleHeight;
  final double Function(double) scaleText;
  final bool showMonths;
  final List<Color>? gradientColors;

  const CountdownTimer({
    super.key,
    required this.scaleWidth,
    required this.scaleHeight,
    required this.scaleText,
    this.showMonths = false,
    this.gradientColors,
  });

  String _format(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<CountdownTimerProvider>();
    final remaining = timer.remaining;

    final months = showMonths ? _format(timer.months) : null;
    final days = _format(showMonths ? timer.daysAfterMonths : remaining.inDays);

    // final days = _format(remaining.inDays);
    final hours = _format(remaining.inHours.remainder(24));
    final minutes = _format(remaining.inMinutes.remainder(60));
    final seconds = _format(remaining.inSeconds.remainder(60));

    final List<Color> defaultGradient = [
      const Color(0xFF2F384D),
      const Color(0xFF0A0F11).withOpacity(0.5)
    ];
    final effectiveGradientColors = gradientColors ?? defaultGradient;
    Widget timeUnit(String value, String label) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: scaleWidth(1)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
               colors: effectiveGradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
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
            color: const Color(0xFFB0B0B0),
            fontSize: scaleText(6.92),
            fontFamily: 'Poppins',
            height: 1.2,
          ),
        ),
      ],
    );

    Widget dotSeparator() => Padding(
      padding: EdgeInsets.only(
          left: scaleWidth(3), right: scaleWidth(3), bottom: scaleHeight(12)),
      child: Column(
        children: [
          const _Dot(),
          SizedBox(height: scaleHeight(5.77)),
          const _Dot(),
        ],
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(scaleWidth(2.31)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: scaleWidth(12),
            vertical: scaleHeight(10),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // colors: [Color(0xFF2F384D), Color(0xFF0A0F11).withOpacity(0.5)],
              colors: effectiveGradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            borderRadius: BorderRadius.circular(scaleWidth(6.31)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showMonths) ...[
                timeUnit(months!, 'Months'),
                dotSeparator(),
              ],
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
