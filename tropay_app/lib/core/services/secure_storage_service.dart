import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_config.dart';

/// Secure storage service for storing sensitive data like tokens
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Save access token
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(
        key: ApiConfig.accessTokenKey,
        value: token,
      );
    } catch (e) {
      debugPrint('Error saving access token: $e');
      rethrow;
    }
  }

  // Get access token
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: ApiConfig.accessTokenKey);
    } catch (e) {
      debugPrint('Error reading access token: $e');
      return null;
    }
  }

  // Save refresh token
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(
        key: ApiConfig.refreshTokenKey,
        value: token,
      );
    } catch (e) {
      debugPrint('Error saving refresh token: $e');
      rethrow;
    }
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: ApiConfig.refreshTokenKey);
    } catch (e) {
      debugPrint('Error reading refresh token: $e');
      return null;
    }
  }

  // Save user data
  Future<void> saveUserData(String userData) async {
    try {
      await _storage.write(
        key: ApiConfig.userKey,
        value: userData,
      );
    } catch (e) {
      debugPrint('Error saving user data: $e');
      rethrow;
    }
  }

  // Get user data
  Future<String?> getUserData() async {
    try {
      return await _storage.read(key: ApiConfig.userKey);
    } catch (e) {
      debugPrint('Error reading user data: $e');
      return null;
    }
  }

  // Save tokens (both access and refresh)
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await Future.wait([
        saveAccessToken(accessToken),
        saveRefreshToken(refreshToken),
      ]);
    } catch (e) {
      debugPrint('Error saving tokens: $e');
      rethrow;
    }
  }

  // Check if user is authenticated (has access token)
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Clear all stored data
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('Error clearing storage: $e');
      rethrow;
    }
  }

  // Clear only tokens
  Future<void> clearTokens() async {
    try {
      await Future.wait([
        _storage.delete(key: ApiConfig.accessTokenKey),
        _storage.delete(key: ApiConfig.refreshTokenKey),
      ]);
    } catch (e) {
      debugPrint('Error clearing tokens: $e');
      rethrow;
    }
  }

  // Delete specific key
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      debugPrint('Error deleting key $key: $e');
      rethrow;
    }
  }

  // Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      debugPrint('Error checking key $key: $e');
      return false;
    }
  }

  // Read all data (for debugging)
  Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      debugPrint('Error reading all data: $e');
      return {};
    }
  }
}
