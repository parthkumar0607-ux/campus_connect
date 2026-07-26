import 'package:campus_connect_v2/core/network/api_client.dart';

import '../models/team_member_model.dart';
import '../models/team_model.dart';

class TeamRemoteDataSource {
  Future<List<TeamModel>> getTeams() async {
    final response = await ApiClient.dio.get("/teams");

    return (response.data as List)
        .map((team) => TeamModel.fromJson(team))
        .toList();
  }

  Future<TeamModel> createTeam({
    required String title,
    required String description,
    required String techStack,
    required int maxMembers,
  }) async {
    final response = await ApiClient.dio.post(
      "/teams",
      data: {
        "title": title,
        "description": description,
        "tech_stack": techStack,
        "max_members": maxMembers,
      },
    );

    return TeamModel.fromJson(response.data);
  }

  Future<void> joinTeam(int teamId) async {
    await ApiClient.dio.post(
      "/teams/$teamId/join",
    );
  }

  Future<void> leaveTeam(int teamId) async {
    await ApiClient.dio.delete(
      "/teams/$teamId/leave",
    );
  }

  Future<List<TeamMemberModel>> getTeamMembers(
    int teamId,
  ) async {
    final response = await ApiClient.dio.get(
      "/teams/$teamId/members",
    );

    return (response.data as List)
        .map((member) => TeamMemberModel.fromJson(member))
        .toList();
  }
}