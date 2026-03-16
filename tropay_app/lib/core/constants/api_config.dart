/// API Configuration for TroPay Backend
class ApiConfig {
  ApiConfig._();

  // Base URL - Change this to your backend server URL
  // For local development: http://10.0.2.2:3000 (Android Emulator)
  // For iOS Simulator: http://localhost:3000
  // For physical device: http://YOUR_COMPUTER_IP:3000
  static const String baseUrl = 'http://localhost:3000/api';

  // API Endpoints
  static const String auth = '/auth';
  static const String users = '/users';
  static const String orders = '/orders';
  static const String payments = '/payments';
  static const String rooms = '/rooms';
  static const String services = '/services';
  static const String leases = '/leases';
  static const String invoices = '/invoices';
  static const String tenant = '/tenant';

  // Auth Endpoints
  static const String register = '$auth/register';
  static const String login = '$auth/login';
  static const String refreshToken = '$auth/refresh-token';
  static const String logout = '$auth/logout';
  static const String profile = '$auth/profile';
  static const String changePassword = '$auth/change-password';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';

  // Timeout configuration
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // Headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Map<String, String> headersWithAuth(String token) => {
        ...headers,
        'Authorization': 'Bearer $token',
      };
}
