import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static Future<void> downloadWhitepaperPdf(BuildContext context) async {
    const String fileUrl =
        'https://raw.githubusercontent.com/devhimuBlockVerse/ecm-whitepaper/main/ECM-Whitepaper.pdf';
    const String fileName = 'ECM-Whitepaper.pdf';

    try {
      // Request permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        _showMessage(context, 'Storage permission is required.');
        return;
      }

      // Save to Downloads folder
      final directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/$fileName';

      final dio = Dio();
      await dio.download(fileUrl, filePath);

      _showMessage(context, 'Downloaded to: $filePath');
    } catch (e) {
      _showMessage(context, 'Download failed: $e');
    }
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
