
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

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
  int _currentIndex = 0 ;
  int _prevIndex = 0;
  late Timer _timer;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSlideshow();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
  }


  void _startSlideshow() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _prevIndex = _currentIndex;
        _currentIndex = (_currentIndex + 1) % widget.imageAssets.length;
        _controller.reset();
        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveDimension = MediaQuery.of(context).size.shortestSide;
    final imageSize = effectiveDimension * 0.2;

    return SizedBox(
      width: widget.containerWidth,
      height: widget.containerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
           Positioned(
            child: ClipOval(
              child: Image.asset(
                widget.imageAssets[_prevIndex],
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                color: Colors.white.withOpacity(0.1),
                colorBlendMode: BlendMode.clear,
              ),
            ),
          ),
          // Animated current image
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigoAccent.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    widget.imageAssets[_currentIndex],
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}