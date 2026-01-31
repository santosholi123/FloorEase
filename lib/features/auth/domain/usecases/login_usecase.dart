import '../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase({required this.authRepository});

  final AuthRepository authRepository;

  Future<void> call(String email, String password) async {
    return authRepository.login(email, password);
  }
}
