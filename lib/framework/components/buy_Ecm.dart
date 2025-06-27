import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

//
// class BlockButtonV2 extends StatefulWidget {
//   final String text;
//   final Widget? trailingIcon;
//   final VoidCallback? onPressed;
//   final double? height;
//   final double? width;
//   final TextStyle? textStyle;
//
//
//   const BlockButtonV2({
//     super.key,
//     required this.text,
//     this.trailingIcon,
//     this.onPressed, this.height, this.width, this.textStyle,
//   });
//
//   @override
//   _BlockButtonV2State createState() => _BlockButtonV2State();
// }
//
// class _BlockButtonV2State extends State<BlockButtonV2> {
//   bool _isPressed = false;
//   final double borderWidth = 2.0;
//
//   static const List<Color> _gradientColors = [
//     Color(0xFF2D8EFF),
//     Color(0xFF0090DE),
//     Color(0xFF2EE4A4),
//   ];
//
//   void _handleTapDown(TapDownDetails _) => setState(() => _isPressed = true);
//   void _handleTapUp(TapUpDetails _) {
//     setState(() => _isPressed = false);
//     widget.onPressed?.call();
//   }
//   void _handleTapCancel() => setState(() => _isPressed = false);
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     final buttonWidth = widget.width ?? screenWidth * 0.8;
//     final buttonHeight = widget.height ?? screenHeight * 0.065 ;
//
//
//
//
//     final calculatedFontSize = buttonHeight * 0.4;
//     final effectiveTextStyle = (widget.textStyle ?? const TextStyle())
//         .copyWith(
//       fontSize: widget.textStyle?.fontSize ?? calculatedFontSize,
//       color: widget.textStyle?.color ?? Colors.white,
//     );
//
//
//     return GestureDetector(
//       // onTapDown: _handleTapDown,
//       // onTapUp: _handleTapUp,
//       // onTapCancel: _handleTapCancel,
//       onTap: widget.onPressed,
//       child: Container(
//         width: buttonWidth,
//         height: buttonHeight,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(9),
//         ),
//         child: Stack(
//           children: [
//             // Gradient Border
//             ShaderMask(
//               shaderCallback: (bounds) {
//                 return const LinearGradient(
//                   colors: [
//                     Color(0xFF2D8EFF),
//                     Color(0xFF2EE4A4),
//                   ],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ).createShader(bounds);
//               },
//               blendMode: BlendMode.srcATop,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(9),
//                   border: Border.all(
//                     color: Colors.white,
//                     width: 0.8,
//                   ),
//                 ),
//               ),
//             ),
//             // Main Button Content
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               child: Center(
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Text(
//                         widget.text,
//                         // style: const TextStyle(
//                         //   fontFamily: 'SansSerif',
//                         //   fontWeight: FontWeight.w700,
//                         //   fontSize: 20,
//                         //   color: Colors.white, // Always white
//                         // ),
//                         style: effectiveTextStyle
//                       ),
//                     ),
//                     if (widget.trailingIcon != null) ...[
//                       const SizedBox(width: 8),
//                       widget.trailingIcon!, // No rotation anymore if not needed
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
// }
///
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

    // Button sizing relative to screen
    final buttonWidth = widget.width ?? screenWidth * 0.8;
    final buttonHeight = widget.height ?? screenHeight * 0.065;

    // Responsive font size scaling using combined screen dimensions
    double responsiveFontSize = (screenWidth + screenHeight) * 0.014;


    final calculatedFontSize = buttonHeight * 0.4;
    // Override fontSize if textStyle has it, else fallback to responsive size
    final effectiveTextStyle = (widget.textStyle ?? const TextStyle()).copyWith(
      fontSize: widget.textStyle?.fontSize ?? responsiveFontSize,
      color: widget.textStyle?.color ?? Colors.white,
    );

    // Padding scales with button height
    final horizontalPadding = buttonWidth * 0.02;
    final verticalPadding = buttonHeight * 0.25;
    final imageSize = buttonHeight * 0.5;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          // Add gradient border or background if you want here
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
