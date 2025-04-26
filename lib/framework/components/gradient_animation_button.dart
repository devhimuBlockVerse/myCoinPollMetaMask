import 'package:flutter/material.dart';
class GradientButton extends StatefulWidget {
  final String text;
  final Widget? trailingIcon;
  final VoidCallback? onPressed;

  const GradientButton({
    Key? key,
    required this.text,
    this.trailingIcon,
    this.onPressed,
  }) : super(key: key);

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  List<Color> _colors = [
    const Color(0xFF2D8EFF),
    const Color(0xFF2EE4A4),
  ];
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
     _startColorAnimation();
  }

  void _startColorAnimation() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _colorIndex = (_colorIndex + 1) % _colors.length;
        });
        _startColorAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.05,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              _colors[_colorIndex],
              _colors[_colorIndex],
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  fontFamily: 'SansSerif',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),

              if (widget.trailingIcon != null) ...[
                const SizedBox(width: 8),
                // Apply the rotation here
                Transform.rotate(
                  angle: 90 * 3.1415926535 / 50, // Convert degrees to radians
                  child: widget.trailingIcon!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}