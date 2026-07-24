import '../datasource/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource =
      AuthRemoteDataSource();

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(
      email: email,
      password: password,
    );

    return await remoteDataSource.login(request);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? college,
    String? course,
    String? year,
  }) async {
    final request = RegisterRequestModel(
      name: name,
      email: email,
      password: password,
      college: college,
      course: course,
      year: year,
    );

    await remoteDataSource.register(request);
  }
}