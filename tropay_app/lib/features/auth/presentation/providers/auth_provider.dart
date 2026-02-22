import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';
import '../../data/models/auth_models.dart';
import '../../data/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  UserData? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserData? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check if user is authenticated
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        // Try to get saved user data
        _currentUser = await _authService.getSavedUser();

        // If saved user exists, try to get fresh profile from server
        if (_currentUser != null) {
          try {
            final profile = await _authService.getProfile();
            _currentUser = UserData(
              id: profile.id,
              email: profile.email,
              fullName: profile.fullName,
              role: profile.role,
            );
          } catch (e) {
            debugPrint('⚠️ Failed to fetch fresh profile: $e');
            // Keep using saved user data
          }
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authService.login(
        email: email,
        password: password,
      );

      _currentUser = response.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authService.register(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      _currentUser = response.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.logout();

      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
      // Clear user even if logout fails
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.forgotPassword(email: email);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshProfile() async {
    try {
      final profile = await _authService.getProfile();
      _currentUser = UserData(
        id: profile.id,
        email: profile.email,
        fullName: profile.fullName,
        role: profile.role,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing profile: $e');
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

