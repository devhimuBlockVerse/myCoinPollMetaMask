import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';

class TransactionStatCard extends StatelessWidget {
  final String bgImagePath;
  final String title;
  final String value;

  const TransactionStatCard({
    super.key,
    required this.bgImagePath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.02;
    final verticalPadding = screenHeight * 0.01;
    final spacing = screenHeight * 0.005;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bgImagePath),
          fit: BoxFit.fill,
          filterQuality: FilterQuality.low,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // wrap content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: getResponsiveFontSize(context, 12),
              height: 1.6,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: spacing),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: getResponsiveFontSize(context, 18),
              height: 1.2,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}