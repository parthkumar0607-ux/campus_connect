import 'package:dio/dio.dart';

import '../services/storage_service.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://campus-connect-k76s.onrender.com",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService.getToken();

          print("================================");
          print("REQUEST URL: ${options.baseUrl}${options.path}");
          print("REQUEST DATA: ${options.data}");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          print("STATUS: ${response.statusCode}");
          print("BODY: ${response.data}");
          handler.next(response);
        },
        onError: (e, handler) {
          print("ERROR STATUS: ${e.response?.statusCode}");
          print("ERROR BODY: ${e.response?.data}");
          print("ERROR: ${e.message}");
          handler.next(e);
        },
      ),
    );
}