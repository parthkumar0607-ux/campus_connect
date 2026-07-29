import 'package:campus_connect_v2/core/network/api_client.dart';

import '../models/discover_user_model.dart';

class DiscoverRemoteDataSource {
  Future<List<DiscoverUser>> getUsers() async {
    final response = await ApiClient.dio.get("/users");

    return (response.data as List)
        .map((e) => DiscoverUser.fromJson(e))
        .toList();
  }
}