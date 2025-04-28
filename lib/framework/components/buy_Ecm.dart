import 'package:flutter/material.dart';


class BuyEcm extends StatefulWidget {
  final String text;
  final Widget? trailingIcon;
  final VoidCallback? onPressed;

  const BuyEcm({
    Key? key,
    required this.text,
    this.trailingIcon,
    this.onPressed,
  }) : super(key: key);

  @override
  _BuyEcmState createState() => _BuyEcmState();
}

class _BuyEcmState extends State<BuyEcm> {
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
    final w = MediaQuery.of(context).size.width * 0.4;
    final h = MediaQuery.of(context).size.height * 0.05;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
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
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.8,
                  ),
                ),
              ),
            ),
            // Main Button Content
            AnimatedContainer(
              duration: const Duration(milliseconds: 10),
              curve: Curves.easeInOutCubic,
              margin: EdgeInsets.all(_isPressed ? 0 : borderWidth),
              decoration: BoxDecoration(
                gradient: _isPressed
                    ? const LinearGradient(
                  colors: _gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: _isPressed ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(24 - (_isPressed ? 0 : borderWidth)),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.text,
                      style: const TextStyle(
                        fontFamily: 'SansSerif',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white, // Always white
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

