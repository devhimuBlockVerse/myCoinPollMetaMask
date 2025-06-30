import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'enums/toast_type.dart';

class ToastMessage extends StatelessWidget {
  final MessageType type;
  final String title;
  final String subtitle;

  const ToastMessage({
    Key? key,
    required this.type,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth * 0.9 > 400 ? 400 : screenWidth * 0.9;

    final double baseTitleFontSize = 14.0;
    final double baseSubtitleFontSize = 12.0;

    final double titleFontSize = baseTitleFontSize * (screenWidth / 375);
    final double subtitleFontSize = baseSubtitleFontSize * (screenWidth / 375);

    List<Color> gradientColors;
    String iconData;

    switch (type) {
      case MessageType.info:
        gradientColors = [Color(0xFF313927), Color(0xFF101A29)];
        iconData = 'assets/icons/info.svg';
        break;
      case MessageType.success:
        gradientColors = [Color(0xFF123438), Color(0xFF101A29)];
        iconData = 'assets/icons/success.svg';
        break;
      case MessageType.error:
        gradientColors =  [Color(0xFF2C1F2C), Color(0xFF101A29)];
        iconData = 'assets/icons/error.svg';
        break;
    }

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: gradientColors,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFF2B2D40)),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Section
          Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(4),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(43),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconData,
                // color: Colors.white,
                // size: 24,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Vertical Divider
          VerticalDivider(
            width: 2,
            thickness: 1,
            color: Colors.white.withOpacity(0.5),
            indent: 5,
            endIndent: 5,
          ),
          const SizedBox(width: 10),

          // Text Section
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, // Use dynamic title
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle, // Use dynamic subtitle
                  style: TextStyle(
                    color: Color(0xFFC7C5C5),
                    fontSize: subtitleFontSize,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}