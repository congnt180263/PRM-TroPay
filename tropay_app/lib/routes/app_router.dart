import 'package:flutter/material.dart';
import 'package:tropay_app/features/home/presentation/pages/home_page.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      // Add more routes here as needed
      // case login:
      //   return MaterialPageRoute(
      //     builder: (_) => const LoginPage(),
      //   );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
