import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

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
  int imageVersion = 0;

  /// Normalize image URL for Android emulator
  /// - If starts with /uploads, prepend baseUrl "http://10.0.2.2:4000"
  /// - If contains localhost/127.0.0.1, replace with 10.0.2.2
  String _normalizeImageUrl(String url) {
    if (url.isEmpty) return url;

    String normalized = url;

    // If it's a relative path starting with /uploads, prepend baseUrl
    if (normalized.startsWith('/uploads')) {
      normalized = 'http://10.0.2.2:4000$normalized';
    }

    // Replace localhost/127.0.0.1 with Android emulator host
    if (normalized.contains('localhost') || normalized.contains('127.0.0.1')) {
      normalized = normalized
          .replaceAll('localhost', '10.0.2.2')
          .replaceAll('127.0.0.1', '10.0.2.2');
    }

    return normalized;
  }

  void bumpImageVersion() {
    imageVersion++;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      profile = await getUserProfileUseCase();

      // Normalize profileImage URL for Android emulator
      if (profile?.profileImage != null && profile!.profileImage!.isNotEmpty) {
        final normalizedUrl = _normalizeImageUrl(profile!.profileImage!);
        profile = profile!.copyWith(profileImage: normalizedUrl);
      }
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

      // Step 1: Upload file to server and get image URL
      final imageUrl = await uploadProfileImageUseCase(file);

      if (imageUrl.isEmpty) {
        throw Exception('Image URL is empty');
      }

      if (kDebugMode) {
        print('[ProfileProvider] Uploaded imageUrl: $imageUrl');
      }

      // Step 2: Save ORIGINAL URL to database (backend will store as-is)
      // DO NOT normalize before sending to backend
      final updatedProfile = await updateProfileImageUseCase(imageUrl);

      if (kDebugMode) {
        print(
          '[ProfileProvider] PUT response profileImage: ${updatedProfile.profileImage}',
        );
      }

      // Step 3: Normalize the response from backend for Android emulator display
      if (updatedProfile.profileImage != null &&
          updatedProfile.profileImage!.isNotEmpty) {
        final normalizedUrl = _normalizeImageUrl(updatedProfile.profileImage!);
        profile = updatedProfile.copyWith(profileImage: normalizedUrl);

        if (kDebugMode) {
          print('[ProfileProvider] Normalized profileImage: $normalizedUrl');
        }
      } else {
        profile = updatedProfile;
      }

      // Step 4: Fetch updated profile from server to confirm DB update
      // fetchProfile() will also normalize the URL
      await fetchProfile();

      if (kDebugMode) {
        print(
          '[ProfileProvider] After fetchProfile, profileImage: ${profile?.profileImage}',
        );
      }

      // Step 5: Clear Flutter image cache to force fresh reload
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      // Step 6: Set success message and bump version
      actionMessage = 'Profile image updated';

      // Bump image version to trigger cache refresh
      bumpImageVersion();
    } catch (e) {
      if (e is ApiFailure) {
        error = e.message;
      } else {
        error = e.toString();
      }
      actionMessage = null;
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

      // Normalize profileImage URL for Android emulator
      if (profile?.profileImage != null && profile!.profileImage!.isNotEmpty) {
        final normalizedUrl = _normalizeImageUrl(profile!.profileImage!);
        profile = profile!.copyWith(profileImage: normalizedUrl);
      }

      actionMessage = 'Profile image removed';

      // Bump image version to trigger cache refresh
      bumpImageVersion();
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

      // Normalize profileImage URL for Android emulator
      if (profile?.profileImage != null && profile!.profileImage!.isNotEmpty) {
        final normalizedUrl = _normalizeImageUrl(profile!.profileImage!);
        profile = profile!.copyWith(profileImage: normalizedUrl);
      }

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
