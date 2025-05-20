import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';



class DisconnectButton extends StatefulWidget {
  final String label;
  final String icon;
  final VoidCallback onPressed;
  final Color color;

  const DisconnectButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  State<DisconnectButton> createState() => _DisconnectButtonState();
}

class _DisconnectButtonState extends State<DisconnectButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;

    double buttonWidth = screenWidth * 0.7;
    double buttonHeight = screenHeight * 0.050;
    double fontSize = screenWidth * 0.045;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: CustomPaint(
        painter: DisconnectButtonClipper(),
        child: Container(
          width: buttonWidth,
          height: buttonHeight,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isPressed ? 1.0 : 0.0,
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                     borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              FittedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      widget.icon,
                      color: _isPressed ? Colors.white : widget.color,
                      // size: fontSize * 1.1,
                    ),
                    SizedBox(width: screenWidth * 0.02),

                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isPressed ? Colors.white : widget.color,
                        fontSize: fontSize * scaleFactor,
                      ),
                      child: Text(
                          widget.label,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.6,
                            fontSize: getResponsiveFontSize(context, 16),
                          ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisconnectButtonClipper extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    // Define a linear gradient shader
    final gradient = LinearGradient(
      colors: [
        Color(0xff1CD494),
        Color(0xff2680EF)

      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()
      ..color = Colors.redAccent
      // ..shader = gradient
      ..strokeWidth = .9
      ..style = PaintingStyle.stroke;

    final path = Path();

    const double notchWidth = 24;
    const double notchHeight = 4;
    const double cutSize = 10;

    // Offset amounts
    const double topNotchOffset = 95; // move right
    const double bottomNotchOffset = -95; // move left

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


    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
