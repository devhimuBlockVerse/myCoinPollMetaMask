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
    required this.headline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final imageHeight = width * 0.5;
      final overlayHeight = width * 0.3;
      final overlayTop = imageHeight * 0.65;

      return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: imageHeight + overlayHeight * 0.5,
          child: Stack(
            children: [
              // Background image
              Container(
                width: width,
                height: imageHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Overlay container
              Positioned(
                left: width * 0.05,
                top: overlayTop,
                child: Container(
                  width: width * 0.9,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: overlayHeight * 0.15,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xF2040C16),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              source,
                              style: TextStyle(
                                color: const Color(0xFF5CA4FF),
                                fontSize: width * 0.04,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              color: const Color(0xFF77798D),
                              fontFamily: 'Poppins',
                              fontSize: width * 0.032,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Headline
                      Text(
                        headline,
                        style: TextStyle(
                          color: const Color(0xFFFFF5ED),
                          fontSize: width * 0.04,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
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
    });
  }
}
