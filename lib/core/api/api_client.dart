import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors/failures.dart';
import 'api_endpoints.dart';

class ApiClient {
  final http.Client _httpClient;

  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

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
      final defaultHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };

      final response = await _httpClient
          .post(
            Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
            headers: defaultHeaders,
            body: jsonEncode(body),
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
    } on http.ClientException catch (e) {
      throw ApiFailure(
        message: 'Network error: ${e.message}',
      );
    } catch (e) {
      throw ApiFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Handles HTTP response and returns decoded JSON or throws [ApiFailure]
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> decodedResponse =
          jsonDecode(response.body) as Map<String, dynamic>;
      return decodedResponse;
    } else {
      throw ApiFailure(
        statusCode: response.statusCode,
        message: _getErrorMessage(response),
      );
    }
  }

  /// Extracts error message from response
  String _getErrorMessage(http.Response response) {
    try {
      final Map<String, dynamic> errorBody =
          jsonDecode(response.body) as Map<String, dynamic>;
      return errorBody['message'] ??
          errorBody['error'] ??
          'Request failed with status code ${response.statusCode}';
    } catch (_) {
      return 'Request failed with status code ${response.statusCode}';
    }
  }
}
