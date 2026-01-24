import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tropay_app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null);
  runApp(const MyApp());
}
