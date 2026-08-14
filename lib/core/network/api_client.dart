import 'package:dio/dio.dart';

import '../services/storage_service.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://campus-connect-k76s.onrender.com",
      // Render free instances can take more than ten seconds to wake up.
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
      sendTimeout: const Duration(seconds: 45),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (e, handler) {
          handler.next(e);
        },
      ),
    );
}
