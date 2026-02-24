import 'package:batch35_floorease/features/auth/domain/repositories/auth_repository.dart';

class VerifyResetOtpUsecase {
  final AuthRepository repository;

  VerifyResetOtpUsecase({required this.repository});

  Future<void> call(String email, String otp) async {
    return repository.verifyResetOtp(email, otp);
  }
}
