
import 'package:flutter/cupertino.dart';

class DashboardNavProvider with ChangeNotifier {
  int _currentIndex = 0; // default tab Dashboard

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
