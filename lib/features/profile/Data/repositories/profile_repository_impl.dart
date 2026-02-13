import 'dart:io';

import 'package:batch35_floorease/features/profile/domain/entities/profile_entity.dart';
import 'package:batch35_floorease/features/profile/domain/repositories/profile_repository.dart';

import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this.remoteDataSource);

  final ProfileRemoteDataSource remoteDataSource;

  @override
  Future<ProfileEntity> getUserProfile() async {
    return await remoteDataSource.getUserProfile();
  }

  @override
  Future<ProfileEntity> updateUserProfile({
    required String fullName,
    required String email,
    required String phone,
    String? password,
  }) async {
    return await remoteDataSource.updateUserProfile(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    );
  }

  @override
  Future<String> uploadProfileImage(File file) async {
    return await remoteDataSource.uploadImage(file);
  }

  @override
  Future<ProfileEntity> updateProfileImage(String imageUrl) async {
    return await remoteDataSource.updateProfileImage(imageUrl);
  }

  @override
  Future<ProfileEntity> deleteProfileImage() async {
    return await remoteDataSource.deleteProfileImage();
  }
}
