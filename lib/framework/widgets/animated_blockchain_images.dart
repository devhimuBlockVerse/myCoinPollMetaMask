
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show radians;


class AnimatedBlockchainImages extends StatefulWidget {
  final List<String> imageAssets;
  final double containerWidth;
  final double containerHeight;

  const AnimatedBlockchainImages({
    super.key,
    required this.imageAssets,
    required this.containerWidth,
    required this.containerHeight,
  });

  @override
  _AnimatedBlockchainImagesState createState() => _AnimatedBlockchainImagesState();
}

class _AnimatedBlockchainImagesState extends State<AnimatedBlockchainImages> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8), // Animation duration
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the center of the circular path relative to the container
    final double centerX = widget.containerWidth / 2;
    final double centerY = widget.containerHeight / 5;

    // Define the radius of the circular path - Decreased for less spacing
    final double effectiveDimension = min(widget.containerWidth, widget.containerHeight);
    final double radius = effectiveDimension * 0.28; // Reduced radius

    // Define the base size of the individual rounded images - Slightly increased again
    final double baseImageSize = effectiveDimension * 0.55;

    return SizedBox(
      width: widget.containerWidth,
      height: widget.containerHeight,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Apply a 3D rotation and perspective to the entire stack
          final Matrix4 transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Add perspective
            ..rotateX(radians(30)) // Rotate the entire orbit around the X-axis
            ..rotateY(_animation.value * radians(360)); // Rotate the entire orbit around the Y-axis over time

          return Transform(
            transform: transform,
            alignment: FractionalOffset.center,
            child: Stack(
              children: List.generate(widget.imageAssets.length, (index) {
                // Calculate the angle for the current image in the 2D plane
                final double startAngle = (2 * pi / widget.imageAssets.length) * index;
                final double currentAngle = startAngle + (_animation.value * 2 * pi);

                // Calculate the position in the 2D plane of the orbit
                final double imageX = centerX + radius * cos(currentAngle) - baseImageSize / 2;
                final double imageY = centerY + radius * sin(currentAngle) - baseImageSize / 2;

                // Calculate a scaling factor based on the image's perceived depth
                final double scale = 0.7 + (sin(currentAngle) * 0.4);

                 final double opacity = 0.6 + (sin(currentAngle) * 0.4);

                return Positioned(
                  left: imageX,
                  top: imageY,
                   child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: scale.clamp(0.7, 1.3),
                      child: ClipOval(
                        child: Image.asset(
                          widget.imageAssets[index],
                          width: baseImageSize,
                          height: baseImageSize,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
