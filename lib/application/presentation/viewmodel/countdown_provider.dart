import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerProvider extends ChangeNotifier {
  late Duration remaining;
  late DateTime targetDateTime;

  Timer? _timer;

  int get months => remaining.inDays ~/ 30;
  int get daysAfterMonths => remaining.inDays % 30;

  CountdownTimerProvider({required this.targetDateTime,}) {
    _startCountdown();
  }


  void _startCountdown() {
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    final now = DateTime.now();
    remaining = targetDateTime.difference(now);
    if (remaining.isNegative) {
      remaining = Duration.zero;
      _timer?.cancel();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
