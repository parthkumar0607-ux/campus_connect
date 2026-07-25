import 'package:flutter/material.dart';

import 'package:campus_connect_v2/features/teams/data/models/team_model.dart';
import 'package:campus_connect_v2/features/teams/data/repositories/team_repository.dart';
import 'package:campus_connect_v2/features/teams/presentation/screens/create_team_screen.dart';
import 'package:campus_connect_v2/features/teams/presentation/screens/team_details_screen.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final TeamRepository repository = TeamRepository();

  late Future<List<TeamModel>> teamsFuture;

  @override
  void initState() {
    super.initState();
    loadTeams();
  }

  void loadTeams() {
    teamsFuture = repository.getTeams();
  }

  Future<void> openCreateTeam() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateTeamScreen(),
      ),
    );

    if (created == true) {
      setState(() {
        loadTeams();
      });
    }
  }

  Future<void> openTeamDetails(TeamModel team) async {
    final joined = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeamDetailsScreen(
          team: team,
        ),
      ),
    );

    if (joined == true) {
      setState(() {
        loadTeams();
      });
    }
  }

  Future<void> refreshTeams() async {
    setState(() {
      loadTeams();
    });

    await teamsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hackathon Teams"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateTeam,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: refreshTeams,
        child: FutureBuilder<List<TeamModel>>(
          future: teamsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final teams = snapshot.data ?? [];

            if (teams.isEmpty) {
              return const Center(
                child: Text(
                  "No teams created yet.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => openTeamDetails(team),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            team.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(team.description),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              const Icon(Icons.code),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  team.techStack,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Icon(Icons.groups),
                              const SizedBox(width: 8),
                              Text(
                                "${team.currentMembers}/${team.maxMembers} Members",
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          const Align(
                            alignment:
                                Alignment.centerRight,
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                Text(
                                  "View Details",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons
                                      .arrow_forward_ios,
                                  size: 14,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}