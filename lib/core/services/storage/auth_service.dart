import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/errors/failures.dart';
import '../../../core/models/user.dart';
import '../hive/hive_service.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService({required this.apiClient});

  /// Registers a new user
  Future<Map<String, dynamic>> registerUser(
      String name, String email, String password) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register,
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return response;
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw ApiFailure(message: 'Registration failed: ${e.toString()}');
    }
  }

  /// Logs in a user, saves token and user data
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login,
        body: {
          'email': email,
          'password': password,
        },
      );
      // Save token and user data on successful login
      if (response.containsKey('token')) {
        final token = response['token'] as String;
        final userData = response['user'] as Map<String, dynamic>?;
        // Save token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        // Save user in Hive (optional: update fields as needed)
        if (userData != null) {
          final user = User(
            name: userData['name'] ?? '',
            email: userData['email'] ?? '',
            password: '', // Do not store password
          );
          final box = HiveService.usersBox();
          await box.clear(); // Only one user/session
          await box.add(user);
        }
      }
      return response;
    } on ApiFailure {
      rethrow;
    } catch (e) {
      throw ApiFailure(message: 'Login failed: ${e.toString()}');
    }
  }
}
