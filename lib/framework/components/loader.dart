import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';


class ECMProgressIndicator extends StatelessWidget {
  final int stageIndex;
  final double currentECM;
  final double maxECM;

  const ECMProgressIndicator({
    super.key,
    required this.currentECM,
    required this.maxECM, required this.stageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentECM / maxECM;
    final percentage = (progress * 100).toStringAsFixed(1);

     final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

     final width = size.width;
    final height = size.height;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
    // final containerHeight = (isPortrait ? height * 0.03 : height * 0.05).clamp(6.0, 20.0);
    final containerHeight = (isPortrait ? height * 0.015 : height * 0.025).clamp(6.0, 20.0);


    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                 child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Stage $stageIndex: ${currentECM.toStringAsFixed(4)} ECM',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      // fontSize: 12 * textScale,
                      fontSize: getResponsiveFontSize(context, 12),
                      color: Colors.white,
                      height: 1.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
               // SizedBox(width: 90,),
              Flexible(
                 child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Max: ${maxECM.toStringAsFixed(1)} ECM',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      // fontSize: 12 * textScale,
                      fontSize: getResponsiveFontSize(context, 12),
                      color: Colors.white,
                      height: 1.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          // Progress bar
          Stack(
            children: [
              Container(
                height: containerHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(containerHeight / 2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: containerHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(containerHeight / 2),
                  ),
                  child:progress >= 0.1 ? Center(
                    child: Text(
                      '$percentage%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        // fontSize: 12 * textScale,
                        fontSize: getResponsiveFontSize(context, 12),
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ): null,
                ),
              ),
              if (progress < 0.1)
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    // fontSize: 12 * textScale,
                    fontSize: getResponsiveFontSize(context, 12),

                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


