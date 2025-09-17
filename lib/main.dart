import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TR yerelleştirme verilerini yükle
  await initializeDateFormatting('tr_TR');
  Intl.defaultLocale = 'tr_TR';

  runApp(const HesapTakipApp());
}
