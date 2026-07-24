import 'package:flutter/material.dart';

import 'package:campus_connect_v2/features/profile/data/models/user_model.dart';
import 'package:campus_connect_v2/features/profile/data/repositories/profile_repository.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final ProfileRepository repository = ProfileRepository();

  late final TextEditingController nameController;
  late final TextEditingController collegeController;
  late final TextEditingController courseController;
  late final TextEditingController yearController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.user.name,
    );

    collegeController = TextEditingController(
      text: widget.user.college ?? "",
    );

    courseController = TextEditingController(
      text: widget.user.course ?? "",
    );

    yearController = TextEditingController(
      text: widget.user.year ?? "",
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    collegeController.dispose();
    courseController.dispose();
    yearController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      await repository.updateProfile(
        name: nameController.text.trim(),
        college: collegeController.text.trim(),
        course: courseController.text.trim(),
        year: yearController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully"),
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
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: collegeController,
              decoration: const InputDecoration(
                labelText: "College",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: "Course",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: yearController,
              decoration: const InputDecoration(
                labelText: "Year",
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: isLoading ? null : saveProfile,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}