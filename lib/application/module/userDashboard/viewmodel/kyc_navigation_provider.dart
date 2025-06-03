import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../framework/utils/enums/kyc_track.dart';

class KycNavigationProvider with ChangeNotifier {
  KycScreenType? _lastVisitedScreen;

  KycScreenType? get lastVisitedScreen => _lastVisitedScreen;

  // void setLastVisitedScreen(KycScreenType screen) {
  //   _lastVisitedScreen = screen;
  //   notifyListeners();
  // }

  // Call this when any KYC screen is opened
  Future<void> setLastVisitedScreen(KycScreenType screen) async {
    _lastVisitedScreen = screen;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastVisitedKycScreen', screen.toString());
  }


  // Call this during app startup
  Future<void> loadLastVisitedScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final screenString = prefs.getString('lastVisitedKycScreen');

    if (screenString != null) {
      try {
        _lastVisitedScreen = KycScreenType.values.firstWhere(
              (e) => e.toString() == screenString,
        );
        notifyListeners();
      } catch (_) {
        _lastVisitedScreen = KycScreenType.kycScreen;
      }
    }
  }

}
