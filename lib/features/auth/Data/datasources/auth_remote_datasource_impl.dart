import 'package:batch35_floorease/core/api/api_client.dart';
import 'package:batch35_floorease/core/api/api_endpoints.dart';
import 'package:batch35_floorease/features/auth/Data/datasources/auth_remote_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl({required this.apiClient});

  final ApiClient apiClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> login(String email, String password) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
      requiresAuth: false,
    );
    if (response['success'] == false) {
      throw Exception(response['message'] ?? 'Login failed');
    }

    final token = _extractToken(response);
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  @override
  Future<void> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {
    final body = {
      'fullName': fullName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'password': password.trim(),
    };
    print('SIGNUP BODY: $body');

    final response = await apiClient.post(
      ApiEndpoints.register,
      body: body,
      requiresAuth: false,
    );
    if (response['success'] == false) {
      throw Exception(response['message'] ?? 'Registration failed');
    }
  }

  String? _extractToken(Map<String, dynamic> response) {
    final directToken = response['token']?.toString();
    if (directToken != null && directToken.isNotEmpty) {
      return directToken;
    }

    final accessToken = response['accessToken']?.toString();
    if (accessToken != null && accessToken.isNotEmpty) {
      return accessToken;
    }

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final nestedToken = data['token']?.toString();
      if (nestedToken != null && nestedToken.isNotEmpty) {
        return nestedToken;
      }
      final nestedAccessToken = data['accessToken']?.toString();
      if (nestedAccessToken != null && nestedAccessToken.isNotEmpty) {
        return nestedAccessToken;
      }
      final jwt = data['jwt']?.toString();
      if (jwt != null && jwt.isNotEmpty) {
        return jwt;
      }
    }

    return null;
  }
}
