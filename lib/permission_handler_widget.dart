// lib/utils/permission_handler_widget.dart (create this new file)
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerWidget extends StatefulWidget {
  final Widget child;

  const PermissionHandlerWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<PermissionHandlerWidget> createState() => _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request storage and any other necessary permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.location,
    ].request();

    bool allGranted = true;
    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        allGranted = false;
        print('Permission not granted: ${permission.toString()} - ${status.toString()}');
      }
    });

    if (mounted) {
      setState(() {
        _permissionsGranted = allGranted;
      });

    }
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