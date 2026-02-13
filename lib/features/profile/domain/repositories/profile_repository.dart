import 'dart:io';

import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getUserProfile();
  Future<ProfileEntity> updateUserProfile({
    required String fullName,
    required String email,
    required String phone,
    String? password,
  });
  Future<String> uploadProfileImage(File file);
  Future<ProfileEntity> updateProfileImage(String imageUrl);
  Future<ProfileEntity> deleteProfileImage();
}
