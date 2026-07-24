import 'package:campus_connect_v2/core/network/api_client.dart';

import '../models/user_model.dart';

class ProfileRemoteDataSource {
  Future<UserModel> getProfile() async {
    final response = await ApiClient.dio.get(
      "/users/me",
    );

    return UserModel.fromJson(response.data);
  }

  Future<UserModel> updateProfile({
    required String name,
    required String college,
    required String course,
    required String year,
  }) async {
    final response = await ApiClient.dio.put(
      "/users/me",
      data: {
        "name": name,
        "college": college,
        "course": course,
        "year": year,
      },
    );

    return UserModel.fromJson(response.data);
  }
}