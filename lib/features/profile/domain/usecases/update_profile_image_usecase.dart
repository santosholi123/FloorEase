import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileImageUseCase {
  UpdateProfileImageUseCase(this.repository);

  final ProfileRepository repository;

  Future<ProfileEntity> call(String imageUrl) {
    return repository.updateProfileImage(imageUrl);
  }
}
