import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/models/team_model.dart';
import '../../data/repositories/team_repository.dart';

class EditTeamScreen extends StatefulWidget {
  final TeamModel team;

  const EditTeamScreen({
    super.key,
    required this.team,
  });

  @override
  State<EditTeamScreen> createState() =>
      _EditTeamScreenState();
}

class _EditTeamScreenState
    extends State<EditTeamScreen> {
  final TeamRepository repository = TeamRepository();

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController techStackController;
  late final TextEditingController maxMembersController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.team.title,
    );

    descriptionController =
        TextEditingController(
      text: widget.team.description,
    );

    techStackController =
        TextEditingController(
      text: widget.team.techStack,
    );

    maxMembersController =
        TextEditingController(
      text: widget.team.maxMembers.toString(),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    techStackController.dispose();
    maxMembersController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        techStackController.text.trim().isEmpty ||
        maxMembersController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields.",
          ),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await repository.updateTeam(
        teamId: widget.team.id,
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
          content: Text(
            "Team updated successfully 🎉",
          ),
        ),
      );

      Navigator.pop(context, true);
    } on DioException catch (e) {
      String message = "Something went wrong";

      if (e.response?.data is Map &&
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
          isLoading = false;
        });
      }
    }
  }

  InputDecoration decoration(
    String label,
  ) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Team",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration:
                  decoration("Team Name"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  descriptionController,
              maxLines: 4,
              decoration:
                  decoration("Description"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  techStackController,
              decoration:
                  decoration("Tech Stack"),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  maxMembersController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  decoration("Max Members"),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : saveChanges,
                child:
                    isLoading
                        ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )
                        : const Text(
                            "Save Changes",
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}