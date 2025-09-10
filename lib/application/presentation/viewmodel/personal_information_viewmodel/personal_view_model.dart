import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalViewModel extends ChangeNotifier {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  String? _originalImagePath;

  File? get pickedImage => _pickedImage;
  String? get originalImagePath => _originalImagePath;

  PersonalViewModel() {
    _loadImageFromPrefs();
  }

  // Load the initial image path from SharedPreferences
  Future<void> _loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('userImagePath');
    if (imagePath != null && File(imagePath).existsSync()) {
      _pickedImage = File(imagePath);
      _originalImagePath = imagePath;
      notifyListeners();
    }
  }

  // Pick a new image from the gallery
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pickedImage = File(pickedFile.path);
       notifyListeners();
    } else {
      print("⚠️ No image picked");
    }
  }

  // Save the current picked image path to SharedPreferences
  // Future<void> saveImageToPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (_pickedImage != null) {
  //     await prefs.setString('userImagePath', _pickedImage!.path);
  //     _originalImagePath = _pickedImage!.path;
  //    } else {
  //     await prefs.remove('userImagePath');
  //     _originalImagePath = null;
  //     print("✅ Image path removed from SharedPreferences.");
  //   }
  // }



  Future<void> saveImageToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_pickedImage != null) {
      final newPath = await saveImagePermanently(_pickedImage!);
      await prefs.setString('userImagePath', newPath);
      _pickedImage = File(newPath);
      _originalImagePath = newPath;
    } else {
      await prefs.remove('userImagePath');
      _originalImagePath = null;
      print("✅ Image path removed from SharedPreferences.");
    }
    notifyListeners();
  }


   bool hasImageChanged() {
    return _pickedImage?.path != _originalImagePath;
  }


  void resetImageChange(){
    if(_pickedImage!= null){
      _originalImagePath = _pickedImage!.path;
    }else{
      _originalImagePath = null;
    }
    notifyListeners();
  }


  Future<String> saveImagePermanently(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = image.path.split('/').last;
    final newPath = '${directory.path}/profile_images/$fileName';
    await Directory('${directory.path}/profile_images').create(recursive: true);
    final newFile = await image.copy(newPath);
    return newFile.path;
  }


}


