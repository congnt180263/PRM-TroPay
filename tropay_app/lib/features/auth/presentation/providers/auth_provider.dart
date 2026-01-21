import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        _currentUser = UserModel.fromJson(json.decode(userJson));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    }
  }

  Future<void> _saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(user.toJson()));
    } catch (e) {
      debugPrint('Error saving user: $e');
    }
  }

  Future<void> _clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
    } catch (e) {
      debugPrint('Error clearing user: $e');
    }
  }

  Future<bool> login({
    required String phoneOrEmail,
    required String password,
    required UserRole role,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Replace with actual API call when backend is ready
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock success response - Replace with actual API call
      final mockUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: 'User Test',
        phone: phoneOrEmail.contains('@') ? '0123456789' : phoneOrEmail,
        email: phoneOrEmail.contains('@') ? phoneOrEmail : null,
        role: role,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      _currentUser = mockUser;
      await _saveUser(mockUser);
      
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
    required String phone,
    String? email,
    required String password,
    required UserRole role,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Replace with actual API call when backend is ready
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock success response - Replace with actual API call
      final mockUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName,
        phone: phone,
        email: email,
        role: role,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      _currentUser = mockUser;
      await _saveUser(mockUser);
      
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
    _currentUser = null;
    await _clearUser();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
