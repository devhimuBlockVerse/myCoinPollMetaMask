import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/bottom_nav_bar.dart';
import 'package:video_player/video_player.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  bool _didStartExit = false;
  VoidCallback? _videoListener;
  Timer? _safetyTimer;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   VersionService.checkVersion(context);
    // });

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _videoController =
          VideoPlayerController.asset('assets/images/splash.mp4');
      await _videoController.initialize();

      if (!mounted) return;

      _videoController.setLooping(false);
      await _videoController.play();

      _videoListener = () {
        final value = _videoController.value;
        if (!value.isInitialized) return;

        if (value.position >=
            value.duration - const Duration(milliseconds: 50)) {
          _startExitSequence();
        }
      };
      _videoController.addListener(_videoListener!);
      _safetyTimer = Timer(
          _videoController.value.duration + const Duration(milliseconds: 300),
          _startExitSequence);

      setState(() {});
    } catch (_) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 900));
      _startExitSequence();
    }
  }

  Future<void> _startExitSequence() async {
    if (_didStartExit) return;
    _didStartExit = true;

    _safetyTimer?.cancel();
    _safetyTimer = null;
    if (_videoListener != null) {
      _videoController.removeListener(_videoListener!);
      _videoListener = null;
    }

    if (mounted) {
      await _fadeController.forward();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BottomNavBar()),
      );
    }
  }

  @override
  void dispose() {
    _safetyTimer?.cancel();
    if (_videoListener != null) {
      _videoController.removeListener(_videoListener!);
      _videoListener = null;
    }
    _videoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReady = (_videoController.value.isInitialized);

    return Scaffold(
      // backgroundColor: Color(0XFF01090B),
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (isReady)
            FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            )
          else
            const ColoredBox(color: Color(0xFF01090B)),
          FadeTransition(
            opacity: _fadeAnimation,
            child: const ColoredBox(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
