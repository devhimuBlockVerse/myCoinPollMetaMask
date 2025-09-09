import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'dart:math';

class ECMProgressIndicator extends StatelessWidget {
  final DateTime vestingStartDate;
  final DateTime fullVestedDate;

  const ECMProgressIndicator({
    super.key,
    required this.vestingStartDate,
    required this.fullVestedDate,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
     final screenShortestSide = size.longestSide;

    final containerHeight = screenShortestSide * 0.019;

    final now = DateTime.now();
    final totalDuration = fullVestedDate.difference(vestingStartDate).inSeconds;
    final elapsed = now.isBefore(vestingStartDate)
        ? 0
        : now.difference(vestingStartDate).inSeconds;

    double progress = (elapsed / totalDuration).clamp(0.0, 1.0);
    final percentage = (progress * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Progress Bar
        Stack(
          children: [
            /// Background
            Container(
              height: containerHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(containerHeight / 2),
              ),
            ),

            /// Filled Progress
            LayoutBuilder(
              builder: (context, constraints) {
                final progressWidth = (constraints.maxWidth * progress).clamp(0.0, constraints.maxWidth);
                final minWidth = getResponsiveFontSize(context, 12) * 3.8;
                final barWidth = progress > 0 ? max(minWidth, progressWidth) : 0.0;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: containerHeight,
                  width: barWidth,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(containerHeight / 2),
                  ),
                  child: Center(
                    child: Text(
                      '$percentage%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: getResponsiveFontSize(context, 9),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

}


