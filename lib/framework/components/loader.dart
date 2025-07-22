import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'dart:math';

class ECMProgressIndicator extends StatelessWidget {
  final int stageIndex;
  final double currentECM;
  final double maxECM;

  const ECMProgressIndicator({
    super.key,
    required this.stageIndex,
    required this.currentECM,
    required this.maxECM,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;
    final screenShortestSide = size.longestSide;

    final containerHeight = screenShortestSide * 0.019;
    final progress = (maxECM > 0) ? (currentECM / maxECM).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).toStringAsFixed(1);
    final textFontSize = getResponsiveFontSize(context, 14);

    TextStyle infoStyle = TextStyle(
      fontSize: textFontSize,
      color: Colors.white,
      height: 1.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'Poppins',
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ECM Info Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Stage $stageIndex: ${currentECM.toStringAsFixed(4)} ECM',
                  overflow: TextOverflow.ellipsis,
                  style: infoStyle,
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Max: ${maxECM.toStringAsFixed(1)} ECM',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: infoStyle,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),

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
      ),
    );
  }

}


