// This is a basic Flutter widget test for HesapTakip.
// It verifies that the LoginScreen renders and navigation to RegisterScreen works.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesaptakip/app.dart';

void main() {
  testWidgets('Login renders and navigates to Register', (WidgetTester tester) async {
    // Uygulamayı yükle
    await tester.pumpWidget(const HesapTakipApp());

    // Login ekranındaki temel ögeleri gör
    expect(find.text('VERTO'), findsOneWidget);
    expect(find.text('Giriş Yap'), findsOneWidget);
    expect(find.text('Kayıt Ol'), findsOneWidget);

    // "Kayıt Ol" butonuna bas -> RegisterScreen'e geç
    await tester.tap(find.text('Kayıt Ol'));
    await tester.pumpAndSettle();

    // RegisterScreen başlığını gör (biz "Yeni Hesap Oluştur" kullanıyoruz)
    expect(find.text('Yeni Hesap Oluştur'), findsWidgets); // AppBar + başlık metni

    // İlk sayfadaki bazı alanlar
    expect(find.text('Ad'), findsOneWidget);
    expect(find.text('Soyad'), findsOneWidget);
    expect(find.text('E-posta'), findsOneWidget);

    // "Devam Et" butonu görünsün
    expect(find.text('Devam Et'), findsOneWidget);
  });
}
