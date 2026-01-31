import 'package:batch35_floorease/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase({required this.authRepository});

  final AuthRepository authRepository;

  Future<void> call(String name, String email, String password) {
    return authRepository.register(name, email, password);
  }
}
