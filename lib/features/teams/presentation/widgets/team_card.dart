import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  final String teamName;
  final String roleNeeded;
  final String members;
  final String techStack;

  const TeamCard({
    super.key,
    required this.teamName,
    required this.roleNeeded,
    required this.members,
    required this.techStack,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              teamName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.person_search, size: 18),
                const SizedBox(width: 8),
                Text("Need: $roleNeeded"),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.people, size: 18),
                const SizedBox(width: 8),
                Text("Members: $members"),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.code, size: 18),
                const SizedBox(width: 8),
                Text(techStack),
              ],
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text("Join Team"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}