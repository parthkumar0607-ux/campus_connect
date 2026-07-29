import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';

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

  Future<void> refreshTeams() async {
    setState(loadTeams);
    await teamsFuture;
  }

  Future<void> openCreateTeam() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateTeamScreen(),
      ),
    );

    if (created == true) {
      setState(loadTeams);
    }
  }

  Future<void> openTeamDetails(TeamModel team) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeamDetailsScreen(team: team),
      ),
    );

    if (updated == true) {
      setState(loadTeams);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff6366F1),
        foregroundColor: Colors.white,
        onPressed: openCreateTeam,
        icon: const Icon(Icons.add),
        label: const Text("Create Team"),
      ),

      body: SafeArea(
        child: RefreshIndicator(
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
                  child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }

              final teams = snapshot.data ?? [];

              if (teams.isEmpty) {
                return const Center(
                  child: Text(
                    "No Teams Yet",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  GlassCard(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Project Teams",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Collaborate with students on amazing projects.",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  ...teams.map(
                    (team) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: 16),
                      child: _TeamCard(
                        team: team,
                        onTap: () =>
                            openTeamDetails(team),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
class _TeamCard extends StatelessWidget {
  final TeamModel team;
  final VoidCallback onTap;

  const _TeamCard({
    required this.team,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff6366F1),
                        Color(0xff8B5CF6),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  child: const Icon(
                    Icons.groups,
                    color: Colors.white,
                    size: 32,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${team.currentMembers}/${team.maxMembers} Members",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 18,
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              team.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: team.techStack
                  .split(",")
                  .map(
                    (skill) => Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(.08),
                        borderRadius:
                            BorderRadius.circular(
                                30),
                        border: Border.all(
                          color: Colors.white
                              .withOpacity(.12),
                        ),
                      ),
                      child: Text(
                        skill.trim(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onTap,
                child: const Text("View Team"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}