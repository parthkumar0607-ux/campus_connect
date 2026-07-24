import '../datasource/profile_remote_datasource.dart';
import '../models/user_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource =
      ProfileRemoteDataSource();

  Future<UserModel> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  Future<UserModel> updateProfile({
    required String name,
    required String college,
    required String course,
    required String year,
  }) async {
    return await remoteDataSource.updateProfile(
      name: name,
      college: college,
      course: course,
      year: year,
    );
  }
}