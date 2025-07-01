import 'package:flutter/material.dart';

class BottomNavProvider with ChangeNotifier {
  int _currentIndex = 0; // default tab (Home)
  String _fullName = 'John Doe';


  int get currentIndex => _currentIndex;
  String get fullName => _fullName;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }


  void setFullName(String name) {
    _fullName = name;
    notifyListeners();
  }
}
