 import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
 import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mycoinpoll_metamask/framework/utils/customToastMessage.dart';
import 'package:mycoinpoll_metamask/framework/utils/enums/toast_type.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
   static Future<void> downloadWhitepaperPdf(BuildContext context) async {
    const  fileUrl = 'https://raw.githubusercontent.com/devhimuBlockVerse/ecm-whitepaper/main/ECM-Whitepaper-v3.pdf';
    const  fileName = 'ECM-Whitepaper-v3.pdf';


    if (Platform.isAndroid && (await DeviceInfoPlugin().androidInfo).version.sdkInt >= 30) {
      if (!await Permission.manageExternalStorage.isGranted) {
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          final intent = AndroidIntent(
            action: 'android.settings.MANAGE_ALL_FILES_ACCESS_PERMISSION',
          );
          await intent.launch();
          return;
        }
      }
    }

    final downloadsDir = Directory('/storage/emulated/0/Download');
    final filePath = '${downloadsDir.path}/$fileName';

    await Dio().download(fileUrl, filePath);
    await OpenFile.open(filePath);

    ToastMessage.show(
        duration: CustomToastLength.LONG,
        type: MessageType.success,message: "Downloaded successfully!",
        subtitle: "Saved to: $filePath"
    );


  }

}