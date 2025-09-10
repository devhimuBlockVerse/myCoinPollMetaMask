
import 'package:flutter/cupertino.dart';


enum VestingType {
  none,
  ico,
  existingUser
}

class DashboardNavProvider with ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;


  VestingType _selectedVestingType = VestingType.none;
  VestingType get selectedVestingType => _selectedVestingType;



  void setIndex(int index) {
    _currentIndex = index;

    // If we navigate away from the vesting tab, reset the vesting type
    if (index != 3) {
      _selectedVestingType = VestingType.none;
    }
    notifyListeners();
  }

  void setVestingType(VestingType type) {
    _selectedVestingType = type;
    notifyListeners();
  }

}
