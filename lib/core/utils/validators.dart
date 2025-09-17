class Validators {
  /// TC Kimlik No doğrulaması
  /// - 11 hane olmalı
  /// - İlk hane 0 olamaz
  /// - 10. ve 11. hane kontrolü
  static String? tc(String? v) {
    final s = (v ?? '').trim();
    if (s.length != 11) return '11 haneli TC giriniz';
    if (!RegExp(r'^\d{11}$').hasMatch(s)) return 'Sadece rakam';
    if (s[0] == '0') return 'İlk hanesi 0 olamaz';

    final d = s.split('').map(int.parse).toList();
    final odd  = d[0] + d[2] + d[4] + d[6] + d[8];
    final even = d[1] + d[3] + d[5] + d[7];
    final h10 = ((odd * 7) - even) % 10;
    final h11 = (d.take(10).reduce((a, b) => a + b)) % 10;

    if (h10 != d[9] || h11 != d[10]) return 'Geçersiz TC Kimlik No';
    return null;
  }

  /// 6 haneli sayısal PIN/şifre
  static String? pin6(String? v) {
    final s = (v ?? '').trim();
    if (!RegExp(r'^\d{6}$').hasMatch(s)) return '6 haneli rakam girin';
    return null;
  }

  /// Türkiye mobil telefon numarası: 10 hane, 5xx xxx xx xx
  /// (Maskeden gelen boşlukları temizler)
  static String? trPhone10(String? v) {
    final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
    if (!RegExp(r'^5\d{9}$').hasMatch(digits)) {
      return 'Telefon 10 hane olmalı (5xx xxx xx xx)';
    }
    return null;
  }
  static final RegExp _nameAllowed =
  RegExp(r"^[a-zA-ZğüşöçİıĞÜŞÖÇ\s'-]+$");

  /// Ad/Soyad: yalnız harf (TR+EN), boşluk, apostrof (') ve tire (-)
  static String? name(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Bu alan gerekli';
    if (s.length < 2) return 'En az 2 karakter';
    if (!_nameAllowed.hasMatch(s)) {
      return 'Kabul edilmeyen karakter var';
    }
    return null;
  }
}
