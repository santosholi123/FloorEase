import 'package:flutter/foundation.dart';
import '../services/storage/auth_service.dart';
import '../errors/failures.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  AuthProvider({required this.authService});

  bool isLoading = false;
  String? errorMessage;

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await authService.loginUser(email, password);
    } on ApiFailure catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'An unexpected error occurred: \\${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await authService.registerUser(name, email, password);
    } on ApiFailure catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'An unexpected error occurred: \\${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
