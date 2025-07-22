import 'package:flutter/material.dart';

class Blog extends StatelessWidget {
  final String imageUrl;
  final String source;
  final String date;
  final String title;
  final VoidCallback onTap;

  const Blog({
    super.key,
    required this.imageUrl,
    required this.source,
    required this.date,
    required this.title, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double padding = screenWidth * 0.02;
    final double fontSmall = screenWidth * 0.025;
    final double fontMedium = screenWidth * 0.028;
    final double dotSize = screenWidth * 0.008;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.none,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 10 /7,
              child: Container(
                width: double.infinity,
                // height: imageHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(padding),
              decoration: const BoxDecoration(
                color: Color(0xFF212223),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(9.72),
                  bottomRight: Radius.circular(9.72),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      children: [
                      Flexible(
                        child: Text(
                          source,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF7D8088),
                            fontSize: fontSmall,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                          ),
                        ),
                      ),
                      // SizedBox(width: padding * 0.5),
                      Container(
                        width: dotSize,
                        height: dotSize,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF7D8088),
                        ),
                      ),
                      SizedBox(width: padding * 0.5),
                      Flexible(
                        child: Text(
                          date,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xff7E8088),
                            fontSize: fontSmall,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: padding * 0.5),
                  Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: fontMedium,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
