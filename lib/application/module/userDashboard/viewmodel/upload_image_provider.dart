import 'dart:io';

import 'package:flutter/cupertino.dart';


class UploadProvider with ChangeNotifier {
  final Map<String, File?> _images = {};

  File? getImage(String key) => _images[key];

  bool isUploaded(String key) => _images[key] != null;

  void setImage(String key, File file) {
    _images[key] = file;
    notifyListeners();
  }

  void clearImage(String key) {
    _images[key] = null;
    notifyListeners();
  }
}
