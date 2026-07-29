import 'dart:io';

import 'package:campus_connect_v2/core/network/api_client.dart';
import 'package:dio/dio.dart';

import '../models/user_model.dart';

class ProfileRemoteDataSource {
  Future<UserModel> getProfile() async {
    final response = await ApiClient.dio.get(
      "/users/me",
    );

    return UserModel.fromJson(
      response.data,
    );
  }

  Future<UserModel> updateProfile({
    required String name,
    required String college,
    required String course,
    required String year,
    required String bio,
    required String skills,
  }) async {
    final response = await ApiClient.dio.put(
      "/users/me",
      data: {
        "name": name,
        "college": college,
        "course": course,
        "year": year,
        "bio": bio,
        "skills": skills,
      },
    );

    return UserModel.fromJson(
      response.data,
    );
  }

  Future<String> uploadProfileImage(
    File image,
  ) async {
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
      ),
    });

    final response = await ApiClient.dio.post(
  "/users/me/profile-image",
  data: formData,
);

print("UPLOAD RESPONSE:");
print(response.data);

return response.data["image_url"];
  }
}