import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'enums/toast_type.dart';

enum CustomToastLength { SHORT, LONG }
enum CustomToastGravity { TOP, CENTER, BOTTOM }

class ToastMessage {
  static final GlobalKey<NavigatorState> toastContextNavigatorKey = GlobalKey<NavigatorState>();

  static void show({
    required String message,
    String? subtitle,
    MessageType type = MessageType.info,
    CustomToastLength duration = CustomToastLength.SHORT,
    CustomToastGravity gravity = CustomToastGravity.BOTTOM,
  }) {

    late final OverlayEntry overlayEntry;
    bool isToastRemoved = false;

    void safeRemoveToast() {
      if (!isToastRemoved) {
        isToastRemoved = true;
        overlayEntry.remove();
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (toastContextNavigatorKey.currentState?.mounted ?? false) {
        final overlayState = toastContextNavigatorKey.currentState?.overlay;
        if (overlayState == null) {
          debugPrint('ToastMessage Error: Overlay state not available');
          return;
        }
          overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: gravity == CustomToastGravity.TOP ? 50.0 : null,
            bottom: gravity == CustomToastGravity.BOTTOM ? 50.0 : null,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: _ToastContent(
                  message: message,
                  subtitle: subtitle,
                  type: type,
                  gravity: gravity,
                  duration: duration,
                  overlayEntry: overlayEntry,
                  onRemove: safeRemoveToast,
                ),
              ),
            ),
          ),
        );

        overlayState.insert(overlayEntry);

        Future.delayed(
          Duration(seconds: duration == CustomToastLength.SHORT ? 2 : 4),
              (){
              safeRemoveToast();
            },
        );
      } else {
        debugPrint('ToastMessage Error: Navigator not mounted');
      }
    });
  }
}

class _ToastContent extends StatefulWidget {
  final String message;
  final String? subtitle;
  final MessageType type;
  final CustomToastGravity gravity;
  final CustomToastLength duration;
  final OverlayEntry overlayEntry;
  final VoidCallback onRemove;
  const _ToastContent({
    required this.message,
    this.subtitle,
    required this.type, required this.gravity, required this.duration, required this.overlayEntry, required this.onRemove,
  });

  @override
  State<_ToastContent> createState() => _ToastContentState();
}

class _ToastContentState extends State<_ToastContent> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _isDismissed = false;



  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.gravity == CustomToastGravity.TOP
          ? const Offset(0, -0.2)
          : const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _controller.forward();

    Future.delayed(
      Duration(seconds: widget.duration == CustomToastLength.SHORT ? 2 : 4),
          () {
            if (mounted && !_isDismissed) {
              _controller.reverse();
            }
      },
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if (mounted) {
           widget.onRemove();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final (List<Color> colors, String icon) = switch (widget.type) {
      MessageType.info => (
      [const Color(0xFF313927), const Color(0xFF101A29)],
      'assets/icons/info.svg',
      ),
      MessageType.success => (
      [const Color(0xFF123438), const Color(0xFF101A29)],
      'assets/icons/success.svg',
      ),
      MessageType.error => (
      [const Color(0xFF2C1F2C), const Color(0xFF101A29)],
      'assets/icons/error.svg',
      ),
    };

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Dismissible(
            key: const Key('toast_message'),
            direction: DismissDirection.horizontal,
            onDismissed: (_)  {
              _controller.reverse();
            },
            child: Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 14.0),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SvgPicture.asset(icon, width: 24, height: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle!,
                            style: const TextStyle(
                              color: Color(0xFFC7C5C5),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
