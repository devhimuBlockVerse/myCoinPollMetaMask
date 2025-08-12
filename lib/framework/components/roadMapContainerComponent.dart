import 'package:flutter/material.dart';
import 'buy_Ecm.dart';

class RoadmapContainerComponent extends StatelessWidget {
  final String title;
  final List<Widget> labels;
  final VoidCallback? onTap;
  final String mapYear;

  const RoadmapContainerComponent({
    super.key,
    required this.title,
    required this.labels,
    required this.mapYear,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final base = size.shortestSide;
    final width = size.width * 0.78;
    final yearSize = base * 0.21;
    final fontScale = base * 0.037;

    return Center(
      child: SizedBox(
        width: width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background
            Positioned.fill(
              child: Image.asset(
                "assets/images/roadmapFrame.png",
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
            ),

            // Year Badge (fixed center position)
            Positioned(
              top: -yearSize * 0.8,
              left: (width - yearSize) / 2,
              child: SizedBox(
                width: yearSize,
                height: yearSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/yearCircular.png',
                      fit: BoxFit.cover,
                      width: yearSize,
                      height: yearSize,
                    ),
                    Text(
                      mapYear,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: yearSize * 0.12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: base * 0.025,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: base * 0.018),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: base * 0.048,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: base * 0.02),

                  ...labels.map(
                        (label) => Padding(
                      padding: EdgeInsets.only(bottom: base * 0.012),
                      child: label,
                    ),
                  ),
                  SizedBox(height: base * 0.15),
                ],
              ),
            ),

            // Button (if exists)
            if (onTap != null)
              Positioned(
                bottom: base * 0.05,
                left: size.width * 0.03,
                child: BlockButtonV2(
                  text: 'Show Other Roadmap',
                  onPressed: onTap,
                  height: size.height * 0.036,
                  width: size.width * 0.31,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

