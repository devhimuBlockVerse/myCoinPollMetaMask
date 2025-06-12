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

    final containerWidth = screenWidth * 0.35;
    final containerHeight = screenHeight * 0.07;

    return Container(
       height: containerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bgImagePath),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
          const SizedBox(height: 4),
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
