import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/utils/dynamicFontSize.dart';
import '../../viewmodel/bottom_nav_provider.dart';

class AndroVerseScreen extends StatefulWidget {
  const AndroVerseScreen({super.key});

  @override
  State<AndroVerseScreen> createState() => _AndroVerseScreenState();
}

class _AndroVerseScreenState extends State<AndroVerseScreen> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;


    return Scaffold(
      body: SafeArea(
          top: false,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              color: Color(0xFF01090B),
              image: DecorationImage(

                image: AssetImage('assets/images/starGradientBg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topRight,
              ),
            ),
            child: SingleChildScrollView(
               child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.09,
                  ),
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      Text(
                        'Welcome to Androverse',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                           fontSize: getResponsiveFontSize(context, 20),
                          height: 1.6,
                           color: const Color(0xFFFFF5ED),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      Text(
                        'The Future is Loading...',
                        style: TextStyle(
                          fontFamily: 'Poppins',

                          fontSize: getResponsiveFontSize(context, 14),
                          height: 1.6,
                          color:const Color(0xCCFFF5ED),
                        ),
                        textAlign: TextAlign.center,
                      ),


                      SizedBox(height: screenHeight * 0.02),


                      FloatingImage(
                        amplitude: 12,
                        duration: const Duration(seconds: 3),
                        enableScalePulse: true,
                        child: Image.asset(
                          'assets/images/metaversworld.png',
                          width: isPortrait ? screenWidth * 0.8 : screenWidth * 0.5,
                          height: isPortrait ? screenHeight * 0.38 : screenHeight * 0.5,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),



                      SizedBox(height: screenHeight * 0.015),

                      Text(
                        'Explore digital ownership, trade NFTs, and unlock a new world coming back soon!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color:const Color(0xCCFFF5ED),
                          fontWeight: FontWeight.w400,

                          fontSize: getResponsiveFontSize(context, 12),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      BlockButton(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.5,
                        label: 'Go Back to Home',
                        textStyle:  TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                           fontSize: getResponsiveFontSize(context, 15),
                          height: 1.6,
                        ),
                        gradientColors: const [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494)
                         ],
                        onTap: () {
                          Provider.of<BottomNavProvider>(context, listen: false).setIndex(0);  // Go to Home Screen
                        },
                        iconPath: 'assets/icons/arrowIcon.svg',
                        iconSize : screenHeight * 0.013,
                      ),

                    ],
                  ),
                ),
              ),
            ),
          )

      )

    );
  }

 }

class FloatingImage extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final Duration duration;
  final bool enableScalePulse;
  final double scaleMin;
  final double scaleMax;

  const FloatingImage({super.key,
    required this.child,
    this.amplitude = 10.0,
     this.duration = const Duration(seconds: 4),
     this.enableScalePulse = true,
     this.scaleMin = 0.985,
     this.scaleMax = 1.015,
  });

  @override
  State<FloatingImage> createState() => _FloatingImageState();
}

class _FloatingImageState extends State<FloatingImage>with SingleTickerProviderStateMixin{

  late final AnimationController _controller;
  late final Animation<double> _t;
  static const double _twoPi = math.pi * 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
      duration: widget.duration
    )..repeat();

    _t = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void didUpdateWidget(FloatingImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.duration != widget.duration){
      _controller.duration = widget.duration;
      if(!_controller.isAnimating) _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  double _yOffset(double t) => math.sin(t * _twoPi) * widget.amplitude;
  double _scale(double t){
    if(!widget.enableScalePulse) return 1.0;
    final mid = (widget.scaleMin + widget.scaleMax) / 2;
    final amp = (widget.scaleMax - widget.scaleMin) / 2;
    return mid + amp * math.sin(t * _twoPi);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        child: AnimatedBuilder(
            animation: _t,
            builder: (_, child){
              final t = _t.value;
              return Transform.translate(
                offset: Offset(0, _yOffset(t)),
                child: Transform.scale(
                  scale: _scale(t),
                  child: child,
                ),
              );
            },
          child: widget.child,
        )
    );
  }



}



