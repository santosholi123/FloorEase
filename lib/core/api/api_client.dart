import 'dart:async';
import 'package:dio/dio.dart';
import '../errors/failures.dart';
import 'api_endpoints.dart';

class ApiClient {
  final Dio _dio;

  ApiClient([Dio? dio]) : _dio = dio ?? Dio();

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
  }) async {
    try {
      final defaultHeaders = {'Content-Type': 'application/json', ...?headers};

      final response = await _dio
          .post(
            '${ApiEndpoints.baseUrl}$endpoint',
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
    } catch (e) {
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
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
