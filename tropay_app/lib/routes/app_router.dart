import 'package:flutter/material.dart';
import 'package:tropay_app/features/auth/presentation/pages/login_page.dart';
import 'package:tropay_app/features/auth/presentation/pages/register_page.dart';
import 'package:tropay_app/features/auth/presentation/pages/role_selection_page.dart';
import 'package:tropay_app/features/auth/data/models/user_model.dart';
import 'package:tropay_app/features/home/presentation/pages/owner_home_page.dart';
import 'package:tropay_app/features/home/presentation/pages/tenant_home_page.dart';

class AppRouter {
  AppRouter._();

  static const String login = '/login';
  static const String roleSelection = '/role-selection';
  static const String register = '/register';
  static const String ownerHome = '/owner-home';
  static const String tenantHome = '/tenant-home';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionPage());

      case register:
        final UserRole role = settings.arguments as UserRole? ?? UserRole.tenant;
        return MaterialPageRoute(
          builder: (_) => RegisterPage(role: role),
        );

      case ownerHome:
        return MaterialPageRoute(builder: (_) => const OwnerHomePage());

      case tenantHome:
        return MaterialPageRoute(builder: (_) => const TenantHomePage());

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
    }
  }
}
