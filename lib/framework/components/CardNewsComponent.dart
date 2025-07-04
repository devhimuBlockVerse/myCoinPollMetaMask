import 'package:flutter/material.dart';

class CardNewsComponent extends StatelessWidget {
  final String imageUrl;
  final String source;
  final String timeAgo;
  final String headline;
  final VoidCallback onTap;


  const CardNewsComponent({
    super.key,
    required this.imageUrl,
    required this.source,
    required this.timeAgo,
    required this.headline, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth;
    final imageHeight = containerWidth * 0.48;
    final overlayTopOffset = imageHeight * 0.6;
    final overlayHeight = imageHeight * 0.7;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: containerWidth,
        width: double.infinity,
        height: imageHeight + overlayHeight * 0.6,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            // Background image
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: containerWidth,
                height: imageHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),

            // News card overlay
            Positioned(
              left: screenWidth * 0.05,
              top: overlayTopOffset,
              child: Container(
                width: containerWidth - screenWidth * 0.3,
                height: overlayHeight,
                decoration: BoxDecoration(
                  color: const Color(0xF2040C16),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: containerWidth * 0.05,
                  vertical: overlayHeight * 0.15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source and time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            source,
                            style: TextStyle(
                              color: const Color(0xFF5CA4FF),
                              fontSize: containerWidth * 0.04,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700, // Bold
                              height: 1.6, // 160% line height
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            color: const Color(0xFF77798D),
                            fontSize: containerWidth * 0.032,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700, // Bold
                            height: 1.6, // 160% line height
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Headline
                    Text(
                      headline,
                      style: TextStyle(
                        color: const Color(0xFFFFF5ED),
                        fontSize: containerWidth * 0.04,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                        height: 1.6, // 160% line height

                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
