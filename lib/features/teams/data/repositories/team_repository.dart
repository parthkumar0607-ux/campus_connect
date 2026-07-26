import '../datasource/team_remote_datasource.dart';
import '../models/team_member_model.dart';
import '../models/team_model.dart';
import '../models/team_status_model.dart';

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

  Future<TeamModel> updateTeam({
    required int teamId,
    required String title,
    required String description,
    required String techStack,
    required int maxMembers,
  }) async {
    return await remoteDataSource.updateTeam(
      teamId: teamId,
      title: title,
      description: description,
      techStack: techStack,
      maxMembers: maxMembers,
    );
  }

  Future<void> joinTeam(int teamId) async {
    await remoteDataSource.joinTeam(teamId);
  }

  Future<void> leaveTeam(int teamId) async {
    await remoteDataSource.leaveTeam(teamId);
  }

  Future<List<TeamMemberModel>> getTeamMembers(
    int teamId,
  ) async {
    return remoteDataSource.getTeamMembers(
      teamId,
    );
  }

  Future<TeamStatusModel> getTeamStatus(
    int teamId,
  ) async {
    return remoteDataSource.getTeamStatus(
      teamId,
    );
  }
}