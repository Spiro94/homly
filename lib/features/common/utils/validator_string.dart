// ignore_for_file: overridden_fields

import 'package:flutter/services.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';

class ValidatorString extends FlutterPwValidatorStrings {
  @override
  final String atLeast = 'Al menos - caracteres';
  @override
  final String normalLetters = '- letras';
  @override
  final String uppercaseLetters = '- mayúsculas';
  @override
  final String numericCharacters = '- números';
  @override
  final String specialCharacters = '- caracteres especiales';
}

class LatLongFormatter extends TextInputFormatter {
  static const separator = '.';
  static const maxLength = 10;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    if (_isValidInput(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }

  bool _isValidInput(String value) {
    final regex = RegExp(r'^-?\d{1,3}(\.\d{1,6})?$');
    if (regex.hasMatch(value)) {
      final parts = value.split(separator);
      if (parts.length > 2) {
        return false;
      }
      if (parts.length == 2 && parts[1].length > 6) {
        return false;
      }
      final doubleValue = double.tryParse(value);
      if (doubleValue == null || doubleValue < -90.0 || doubleValue > 90.0) {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }
}
