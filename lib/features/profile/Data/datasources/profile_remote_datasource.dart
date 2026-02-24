import 'dart:io';

import 'package:batch35_floorease/core/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  Future<ProfileModel> getUserProfile() async {
    final response = await apiClient.get('/api/auth/profile');

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return ProfileModel.fromJson(data);
    }
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateUserProfile({
    required String fullName,
    required String email,
    required String phone,
    String? password,
  }) async {
    final body = {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      if (password != null && password.isNotEmpty) 'password': password,
    };

    final response = await apiClient.put('/api/auth/profile', body: body);

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return ProfileModel.fromJson(data);
    }
    return ProfileModel.fromJson(response);
  }

  Future<String> uploadImage(File file) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final response = await apiClient.postMultipart(
      '/api/upload',
      body: formData,
      headers: {'Content-Type': 'multipart/form-data'},
    );

    final imageUrl =
        response['imageUrl']?.toString() ??
        (response['data'] is Map<String, dynamic>
            ? response['data']['imageUrl']?.toString()
            : null);

    if (imageUrl == null || imageUrl.isEmpty) {
      throw Exception('Image upload failed');
    }

    return imageUrl;
  }

  Future<ProfileModel> updateProfileImage(String imageUrl) async {
    if (kDebugMode) {
      print('[ProfileRemoteDataSource] Calling PUT /api/auth/profile/image');
      print('[ProfileRemoteDataSource] Body: {"profileImage": "$imageUrl"}');
    }

    final response = await apiClient.put(
      '/api/auth/profile/image',
      body: {'profileImage': imageUrl},
    );

    if (kDebugMode) {
      print('[ProfileRemoteDataSource] PUT response: $response');
    }

    // Backend returns { "message": "...", "user": { profile data } }
    // or just the profile data directly
    final user = response['user'];
    if (user is Map<String, dynamic>) {
      return ProfileModel.fromJson(user);
    }
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> deleteProfileImage() async {
    final response = await apiClient.delete('/api/auth/profile/image');

    if (kDebugMode) {
      print(
        '[ProfileRemoteDataSource] DELETE /api/auth/profile/image response: $response',
      );
    }

    // Backend returns { "message": "...", "user": { profile data } }
    // or just the profile data directly
    final user = response['user'];
    if (user is Map<String, dynamic>) {
      return ProfileModel.fromJson(user);
    }
    return ProfileModel.fromJson(response);
  }
}
