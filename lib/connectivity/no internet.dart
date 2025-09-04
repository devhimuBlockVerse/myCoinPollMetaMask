 import 'package:flutter/material.dart';

class NoInternetOverlay extends StatefulWidget {
  final VoidCallback? onRetry;

  const NoInternetOverlay({super.key, this.onRetry});

  @override
  State<NoInternetOverlay> createState() => _NoInternetOverlayState();
}

class _NoInternetOverlayState extends State<NoInternetOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          width: size.width * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade900.withOpacity(0.95), Colors.grey.shade800.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.redAccent, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(_pulseAnimation.value),
                          blurRadius: 28,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(28),
                    child: const Icon(
                      Icons.signal_wifi_off_rounded,
                      color: Colors.redAccent,
                      size: 44,
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),
              const Text(
                'No Internet Connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Your wallet and dApp features require an active internet connection.\nPlease check your connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
