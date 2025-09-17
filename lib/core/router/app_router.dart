import 'package:flutter/material.dart';
import 'package:hesaptakip/features/auth/presentation/screens/login_screen.dart';

class AppRouter {
  static const login = '/login';


  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Sayfa bulunamadı')),
          ),
        );
    }
  }
}
