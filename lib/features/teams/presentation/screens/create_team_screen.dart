import 'package:flutter/material.dart';

import 'package:campus_connect_v2/features/teams/data/repositories/team_repository.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() =>
      _CreateTeamScreenState();
}

class _CreateTeamScreenState
    extends State<CreateTeamScreen> {
  final TeamRepository repository = TeamRepository();

  final titleController = TextEditingController();
  final descriptionController =
      TextEditingController();
  final techStackController =
      TextEditingController();
  final maxMembersController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    techStackController.dispose();
    maxMembersController.dispose();
    super.dispose();
  }

  Future<void> createTeam() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        techStackController.text.trim().isEmpty ||
        maxMembersController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await repository.createTeam(
        title: titleController.text.trim(),
        description:
            descriptionController.text.trim(),
        techStack:
            techStackController.text.trim(),
        maxMembers: int.parse(
          maxMembersController.text.trim(),
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Team created successfully"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Team"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Team Title",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            TextField(
              controller: techStackController,
              decoration: const InputDecoration(
                labelText: "Tech Stack",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: maxMembersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Maximum Members",
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed:
                    isLoading ? null : createTeam,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Create Team"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}