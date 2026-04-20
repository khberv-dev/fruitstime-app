import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length > 9) {
      digitsOnly = digitsOnly.substring(0, 9);
    }

    String formatted = '';

    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2 || i == 5 || i == 7) {
        formatted += ' ';
      }
      formatted += digitsOnly[i];
    }

    int cursorPosition = formatted.length;
    if (newValue.selection.baseOffset > 0) {
      int rawPosition = newValue.selection.baseOffset;
      int spacesBefore = _countSpacesBeforePosition(formatted, rawPosition);
      cursorPosition = rawPosition + spacesBefore;

      cursorPosition = cursorPosition.clamp(0, formatted.length);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  int _countSpacesBeforePosition(String text, int position) {
    int count = 0;
    for (int i = 0; i < position && i < text.length; i++) {
      if (text[i] == ' ') {
        count++;
      }
    }
    return count;
  }
}
