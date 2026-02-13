import 'dart:io';

import '../repositories/profile_repository.dart';

class UploadProfileImageUseCase {
  UploadProfileImageUseCase(this.repository);

  final ProfileRepository repository;

  Future<String> call(File file) {
    return repository.uploadProfileImage(file);
  }
}
