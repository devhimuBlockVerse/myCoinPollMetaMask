import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class PersonalViewModel extends ChangeNotifier{

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  File? get pickedImage => _pickedImage;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pickedImage = File(pickedFile.path);
      print("✅ Image picked: ${_pickedImage!.path}");
      notifyListeners();
    } else {
      print("⚠️ No image picked");
    }
  }

}