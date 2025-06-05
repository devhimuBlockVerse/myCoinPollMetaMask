import 'package:flutter/material.dart';


class BlockButtonV2 extends StatefulWidget {
  final String text;
  final Widget? trailingIcon;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;


  const BlockButtonV2({
    super.key,
    required this.text,
    this.trailingIcon,
    this.onPressed, this.height, this.width,
  });

  @override
  _BlockButtonV2State createState() => _BlockButtonV2State();
}

class _BlockButtonV2State extends State<BlockButtonV2> {
  bool _isPressed = false;
  final double borderWidth = 2.0;

  static const List<Color> _gradientColors = [
    Color(0xFF2D8EFF),
    Color(0xFF0090DE),
    Color(0xFF2EE4A4),
  ];

  void _handleTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _handleTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }
  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final buttonWidth = widget.width ?? screenWidth * 0.8;
    final buttonHeight = widget.height ?? screenHeight * 0.065 ;



    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Gradient Border
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xFF2D8EFF),
                    Color(0xFF2EE4A4),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.8,
                  ),
                ),
              ),
            ),
            // Main Button Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.text,
                        style: const TextStyle(
                          fontFamily: 'SansSerif',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.white, // Always white
                        ),
                      ),
                    ),
                    if (widget.trailingIcon != null) ...[
                      const SizedBox(width: 8),
                      widget.trailingIcon!, // No rotation anymore if not needed
                    ],
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

