 import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static Future<void> downloadWhitepaperPdf(BuildContext context) async {
    const String fileUrl = 'https://raw.githubusercontent.com/devhimuBlockVerse/ecm-whitepaper/main/ECM-Whitepaper.pdf';
    const String fileName = 'ECM-Whitepaper.pdf';

    try {
       final status = await Permission.storage.request();
      if (!status.isGranted) {
        _showMessage(context, 'Storage permission is required.');
        return;
      }

      // Get the external storage directory
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        _showMessage(context, 'Unable to access storage.');
        return;
      }

      // Set file path
      final filePath = '${dir.path}/$fileName';

      // Start downloading
      final dio = Dio();
      await dio.download(fileUrl, filePath);

      _showMessage(context, 'Downloaded to: $filePath');

      // Open the downloaded file
      final result = await OpenFile.open(filePath);
      print(">>> Open result: ${result.message}");
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
