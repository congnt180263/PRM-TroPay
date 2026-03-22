/// API Configuration for TroPay Backend
class ApiConfig {
  ApiConfig._();

  // Base URL - Change this to your backend server URL
  // For local development: http://10.0.2.2:3000 (Android Emulator)
  // For iOS Simulator: http://localhost:3000
  // For physical device: http://YOUR_COMPUTER_IP:3000
  static const String baseUrl = 'http://10.128.89.196:3000/api';

  // ==================== Module: Auth ====================
  static const String auth = '$baseUrl/auth';
  static const String register = '$auth/register';
  static const String login = '$auth/login';
  static const String refreshToken = '$auth/refresh-token';
  static const String logout = '$auth/logout';
  static const String profile = '$auth/profile';
  static const String changePassword = '$auth/change-password';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';

  // ==================== Module: Buildings ====================
  static const String buildings = '$baseUrl/buildings';
  static const String myBuilding = '$buildings/my-building';
  static String buildingById(String id) => '$buildings/$id';
  static String buildingStats(String id) => '$buildings/$id/stats';

  // ==================== Module: Rooms ====================
  static const String rooms = '$baseUrl/rooms';
  static const String roomsDashboard = '$rooms/dashboard';
  static String roomById(String id) => '$rooms/$id';

  // ==================== Module: Leases ====================
  static const String leases = '$baseUrl/leases';
  static String leaseById(String id) => '$leases/$id';

  // ==================== Module: Invoices ====================
  static const String invoices = '$baseUrl/invoices';
  static String invoiceById(String id) => '$invoices/$id';

  // ==================== Module: Payments ====================
  static const String payments = '$baseUrl/payments';

  // ==================== Module: Services ====================
  static const String services = '$baseUrl/services';
  static String serviceById(String id) => '$services/$id';

  // ==================== Module: Tenant ====================
  static const String tenant = '$baseUrl/tenant';
  static const String maintenanceRequests = '$tenant/maintenance-requests';
  static const String maintenanceRequestsOwner = '$maintenanceRequests/owner';

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
