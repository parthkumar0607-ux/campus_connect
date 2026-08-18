import 'package:campus_connect_v2/core/network/api_client.dart';

import '../models/home_stats_model.dart';

class HomeRemoteDataSource {
  Future<HomeStats> fetchStats() async {
    final resp = await ApiClient.dio.get('/stats');
    return HomeStats.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<dynamic>> fetchTeams() async {
    final resp = await ApiClient.dio.get('/teams');
    return resp.data as List<dynamic>;
  }

  Future<List<dynamic>> fetchEvents() async {
    final resp = await ApiClient.dio.get('/events');
    return resp.data as List<dynamic>;
  }
}
