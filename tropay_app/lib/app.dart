import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tropay_app/core/theme/app_theme.dart';
import 'package:tropay_app/routes/app_router.dart';
import 'package:tropay_app/features/auth/presentation/providers/auth_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'TroPay',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.login,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
