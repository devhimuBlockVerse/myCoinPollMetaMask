import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerWidget extends StatefulWidget {
  final Widget child;

  const PermissionHandlerWidget({Key? key, required this.child})
      : super(key: key);

  @override
  State<PermissionHandlerWidget> createState() =>
      _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    List<Permission> permissions = [];

    if (Platform.isAndroid) {
      if (sdkInt >= 33) {
        // Android 13+
        permissions = [
          // Permission.photos,
          Permission.audio,
        ];
      } else if (sdkInt >= 30) {
        // Android 11–12
        if (!await Permission.manageExternalStorage.isGranted) {
          final status = await Permission.manageExternalStorage.request();
          if (status.isDenied || status.isPermanentlyDenied) {
            final intent = AndroidIntent(
              action: 'android.settings.MANAGE_ALL_FILES_ACCESS_PERMISSION',
            );
            await intent.launch();
            return;
          }
        }
      } else {
        // Android 9 and below
        permissions = [Permission.storage];
      }
    }

    // Always ask for location
    permissions.add(Permission.location);

    Map<Permission, PermissionStatus> statuses = await permissions.request();
    bool allGranted = statuses.values.every((s) => s.isGranted);

    if (!allGranted) {
      bool permanentlyDenied =
      statuses.values.any((status) => status.isPermanentlyDenied);
      if (permanentlyDenied && mounted) {
        _showPermissionDialog();
      }
    }

    if (mounted) {
      setState(() {
        _permissionsGranted = allGranted;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Permissions Required"),
        content: const Text(
          "Some permissions were permanently denied. "
              "Please go to settings and allow them to continue using the app.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionsGranted) {
      return widget.child;
    } else {
      return const Scaffold(
        backgroundColor: Color(0xFF01090B),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
  }
}