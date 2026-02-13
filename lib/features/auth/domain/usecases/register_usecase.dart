import 'package:batch35_floorease/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase({required this.authRepository});

  final AuthRepository authRepository;

  Future<void> call(
    String fullName,
    String email,
    String phone,
    String password,
  ) {
    return authRepository.register(fullName, email, phone, password);
  }
}
