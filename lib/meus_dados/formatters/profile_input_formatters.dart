import 'package:flutter/services.dart';

class CpfInputFormatter extends TextInputFormatter {
  const CpfInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 11) return oldValue;

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  const PhoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 11) return oldValue;

    final buffer = StringBuffer();
    if (text.isNotEmpty) {
      buffer.write('(');
      for (var i = 0; i < text.length; i++) {
        if (i == 2) buffer.write(') ');
        if (i == 7 && text.length == 11) buffer.write('-');
        if (i == 6 && text.length == 10) buffer.write('-');
        buffer.write(text[i]);
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

String formatPhoneWithDynamicMask(String rawValue) {
  final digits = rawValue.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return '';

  final buffer = StringBuffer();
  buffer.write('(');

  for (var i = 0; i < digits.length; i++) {
    if (i == 2) buffer.write(') ');
    if (digits.length > 10 && i == 7) buffer.write('-');
    if (digits.length <= 10 && i == 6) buffer.write('-');
    buffer.write(digits[i]);
  }

  return buffer.toString();
}
