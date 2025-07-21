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

    final double baseIconSize = screenWidth * 0.028;

    final borderRadius = BorderRadius.circular(7);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: borderRadius,
        ),
        child: Stack(
          children: [
            // Gradient border container
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(buttonHeight * 0.005),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),

                    borderRadius: borderRadius,
                  ),
                ),
              ),
            ),

            // Outer gradient border using ShaderMask
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xff1CD494), Color(0xff2680EF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  blendMode: BlendMode.srcATop,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      border: Border.all(
                        color: Colors.white,
                        width: buttonHeight * 0.005,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Pressed overlay
            Positioned.fill(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isPressed ? 1.0 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: borderRadius,
                  ),
                ),
              ),
            ),

            // Icon in center
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  widget.iconPath,
                  width: baseIconSize * scaleFactor,
                  height: baseIconSize * scaleFactor,
                  color: _isPressed ? Colors.white : widget.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

