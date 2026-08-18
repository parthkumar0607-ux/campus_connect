import '../datasource/home_remote_datasource.dart';
import '../models/home_stats_model.dart';

class HomeRepository {
  final HomeRemoteDataSource remote = HomeRemoteDataSource();

  Future<HomeStats> getStats() => remote.fetchStats();

  Future<List<dynamic>> getTeams() => remote.fetchTeams();

  Future<List<dynamic>> getEvents() => remote.fetchEvents();
}
