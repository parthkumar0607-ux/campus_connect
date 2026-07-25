import '../datasource/team_remote_datasource.dart';
import '../models/team_model.dart';

class TeamRepository {
  final TeamRemoteDataSource remoteDataSource =
      TeamRemoteDataSource();

  Future<List<TeamModel>> getTeams() async {
    return await remoteDataSource.getTeams();
  }

  Future<TeamModel> createTeam({
    required String title,
    required String description,
    required String techStack,
    required int maxMembers,
  }) async {
    return await remoteDataSource.createTeam(
      title: title,
      description: description,
      techStack: techStack,
      maxMembers: maxMembers,
    );
  }

  Future<void> joinTeam(int teamId) async {
    await remoteDataSource.joinTeam(teamId);
  }
}