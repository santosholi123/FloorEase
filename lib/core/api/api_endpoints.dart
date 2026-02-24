import '../config/app_config.dart';

class ApiEndpoints {
  // Base configuration - dynamically determined based on device type
  static Future<String> get baseUrl async => await AppConfig.baseUrl;
  static const Duration timeout = Duration(seconds: 30);

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String verifyResetOtp = '/api/auth/verify-reset-otp';
  static const String resetPassword = '/api/auth/reset-password';

  // Profile endpoints
  static const String profile = '/profile';
}
