import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUseCase {
  GetUserProfileUseCase(this.repository);

  final ProfileRepository repository;

  Future<ProfileEntity> call() {
    return repository.getUserProfile();
  }
}
