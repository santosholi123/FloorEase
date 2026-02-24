import 'package:batch35_floorease/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUsecase {
  final AuthRepository repository;

  ForgotPasswordUsecase({required this.repository});

  Future<void> call(String email) async {
    return repository.forgotPassword(email);
  }
}
