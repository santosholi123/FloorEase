import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:batch35_floorease/features/auth/presentation/pages/login_screen.dart';
import 'package:batch35_floorease/features/profile/presentation/provider/profile_provider.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required this.loginUseCase, required this.registerUseCase});

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  bool isLoading = false;
  String? errorMessage;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await loginUseCase(email, password);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await registerUseCase(fullName, email, phone, password);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await _secureStorage.delete(key: 'auth_token');
    context.read<ProfileProvider>().profile = null;
    context.read<ProfileProvider>().notifyListeners();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}
