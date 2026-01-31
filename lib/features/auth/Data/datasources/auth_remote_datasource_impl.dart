import 'package:batch35_floorease/core/api/api_client.dart';
import 'package:batch35_floorease/core/api/api_endpoints.dart';
import 'package:batch35_floorease/features/auth/Data/datasources/auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<void> login(String email, String password) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );
    if (response['success'] == false) {
      throw Exception(response['message'] ?? 'Login failed');
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    final response = await apiClient.post(
      ApiEndpoints.register,
      body: {'name': name, 'email': email, 'password': password},
    );
    if (response['success'] == false) {
      throw Exception(response['message'] ?? 'Registration failed');
    }
  }
}
