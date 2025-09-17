import 'package:flutter/material.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';
import 'package:hesaptakip/features/auth/presentation/screens/login_screen.dart';
import 'package:hesaptakip/core/router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class HesapTakipApp extends StatelessWidget {
  const HesapTakipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hesap Takip',
        theme: AppTheme.light,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.login,
        supportedLocales: const [Locale('tr', 'TR')],
        localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ],

    );

  }
}
