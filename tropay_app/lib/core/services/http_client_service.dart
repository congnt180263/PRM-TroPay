import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_config.dart';
import 'secure_storage_service.dart';
import 'dart:convert';

/// HTTP Client service with automatic token refresh
class HttpClientService {
  static final HttpClientService _instance = HttpClientService._internal();
  factory HttpClientService() => _instance;
  HttpClientService._internal() {
    _initializeDio();
  }

  late Dio _dio;
  final SecureStorageService _storageService = SecureStorageService();
  bool _isRefreshing = false;
  final List<Function> _requestsQueue = [];

  Dio get dio => _dio;

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: ApiConfig.headers,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    // Add request interceptor to add auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Skip adding token for auth endpoints
          if (_isAuthEndpoint(options.path)) {
            return handler.next(options);
          }

          // Add access token to request
          final accessToken = await _storageService.getAccessToken();
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          debugPrint('🌐 Request: ${options.method} ${options.uri}');
          debugPrint('📤 Headers: ${options.headers}');
          if (options.data != null) {
            debugPrint('📦 Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
          debugPrint('📥 Data: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) async {
          debugPrint('❌ Error: ${error.response?.statusCode} ${error.requestOptions.uri}');
          debugPrint('📛 Error data: ${error.response?.data}');

          // Handle 401 Unauthorized - Token expired
          if (error.response?.statusCode == 401) {
            // Skip refresh for login/register endpoints
            if (_isAuthEndpoint(error.requestOptions.path)) {
              return handler.next(error);
            }

            // Try to refresh token
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the failed request with new token
              try {
                final response = await _retry(error.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            } else {
              // Refresh failed, logout user
              await _handleUnauthorized();
              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
    );

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh-token');
  }

  Future<bool> _refreshToken() async {
    if (_isRefreshing) {
      // Wait for ongoing refresh
      await Future.delayed(const Duration(seconds: 1));
      return await _storageService.getAccessToken() != null;
    }

    _isRefreshing = true;
    debugPrint('🔄 Refreshing token...');

    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('❌ No refresh token available');
        return false;
      }

      final response = await _dio.post(
        ApiConfig.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        // Save new tokens
        await _storageService.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        debugPrint('✅ Token refreshed successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Token refresh failed: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final accessToken = await _storageService.getAccessToken();
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $accessToken',
      },
    );

    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<void> _handleUnauthorized() async {
    debugPrint('🚪 Unauthorized - Clearing tokens');
    await _storageService.clearAll();
    // You can also navigate to login page here if you have access to navigation
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }
}
