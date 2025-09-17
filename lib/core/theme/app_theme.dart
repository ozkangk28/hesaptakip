import 'package:flutter/material.dart';

class AppColors {
  // Zaten var olanlar (senin projenden)
  static const background = Color(0xFFF9F7F1);
  static const greenDark  = Color(0xFF0B3D2E);
  static const gold       = Color(0xFFD4AF37);

  // HEADER gradient
  static const gradientTopBlack   = Colors.black;
  static const gradientBottomDeep = greenDark;

  // İç panel (koyu kart kabı)
  static const panelOuter = Color(0xFF071C18); // dış koyu katman
  static const panelInner = Color(0xFF0E2B22); // iç koyu katman

  // İçerik kartlarının krem tonları
  static const cardCream1 = Color(0xFFEFEAD9);
  static const cardCream2 = Color(0xFFF4EFE2);

  // Tipografi / vurgular
  static const ink         = Color(0xFF0E1A16);   // koyu yazı
  static const success     = greenDark;           // gelir
  static const danger      = Color(0xFFB33A2E);   // gider
  static const neutral600  = Color(0xFF6D6D6D);   // borç

  // Küçük ikon zemini (yumuşak yeşil)
  static const badgeSoftGreen = Color(0xFFBFD8C3);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.greenDark),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );
}
