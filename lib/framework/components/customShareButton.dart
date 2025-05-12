import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CustomShareButton extends StatefulWidget {
  final String iconPath;
  final VoidCallback? onPressed;
  final Color color;
  final double? width;
  final double? height;


  const CustomShareButton({super.key, required this.iconPath,  this.onPressed, required this.color, this.width, this.height});

  @override
  State<CustomShareButton> createState() => _CustomShareButtonState();
}

class _CustomShareButtonState extends State<CustomShareButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed!();
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
    final double baseIconSize = screenWidth * 0.028;


    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: CustomPaint(
        painter: ShareContainer(),
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
                            fontSize: baseIconSize * scaleFactor,
                            height: 1.6, // Line height 160%

                          ),

                          child: SvgPicture.asset(
                             widget.iconPath,

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

class ShareContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cutSize = size.height * 0.15;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width - cutSize, 0);
    path.lineTo(size.width, cutSize);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
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
      ..strokeWidth = size.height * 0.005
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
