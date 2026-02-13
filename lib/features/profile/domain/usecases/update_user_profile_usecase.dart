import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  UpdateUserProfileUseCase(this.repository);

  final ProfileRepository repository;

  Future<ProfileEntity> call({
    required String fullName,
    required String email,
    required String phone,
    String? password,
  }) {
    return repository.updateUserProfile(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    );
  }
}
