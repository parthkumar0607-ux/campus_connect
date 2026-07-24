import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';

class AuthRemoteDataSource {
  Future<LoginResponseModel> login(
    LoginRequestModel request,
  ) async {
    final Response response = await ApiClient.dio.post(
      "/auth/login",
      data: request.toJson(),
    );

    return LoginResponseModel.fromJson(response.data);
  }

  Future<void> register(
    RegisterRequestModel request,
  ) async {
    await ApiClient.dio.post(
      "/auth/register",
      data: request.toJson(),
    );
  }
}