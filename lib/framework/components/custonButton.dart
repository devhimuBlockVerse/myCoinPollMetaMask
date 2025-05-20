import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class CustomButton extends StatelessWidget {
  final String text;
  final String? icon;
  final bool isActive;
  final double? width;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    required this.isActive,
    this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
         final buttonWidth = width ?? (screenWidth / 360) * 2;

        final textScale = MediaQuery.of(context).textScaleFactor;
        final baseFontSize = (screenWidth / 360) * 40;
        final iconSize = (screenWidth / 360) * 14;
        final checkIconSize = (screenWidth / 360) * 12;
        return InkWell(
          onTap: onPressed,
          child: ClipPath(
            clipper: CustomButtonClipper(),
            child: Container(
              width: buttonWidth,
              height: screenWidth * 0.08,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenWidth * 0.025,
              ),
              decoration: BoxDecoration(
                gradient: isActive
                    ? const LinearGradient(
                  colors: [Color(0xFF277BF5), Color(0xFF1CD691)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
                    : const LinearGradient(
                  colors: [Color(0xFF1B212B), Color(0xFF1B212B)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                // borderRadius: BorderRadius.circular(30),
                border: isActive
                    ? null
                    : Border.all(color: const Color(0xFF1FB9B1C9), width: 1),
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                    if (icon != null) ...[
                      Image.asset(
                        icon!,
                        // width: screenWidth * 0.05,
                        // height: screenWidth * 0.05,
                        width: iconSize,
                        height: iconSize,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          text,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white,
                             fontSize: baseFontSize * textScale,
                             fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            height: 0.6,
                          ),
                        ),
                      ),
                    ),
                    if (isActive) ...[
                      const SizedBox(width: 8),

                      Center(
                        child: SvgPicture.asset(
                          'assets/icons/checkIcon.svg',
                          width: checkIconSize,
                          height: checkIconSize,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
class CustomButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double notchWidth = 18;
    const double notchHeight = 3;
    const double cutSize =  4;

    // Offset amounts
    const double topNotchOffset = 30; // move right
    const double bottomNotchOffset = -30; // move left

    // Top-left angled start
    path.moveTo(cutSize, 0);

    // Top notch (slightly right of center)
    double topNotchCenter = (size.width / 2) + topNotchOffset;
    path.lineTo(topNotchCenter - (notchWidth / 2), 0);
    path.lineTo(topNotchCenter - (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), 0);

    // Top-right corner (no cut)

    path.lineTo(size.width, 0);

    // Right side down
    path.lineTo(size.width, size.height - cutSize);

    // Bottom-right corner with cut
    path.lineTo(size.width - cutSize, size.height);

    // Bottom notch (slightly left of center)
    double bottomNotchCenter = (size.width / 2) + bottomNotchOffset;
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height);
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height);

    // Bottom-left corner (no cut)
    path.lineTo(0, size.height);

    // Left side up to top-left (cut)
    path.lineTo(0, cutSize);
    path.lineTo(cutSize, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
