import 'package:batch35_floorease/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository repository;

  ResetPasswordUsecase({required this.repository});

  Future<void> call({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return repository.resetPassword(
      email: email,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
