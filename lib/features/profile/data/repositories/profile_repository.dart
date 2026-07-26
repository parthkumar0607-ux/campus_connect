import 'dart:io';

import '../datasource/profile_remote_datasource.dart';
import '../models/user_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource =
      ProfileRemoteDataSource();

  Future<UserModel> getProfile() async {
    return remoteDataSource.getProfile();
  }

  Future<UserModel> updateProfile({
    required String name,
    required String college,
    required String course,
    required String year,
    required String bio,
    required String skills,
  }) async {
    return remoteDataSource.updateProfile(
      name: name,
      college: college,
      course: course,
      year: year,
      bio: bio,
      skills: skills,
    );
  }

  Future<String> uploadProfileImage(
    File image,
  ) async {
    return remoteDataSource.uploadProfileImage(
      image,
    );
  }
}