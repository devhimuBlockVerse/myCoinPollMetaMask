import 'package:flutter/material.dart';


class WhitePaperButtonComponent extends StatefulWidget {
  final String label;
   final VoidCallback onPressed;
  final Color color;
  final double? width;
  final double? height;

  const WhitePaperButtonComponent({
    super.key,
    required this.label,
     required this.onPressed,
    required this.color,
    this.width,
    this.height,
  });

  @override
  State<WhitePaperButtonComponent> createState() => _WhitePaperButtonComponentState();
}

class _WhitePaperButtonComponentState extends State<WhitePaperButtonComponent> {
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

    final double buttonWidth = widget.width ?? screenWidth * 0.8;
    final double buttonHeight = widget.height ?? screenHeight * 0.06;

    // Responsive font size with base of 10 (adjust as needed)
    final double baseFontSize = screenWidth * 0.028;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: CustomPaint(
        painter: PaperClipper(),
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
                    color: Colors.grey.withOpacity(0.3),
                     borderRadius: BorderRadius.circular(12),

                  ),
                ),
              ),
              FittedBox(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700, // SemiBold
                            color: _isPressed ? Colors.white : widget.color,
                            fontSize: baseFontSize * scaleFactor,
                            height: 1.6, // Line height 160%

                          ),

                          child: Text(
                            textAlign: TextAlign.center,
                            widget.label,
                            maxLines: 1,
                           ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaperClipper extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Relative sizing based on width/height
    final double cutSize = size.height * 0.15;        // 15% of height
    final double notchWidth = size.width * 0.1;       // 10% of width
    final double notchHeight = size.height * 0.1;     // 10% of height
    final double topNotchOffset = size.width * 0.15;  // 15% of width
    final double bottomNotchOffset = -size.width * 0.15;

    final path = Path();

    path.moveTo(cutSize, 0);
    double topNotchCenter = (size.width / 2) + topNotchOffset;
    path.lineTo(topNotchCenter - (notchWidth / 2), 0);
    path.lineTo(topNotchCenter - (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2), 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cutSize);
    path.lineTo(size.width - cutSize, size.height);

    double bottomNotchCenter = (size.width / 2) + bottomNotchOffset;
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height);
    path.lineTo(bottomNotchCenter + (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height - notchHeight);
    path.lineTo(bottomNotchCenter - (notchWidth / 2), size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cutSize);
    path.lineTo(cutSize, 0);
    path.close();

    // Shadow
    canvas.drawShadow(path, Colors.grey.withOpacity(0.3), 1, false);

    // Fill
    final fillPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Gradient border
    final gradient = LinearGradient(
      colors: [Color(0xff1CD494), Color(0xff2680EF)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final borderPaint = Paint()
      ..shader = gradient
      ..strokeWidth = size.height * 0.005  // responsive stroke width
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

