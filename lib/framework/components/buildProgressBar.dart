import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';

class ProgressBarUserDashboard extends StatelessWidget {
  final String? title;
  final double? percent;
  final String? percentText;
  final Color? barColor;
  final double? textScale;
  final double? screenWidth;
  final double? screenHeight;
  const ProgressBarUserDashboard({super.key, this.title, this.percent, this.percentText, this.barColor, this.textScale, this.screenWidth, this.screenHeight,});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title!,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: getResponsiveFontSize(context, 10),
                  height: 1.6,
                ),
              ),
            ),
            Text(
              percentText!,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: getResponsiveFontSize(context, 10),
                height: 1.6,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight! * 0.012),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth! * 0.02),
            image: const DecorationImage(
              image: AssetImage('assets/icons/progressFrameBg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth! * 0.02),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: const Color(0xFF2B2D40),
              valueColor: AlwaysStoppedAnimation<Color>(barColor!),
              minHeight: screenHeight! * 0.01,
            ),
          ),
        ),
      ],
    );
  }
}

