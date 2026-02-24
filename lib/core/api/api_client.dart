import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../errors/failures.dart';
import 'api_endpoints.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiClient([Dio? dio, FlutterSecureStorage? secureStorage])
    : _dio = dio ?? Dio(),
      _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// POST method for authentication and other endpoints
  ///
  /// Parameters:
  /// - [endpoint]: The API endpoint to call
  /// - [body]: Request body containing email, password, etc.
  /// - [headers]: Optional custom headers (defaults to application/json)
  ///
  /// Returns: Decoded JSON response as Map<String, dynamic>
  ///
  /// Throws: [ApiFailure] on any error including timeout, socket exception, or bad response
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    try {
      final defaultHeaders = await _buildHeaders(
        headers: headers,
        requiresAuth: requiresAuth,
      );

      final baseUrl = await ApiEndpoints.baseUrl;
      final response = await _dio
          .post(
            '$baseUrl$endpoint',
            data: body,
            options: Options(headers: defaultHeaders),
          )
          .timeout(
            ApiEndpoints.timeout,
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiFailure(
        statusCode: 408,
        message: 'Request timeout. Please check your connection.',
      );
    } on ApiFailure {
      // Re-throw ApiFailure as-is (from _handleResponse)
      rethrow;
    } on DioException catch (e) {
      print('DioException type: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException error: ${e.error}');
      print('DioException response statusCode: ${e.response?.statusCode}');
      print('DioException response data: ${e.response?.data}');
      throw ApiFailure(message: 'Network error: ${e.message}');
    } on Exception catch (e) {
      if (e.toString() == 'Exception: Authentication token not found') {
        rethrow;
      }
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    } catch (e) {
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// GET method for fetching data
  ///
  /// Parameters:
  /// - [endpoint]: The API endpoint to call
  /// - [headers]: Optional custom headers (defaults to application/json)
  ///
  /// Returns: Decoded JSON response as Map<String, dynamic>
  ///
  /// Throws: [ApiFailure] on any error including timeout or bad response
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    try {
      final defaultHeaders = await _buildHeaders(
        headers: headers,
        requiresAuth: requiresAuth,
      );

      final baseUrl = await ApiEndpoints.baseUrl;
      final response = await _dio
          .get('$baseUrl$endpoint', options: Options(headers: defaultHeaders))
          .timeout(
            ApiEndpoints.timeout,
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiFailure(
        statusCode: 408,
        message: 'Request timeout. Please check your connection.',
      );
    } on ApiFailure {
      rethrow;
    } on DioException catch (e) {
      print('DioException type: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException error: ${e.error}');
      print('DioException response statusCode: ${e.response?.statusCode}');
      print('DioException response data: ${e.response?.data}');
      throw ApiFailure(message: 'Network error: ${e.message}');
    } on Exception catch (e) {
      if (e.toString() == 'Exception: Authentication token not found') {
        rethrow;
      }
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    } catch (e) {
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// PUT method for updating data
  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    try {
      final defaultHeaders = await _buildHeaders(
        headers: headers,
        requiresAuth: requiresAuth,
      );

      final baseUrl = await ApiEndpoints.baseUrl;
      final fullUrl = '$baseUrl$endpoint';

      if (kDebugMode) {
        print('[ApiClient] PUT $fullUrl');
        print('[ApiClient] Headers: $defaultHeaders');
        print('[ApiClient] Body: $body');
      }

      final response = await _dio
          .put(
            fullUrl,
            data: body,
            options: Options(headers: defaultHeaders),
          )
          .timeout(
            ApiEndpoints.timeout,
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      if (kDebugMode) {
        print('[ApiClient] PUT Response Status: ${response.statusCode}');
        print('[ApiClient] PUT Response Data: ${response.data}');
      }

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiFailure(
        statusCode: 408,
        message: 'Request timeout. Please check your connection.',
      );
    } on ApiFailure {
      rethrow;
    } on DioException catch (e) {
      print('DioException type: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException error: ${e.error}');
      print('DioException response statusCode: ${e.response?.statusCode}');
      print('DioException response data: ${e.response?.data}');
      throw ApiFailure(message: 'Network error: ${e.message}');
    } on Exception catch (e) {
      if (e.toString() == 'Exception: Authentication token not found') {
        rethrow;
      }
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    } catch (e) {
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// DELETE method for removing data
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    try {
      final defaultHeaders = await _buildHeaders(
        headers: headers,
        requiresAuth: requiresAuth,
      );

      final baseUrl = await ApiEndpoints.baseUrl;
      final response = await _dio
          .delete(
            '$baseUrl$endpoint',
            options: Options(headers: defaultHeaders),
          )
          .timeout(
            ApiEndpoints.timeout,
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiFailure(
        statusCode: 408,
        message: 'Request timeout. Please check your connection.',
      );
    } on ApiFailure {
      rethrow;
    } on DioException catch (e) {
      print('DioException type: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException error: ${e.error}');
      print('DioException response statusCode: ${e.response?.statusCode}');
      print('DioException response data: ${e.response?.data}');
      throw ApiFailure(message: 'Network error: ${e.message}');
    } on Exception catch (e) {
      if (e.toString() == 'Exception: Authentication token not found') {
        rethrow;
      }
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    } catch (e) {
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Multipart POST for file uploads
  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required FormData body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    try {
      final defaultHeaders = await _buildHeaders(
        headers: headers,
        requiresAuth: requiresAuth,
      );

      // Remove Content-Type header for multipart so Dio can set boundary automatically
      final mutableHeaders = Map<String, dynamic>.from(defaultHeaders);
      mutableHeaders.remove('Content-Type');

      final baseUrl = await ApiEndpoints.baseUrl;
      final response = await _dio
          .post(
            '$baseUrl$endpoint',
            data: body,
            options: Options(headers: mutableHeaders),
          )
          .timeout(
            ApiEndpoints.timeout,
            onTimeout: () {
              throw TimeoutException('Request timeout');
            },
          );

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiFailure(
        statusCode: 408,
        message: 'Request timeout. Please check your connection.',
      );
    } on ApiFailure {
      rethrow;
    } on DioException catch (e) {
      print('DioException type: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException error: ${e.error}');
      print('DioException response statusCode: ${e.response?.statusCode}');
      print('DioException response data: ${e.response?.data}');
      throw ApiFailure(message: 'Network error: ${e.message}');
    } on Exception catch (e) {
      if (e.toString() == 'Exception: Authentication token not found') {
        rethrow;
      }
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    } catch (e) {
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<Map<String, String>> _buildHeaders({
    Map<String, String>? headers,
    required bool requiresAuth,
  }) async {
    final baseHeaders = {'Content-Type': 'application/json', ...?headers};

    if (!requiresAuth) {
      return baseHeaders;
    }

    final token = await _secureStorage.read(key: 'auth_token');
    print('Token: $token');
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }

    return {...baseHeaders, 'Authorization': 'Bearer $token'};
  }

  /// Handles HTTP response and returns decoded JSON or throws [ApiFailure]
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data as Map<String, dynamic>;
    } else {
      throw ApiFailure(
        statusCode: response.statusCode,
        message: _getErrorMessage(response),
      );
    }
  }

  /// Extracts error message from response
  String _getErrorMessage(Response response) {
    try {
      final errorBody = response.data as Map<String, dynamic>?;
      return errorBody?['message'] ??
          errorBody?['error'] ??
          'Request failed with status code ${response.statusCode}';
    } catch (_) {
      return 'Request failed with status code ${response.statusCode}';
    }
  }
}
