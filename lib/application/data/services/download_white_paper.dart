 import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../framework/utils/customToastMessage.dart';
import '../../../framework/utils/enums/toast_type.dart';

class DownloadService {
  static Future<void> downloadWhitepaperPdf(BuildContext context) async {
    const String fileUrl = 'https://raw.githubusercontent.com/devhimuBlockVerse/ecm-whitepaper/main/ECM-Whitepaper.pdf';
    const String fileName = 'ECM-Whitepaper.pdf';

    try {
       final status = await Permission.storage.request();
      if (!status.isGranted) {
        ToastMessage.show(
          message: 'Storage permission is required.',
          type: MessageType.error,
        );
        return;
      }

      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        ToastMessage.show(
          message: 'Unable to access storage.',
          type: MessageType.error,
        );
        return;
      }

      final filePath = '${dir.path}/$fileName';

       final dio = Dio();
      await dio.download(fileUrl, filePath);
       ToastMessage.show(
         message: 'Downloaded successfully!',
         subtitle: 'Saved to: $filePath',
         type: MessageType.success,
       );
       final result = await OpenFile.open(filePath);
      print(">>> Open result: ${result.message}");
    } catch (e) {
      ToastMessage.show(
        message: 'Download failed.',
        subtitle: '$e',
        type: MessageType.error,
      );
    }
  }

 }
