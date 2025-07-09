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
    // Ensure widgets are bound and navigator is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (toastContextNavigatorKey.currentState?.mounted ?? false) {
        final overlayState = toastContextNavigatorKey.currentState?.overlay;
        if (overlayState == null) {
          debugPrint('ToastMessage Error: Overlay state not available');
          return;
        }

        final overlayEntry = OverlayEntry(
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
                ),
              ),
            ),
          ),
        );

        overlayState.insert(overlayEntry);

        Future.delayed(
          Duration(seconds: duration == CustomToastLength.SHORT ? 2 : 4),
              () => overlayEntry.remove(),
        );
      } else {
        debugPrint('ToastMessage Error: Navigator not mounted');
      }
    });
  }
}

class _ToastContent extends StatelessWidget {
  final String message;
  final String? subtitle;
  final MessageType type;

  const _ToastContent({
    required this.message,
    this.subtitle,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.95 > 500 ? 500.0 : screenWidth * 0.95;



    final (List<Color> colors, String icon) = switch (type) {
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

    return Container(
      width: screenWidth * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),

      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: colors,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1.0, color: Color(0xFF2B2D40)),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          SvgPicture.asset(icon, width: 24.0, height: 24.0),
          const SizedBox(width: 10.0),

          // Divider
          Container(
            width: 1.0,
            height: 24.0,
            color: Colors.white.withOpacity(0.5),
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
          ),
          const SizedBox(width: 10.0),

          // Message
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontFamily: 'Poppins',
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: Color(0xFFC7C5C5),
                      fontSize: 12.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}