class ApiEndpoints {
  // Base configuration
  static const String baseUrl = 'http://10.0.2.2:4000';
  static const Duration timeout = Duration(seconds: 30);

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
}
