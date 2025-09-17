import 'package:flutter/services.dart';

/// TC Kimlik: sadece rakam, ilk hane 0 olamaz, en fazla 11 hane.
class TcknInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Sadece rakamları tut
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    }

    // İlk hane 0 ise kabul etme (eski değeri koru)
    if (digits[0] == '0') return oldValue;

    // 11 haneyle sınırla
    final limited = digits.length > 11 ? digits.substring(0, 11) : digits;

    return TextEditingValue(
      text: limited,
      selection: TextSelection.collapsed(offset: limited.length),
    );
  }
}

/// TR Telefon (10 hane, 5xx xxx xx xx maskesi). Sadece 5 ile başlayanı kabul eder.
/// Controller'da maskeli metin durur (boşluklu). Validasyon için rakamları ayıklayın.
class TrPhoneMaskInputFormatter extends TextInputFormatter {
  String _applyMask(String digits) {
    // En fazla 10 hane
    if (digits.length > 10) digits = digits.substring(0, 10);

    final b = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      b.write(digits[i]);
      // 5xx xxx xx xx → 3, 6 ve 8. haneden sonra boşluk
      if (i == 2 || i == 5 || i == 7) b.write(' ');
    }
    return b.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Sadece rakamları al
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // İlk hane 5 değilse yeni değeri reddet (eskiyi koru)
    if (digits.isNotEmpty && digits[0] != '5') return oldValue;

    final masked = _applyMask(digits);

    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
    );
  }
}
