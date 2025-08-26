import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class BlockButtonV2 extends StatefulWidget {
  final String text;
  final Widget? trailingIcon;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final String? leadingImagePath;

  const BlockButtonV2({
    super.key,
    required this.text,
    this.trailingIcon,
    this.onPressed,
    this.height,
    this.width,
    this.textStyle, this.leadingImagePath,
  });

  @override
  _BlockButtonV2State createState() => _BlockButtonV2State();
}
class _BlockButtonV2State extends State<BlockButtonV2> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _handleTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }
  Widget _buildImage(String path, double size) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }
  }

  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

     final buttonWidth = widget.width ?? screenWidth * 0.8;
    final buttonHeight = widget.height ?? screenHeight * 0.065;

     double responsiveFontSize = (screenWidth + screenHeight) * 0.014;


      final effectiveTextStyle = (widget.textStyle ?? const TextStyle()).copyWith(
      fontSize: widget.textStyle?.fontSize ?? responsiveFontSize,
      color: widget.textStyle?.color ?? Colors.white,
    );

     final horizontalPadding = buttonWidth * 0.02;
    final verticalPadding = buttonHeight * 0.25;
    final imageSize = buttonHeight * 0.3;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      // onTap: widget.onPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
         ),
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              blendMode: BlendMode.srcATop,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: Colors.white,
                    width: 0.8,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.leadingImagePath != null) ...[
                      _buildImage(widget.leadingImagePath!, imageSize),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.text,
                          style: effectiveTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    if (widget.trailingIcon != null) ...[
                      SizedBox(width: buttonWidth * 0.04),
                      widget.trailingIcon!,
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
