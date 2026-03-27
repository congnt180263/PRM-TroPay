import 'package:flutter/material.dart';
import 'package:tropay_app/features/auth/presentation/pages/login_page.dart';
import 'package:tropay_app/features/auth/presentation/pages/register_page.dart';
import 'package:tropay_app/features/auth/presentation/pages/role_selection_page.dart';
import 'package:tropay_app/features/auth/data/models/user_model.dart';
import 'package:tropay_app/features/home/presentation/pages/owner_home_page.dart';
import 'package:tropay_app/features/home/presentation/pages/tenant_home_page.dart';
import 'package:tropay_app/features/owner/presentation/pages/building_setup_page.dart';
import 'package:tropay_app/features/owner/presentation/pages/building_edit_page.dart';
import 'package:tropay_app/features/tenant/presentation/pages/payment_result_page.dart';

class AppRouter {
  AppRouter._();

  static const String login = '/login';
  static const String roleSelection = '/role-selection';
  static const String register = '/register';
  static const String ownerHome = '/owner-home';
  static const String tenantHome = '/tenant-home';

  // Building routes
  static const String buildingSetup = '/owner/building-setup';
  static const String buildingEdit = '/owner/building-edit';

  // Payment routes
  static const String paymentResult = '/payment/result';

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

      case buildingSetup:
        return MaterialPageRoute(
          builder: (_) => const BuildingSetupPage(),
          settings: settings,
        );

      case buildingEdit:
        return MaterialPageRoute(
          builder: (_) => const BuildingEditPage(),
        );

      case ownerHome:
        return MaterialPageRoute(builder: (_) => const OwnerHomePage());

      case tenantHome:
        return MaterialPageRoute(builder: (_) => const TenantHomePage());

      case paymentResult:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => PaymentResultPage(
            paymentId: args['paymentId'] as String? ?? '',
            orderId: args['orderId'] as String?,
            resultCode: args['resultCode'] as String?,
            transId: args['transId'] as String?,
            status: args['status'] as String?,
            message: args['message'] as String?,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
    }
  }
}
