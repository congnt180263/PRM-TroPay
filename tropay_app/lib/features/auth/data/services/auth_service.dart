import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/auth_models.dart';
import '../../../../core/services/http_client_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/constants/api_config.dart';
import 'dart:convert';

/// Authentication service for handling all auth API calls
class AuthService {
  final HttpClientService _httpClient = HttpClientService();
  final SecureStorageService _storage = SecureStorageService();

  /// Register new user
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      debugPrint('📝 Registering user: $email');

      final response = await _httpClient.post(
        ApiConfig.register,
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        },
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final registerResponse = RegisterResponse.fromJson(response.data['data']);

        // Save tokens to secure storage
        await _storage.saveTokens(
          accessToken: registerResponse.accessToken,
          refreshToken: registerResponse.refreshToken,
        );

        // Save user data
        await _storage.saveUserData(json.encode(registerResponse.user.toJson()));

        debugPrint('✅ Registration successful');
        return registerResponse;
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      debugPrint('❌ Registration error: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      debugPrint('❌ Registration error: $e');
      rethrow;
    }
  }

  /// Login user
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔐 Logging in user: $email');

      final response = await _httpClient.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final loginResponse = LoginResponse.fromJson(response.data['data']);

        // Save tokens to secure storage
        await _storage.saveTokens(
          accessToken: loginResponse.accessToken,
          refreshToken: loginResponse.refreshToken,
        );

        // Save user data
        await _storage.saveUserData(json.encode(loginResponse.user.toJson()));

        debugPrint('✅ Login successful');
        return loginResponse;
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      debugPrint('❌ Login error: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      debugPrint('❌ Login error: $e');
      rethrow;
    }
  }

  /// Get user profile
  Future<ProfileResponse> getProfile() async {
    try {
      debugPrint('👤 Getting user profile');

      final response = await _httpClient.get(ApiConfig.profile);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final profile = ProfileResponse.fromJson(response.data['data']);
        debugPrint('✅ Profile retrieved successfully');
        return profile;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get profile');
      }
    } on DioException catch (e) {
      debugPrint('❌ Get profile error: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      debugPrint('❌ Get profile error: $e');
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      debugPrint('🚪 Logging out user');

      // Call logout API (optional - to invalidate refresh token on server)
      try {
        await _httpClient.post(ApiConfig.logout);
      } catch (e) {
        debugPrint('⚠️ Logout API call failed: $e');
        // Continue with local logout even if API fails
      }

      // Clear all local storage
      await _storage.clearAll();

      debugPrint('✅ Logout successful');
    } catch (e) {
      debugPrint('❌ Logout error: $e');
      // Still clear storage even if there's an error
      await _storage.clearAll();
      rethrow;
    }
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      debugPrint('🔑 Changing password');

      final response = await _httpClient.post(
        ApiConfig.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        debugPrint('✅ Password changed successfully');
      } else {
        throw Exception(response.data['message'] ?? 'Failed to change password');
      }
    } on DioException catch (e) {
      debugPrint('❌ Change password error: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      debugPrint('❌ Change password error: $e');
      rethrow;
    }
  }

  /// Request password reset
  Future<void> forgotPassword({required String email}) async {
    try {
      debugPrint('📧 Requesting password reset for: $email');

      final response = await _httpClient.post(
        ApiConfig.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        debugPrint('✅ Password reset email sent');
      } else {
        throw Exception(response.data['message'] ?? 'Failed to send reset email');
      }
    } on DioException catch (e) {
      debugPrint('❌ Forgot password error: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      debugPrint('❌ Forgot password error: $e');
      rethrow;
    }
  }

  /// Reset password with token
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      debugPrint('🔄 Resetting password with token');

      final response = await _httpClient.post(
        ApiConfig.resetPassword,
        data: {
          'resetToken': resetToken,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        debugPrint('✅ Password reset successful');
      } else {
        throw Exception(response.data['message'] ?? 'Failed to reset password');
      }
    } on DioException catch (e) {
      debugPrint('❌ Reset password error: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      debugPrint('❌ Reset password error: $e');
      rethrow;
    }
  }

  /// Refresh access token
  Future<RefreshTokenResponse> refreshToken() async {
    try {
      debugPrint('🔄 Refreshing access token');

      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _httpClient.post(
        ApiConfig.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final tokenResponse = RefreshTokenResponse.fromJson(response.data['data']);

        // Save new tokens
        await _storage.saveTokens(
          accessToken: tokenResponse.accessToken,
          refreshToken: tokenResponse.refreshToken,
        );

        debugPrint('✅ Token refreshed successfully');
        return tokenResponse;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to refresh token');
      }
    } on DioException catch (e) {
      debugPrint('❌ Refresh token error: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      debugPrint('❌ Refresh token error: $e');
      rethrow;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _storage.isAuthenticated();
  }

  /// Get saved user data from storage
  Future<UserData?> getSavedUser() async {
    try {
      final userJson = await _storage.getUserData();
      if (userJson != null && userJson.isNotEmpty) {
        return UserData.fromJson(json.decode(userJson));
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting saved user: $e');
      return null;
    }
  }

  /// Handle Dio errors
  String _handleError(DioException e) {
    String errorMessage = 'An error occurred';

    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        errorMessage = data['message'];
      } else if (e.response?.statusMessage != null) {
        errorMessage = e.response!.statusMessage!;
      }
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Connection timeout. Please check your internet connection.';
          break;
        case DioExceptionType.badResponse:
          errorMessage = 'Server error. Please try again later.';
          break;
        case DioExceptionType.cancel:
          errorMessage = 'Request cancelled.';
          break;
        case DioExceptionType.unknown:
          errorMessage = 'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = 'An unexpected error occurred.';
      }
    }

    return errorMessage;
  }
}
