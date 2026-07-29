import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';
import 'package:campus_connect_v2/shared/widgets/primary_button.dart';
import 'package:campus_connect_v2/shared/widgets/primary_textfield.dart';

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
  final ProfileRepository repository =
      ProfileRepository();

  final ImagePicker picker = ImagePicker();

  File? selectedImage;

  late final TextEditingController
      nameController;
  late final TextEditingController
      collegeController;
  late final TextEditingController
      courseController;
  late final TextEditingController
      yearController;
  late final TextEditingController
      bioController;
  late final TextEditingController
      skillsController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.user.name);

    collegeController = TextEditingController(
      text: widget.user.college ?? "",
    );

    courseController = TextEditingController(
      text: widget.user.course ?? "",
    );

    yearController = TextEditingController(
      text: widget.user.year ?? "",
    );

    bioController = TextEditingController(
      text: widget.user.bio ?? "",
    );

    skillsController = TextEditingController(
      text: widget.user.skills ?? "",
    );
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
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null) return;

    setState(() {
      selectedImage = File(file.path);
    });

    try {
      await repository.uploadProfileImage(
        selectedImage!,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> saveProfile() async {
    setState(() => isLoading = true);

    try {
      await repository.updateProfile(
        name: nameController.text.trim(),
        college:
            collegeController.text.trim(),
        course:
            courseController.text.trim(),
        year: yearController.text.trim(),
        bio: bioController.text.trim(),
        skills:
            skillsController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }