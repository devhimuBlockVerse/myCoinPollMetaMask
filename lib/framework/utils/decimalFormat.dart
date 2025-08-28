
import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({this.decimalRange = 2});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;


    if (newText.split('.').length > 2) {
      return oldValue;

    }

    if (newText.isEmpty) {
      return newValue;
    }

    final RegExp regExp = RegExp(r'^\d*\.?\d*$');
    if (regExp.hasMatch(newText)) {
      return newValue;
    }

    return oldValue;
  }
}