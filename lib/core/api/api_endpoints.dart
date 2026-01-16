class ApiEndpoints {
  // Base configuration
  static const String baseUrl = 'https://api.floorease.com';
  static const Duration timeout = Duration(seconds: 30);

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
}
