import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tropay_app/core/theme/app_theme.dart';
import 'package:tropay_app/routes/app_router.dart';
import 'package:tropay_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:tropay_app/features/tenant/presentation/providers/tenant_provider.dart';
import 'package:tropay_app/features/owner/presentation/providers/owner_provider.dart';
import 'package:tropay_app/core/services/deep_link_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DeepLinkService _deepLinkService = DeepLinkService();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initDeepLinking();
  }

  void _initDeepLinking() {
    _deepLinkService.initialize();
    _deepLinkService.deepLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    print('Deep Link received: $uri');

    if (uri.scheme == 'prm' && uri.host == 'payment') {
      // MoMo returns: orderId, resultCode ("0"=success), message, extraData, transId
      final orderId = uri.queryParameters['orderId'] ?? '';
      final resultCode = uri.queryParameters['resultCode'] ?? '';
      final message = uri.queryParameters['message'] ?? '';
      final transId = uri.queryParameters['transId'] ?? '';

      // Convert MoMo resultCode to status
      final status = resultCode == '0' ? 'success' : 'failed';

      // Also check for direct paymentId (for other payment methods)
      final paymentId = uri.queryParameters['paymentId'] ?? orderId;

      if (paymentId.isNotEmpty) {
        _navigatorKey.currentState?.pushNamed(
          AppRouter.paymentResult,
          arguments: {
            'paymentId': paymentId,
            'orderId': orderId,
            'resultCode': resultCode,
            'transId': transId,
            'status': status,
            'message': message,
          },
        );
      } else {
        print('Deep Link Error: Missing paymentId/orderId');
      }
    }
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TenantProvider()),
        ChangeNotifierProvider(create: (_) => OwnerProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // Determine initial route based on auth state
          String initialRoute = AppRouter.login;

          if (authProvider.isAuthenticated && authProvider.currentUser != null) {
            if (authProvider.currentUser!.role == 'owner') {
              initialRoute = AppRouter.ownerHome;
            } else if (authProvider.currentUser!.role == 'tenant') {
              initialRoute = AppRouter.tenantHome;
            }
          }

          return MaterialApp(
            title: 'TroPay',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            navigatorKey: _navigatorKey,
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: initialRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
