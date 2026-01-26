import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tropay_app/core/theme/app_theme.dart';
import 'package:tropay_app/routes/app_router.dart';
import 'package:tropay_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:tropay_app/features/tenant/presentation/providers/tenant_provider.dart';
import 'package:tropay_app/features/owner/presentation/providers/owner_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TenantProvider()),
        ChangeNotifierProvider(create: (_) => OwnerProvider()),
      ],
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
