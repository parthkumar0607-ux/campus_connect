import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/models/team_model.dart';
import '../../data/repositories/team_repository.dart';

class TeamDetailsScreen extends StatefulWidget {
  final TeamModel team;

  const TeamDetailsScreen({
    super.key,
    required this.team,
  });

  @override
  State<TeamDetailsScreen> createState() =>
      _TeamDetailsScreenState();
}

class _TeamDetailsScreenState
    extends State<TeamDetailsScreen> {
  final TeamRepository repository = TeamRepository();

  bool isJoining = false;

  Future<void> joinTeam() async {
    try {
      setState(() {
        isJoining = true;
      });

      await repository.joinTeam(widget.team.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Joined team successfully 🎉"),
        ),
      );

      Navigator.pop(context, true);
    } on DioException catch (e) {
      if (!mounted) return;

      String message = "Something went wrong";

      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data["detail"] != null) {
        message = e.response!.data["detail"];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isJoining = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final team = widget.team;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              team.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              team.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Tech Stack",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Chip(
              label: Text(team.techStack),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                const Icon(Icons.groups),
                const SizedBox(width: 10),
                Text(
                  "${team.currentMembers}/${team.maxMembers} Members",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed:
                    isJoining ? null : joinTeam,
                child: isJoining
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Join Team",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}