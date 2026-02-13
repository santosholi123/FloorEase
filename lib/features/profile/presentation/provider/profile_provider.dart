import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:batch35_floorease/core/errors/failures.dart';
import 'package:batch35_floorease/features/profile/domain/entities/profile_entity.dart';
import 'package:batch35_floorease/features/profile/domain/usecases/delete_profile_image_usecase.dart';
import 'package:batch35_floorease/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:batch35_floorease/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:batch35_floorease/features/profile/domain/usecases/update_profile_image_usecase.dart';
import 'package:batch35_floorease/features/profile/domain/usecases/upload_profile_image_usecase.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(
    this.getUserProfileUseCase,
    this.uploadProfileImageUseCase,
    this.updateProfileImageUseCase,
    this.deleteProfileImageUseCase,
    this.updateUserProfileUseCase,
  );

  final GetUserProfileUseCase getUserProfileUseCase;
  final UploadProfileImageUseCase uploadProfileImageUseCase;
  final UpdateProfileImageUseCase updateProfileImageUseCase;
  final DeleteProfileImageUseCase deleteProfileImageUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  ProfileEntity? profile;
  bool isLoading = false;
  bool isImageLoading = false;
  String? error;
  String? actionMessage;

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      profile = await getUserProfileUseCase();
    } catch (e) {
      if (e is ApiFailure) {
        error = e.message;
      } else {
        error = e.toString();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeImage(File file) async {
    try {
      isImageLoading = true;
      actionMessage = null;
      error = null;
      notifyListeners();

      final imageUrl = await uploadProfileImageUseCase(file);
      profile = await updateProfileImageUseCase(imageUrl);
      if (profile?.profileImage == null || profile!.profileImage!.isEmpty) {
        profile = await getUserProfileUseCase();
      }
      actionMessage = 'Profile image updated';
    } catch (e) {
      if (e is ApiFailure) {
        error = e.message;
      } else {
        error = e.toString();
      }
    } finally {
      isImageLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeImage() async {
    try {
      isImageLoading = true;
      actionMessage = null;
      error = null;
      notifyListeners();

      profile = await deleteProfileImageUseCase();
      actionMessage = 'Profile image removed';
    } catch (e) {
      if (e is ApiFailure) {
        error = e.message;
      } else {
        error = e.toString();
      }
    } finally {
      isImageLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    required String phone,
    String? password,
    TextEditingController? nameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
  }) async {
    try {
      isLoading = true;
      actionMessage = null;
      error = null;
      notifyListeners();

      profile = await updateUserProfileUseCase(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      if (profile == null ||
          (profile!.fullName.isEmpty &&
              profile!.email.isEmpty &&
              profile!.phone.isEmpty)) {
        await fetchProfile();
      }

      if (profile != null) {
        nameController?.text = profile!.fullName;
        emailController?.text = profile!.email;
        phoneController?.text = profile!.phone;
      }
      actionMessage = 'Profile updated';
    } catch (e) {
      if (e is ApiFailure) {
        error = e.message;
      } else {
        error = e.toString();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
