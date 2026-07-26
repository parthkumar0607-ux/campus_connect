import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:campus_connect_v2/features/profile/data/models/user_model.dart';
import 'package:campus_connect_v2/features/profile/data/repositories/profile_repository.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileRepository repository = ProfileRepository();

  final ImagePicker picker = ImagePicker();

  File? selectedImage;

  late final TextEditingController nameController;

  late final TextEditingController collegeController;

  late final TextEditingController courseController;

  late final TextEditingController yearController;

  late final TextEditingController bioController;

  late final TextEditingController skillsController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.user.name);

    collegeController = TextEditingController(text: widget.user.college ?? "");

    courseController = TextEditingController(text: widget.user.course ?? "");

    yearController = TextEditingController(text: widget.user.year ?? "");

    bioController = TextEditingController(text: widget.user.bio ?? "");

    skillsController = TextEditingController(text: widget.user.skills ?? "");
  }

  @override
  void dispose() {
    nameController.dispose();
    collegeController.dispose();
    courseController.dispose();
    yearController.dispose();
    bioController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null) return;

    setState(() {
      selectedImage = File(file.path);
    });

    try {
      await repository.uploadProfileImage(selectedImage!);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
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
        bio: bioController.text.trim(),
        skills: skillsController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully 🎉")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: selectedImage != null
                    ? FileImage(selectedImage!)
                    : (widget.user.profileImage != null &&
                                  widget.user.profileImage!.isNotEmpty
                              ? NetworkImage(widget.user.profileImage!)
                              : null)
                          as ImageProvider?,
                child:
                    selectedImage == null &&
                        (widget.user.profileImage == null ||
                            widget.user.profileImage!.isEmpty)
                    ? const Icon(Icons.person, size: 55)
                    : null,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Tap photo to change",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,
              decoration: decoration("Name", Icons.person),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: bioController,
              maxLines: 4,
              decoration: decoration("Bio", Icons.info),
            ),

            const SizedBox(height: 18),
            TextField(
              controller: collegeController,
              decoration: decoration("College", Icons.school),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: courseController,
              decoration: decoration("Course", Icons.menu_book),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: yearController,
              decoration: decoration("Year", Icons.calendar_today),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: skillsController,
              maxLines: 3,
              decoration: decoration("Skills", Icons.code),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton.icon(
                onPressed: isLoading ? null : saveProfile,
                icon: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(isLoading ? "Saving..." : "Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
