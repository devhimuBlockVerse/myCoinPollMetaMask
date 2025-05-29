import 'package:flutter/material.dart';

class RewardInfoCard extends StatelessWidget {
  final String imageUrl;
  final String message;

  const RewardInfoCard({
    super.key,
    required this.imageUrl,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = screenWidth * 0.065;
    final spacing = screenWidth * 0.03;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        color: const Color(0xff101A29),
        border: Border.all(width: 1, color: const Color(0xFF2B2D40)),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              imageUrl,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.fill,
            ),
          ),

          SizedBox(width: spacing),

          // Vertical Divider
          Container(
            height: imageSize,
            width: 1,
            color: Colors.white.withOpacity(0.5),
          ),

          SizedBox(width: spacing),

          // Text
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.028,
                fontFamily: 'Poppins',
                height: 1.6,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
