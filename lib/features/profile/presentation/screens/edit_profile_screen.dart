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
  late List<String> learningList;

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
    learningList = List<String>.from(widget.user.currentlyLearning ?? []);
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
        currentlyLearning: learningList.join(', '),
      );

      if (!mounted) return;

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

  Future<void> _addLearningItem() async {
    final controller = TextEditingController();

    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Add learning item', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'e.g. GraphQL', hintStyle: TextStyle(color: Colors.white54)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              Navigator.pop(ctx, text);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      final item = result.trim();
      if (!learningList.any((e) => e.toLowerCase() == item.toLowerCase())) {
        setState(() {
          learningList.add(item);
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item already exists')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Keep your profile updated so teammates know who they're working with.",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 30),

              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
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
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Color(0xff6366F1),
                              )
                            : null,
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xff6366F1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  "Tap to change photo",
                  style: TextStyle(color: Colors.white70),
                ),
              ),

              const SizedBox(height: 30),

              GlassCard(
                child: Column(
                  children: [
                    PrimaryTextField(
                      controller: nameController,
                      hintText: "Name",
                      prefixIcon: Icons.person,
                    ),

                    const SizedBox(height: 18),

                    PrimaryTextField(
                      controller: bioController,
                      hintText: "Bio",
                      prefixIcon: Icons.info_outline,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 18),

                    PrimaryTextField(
                      controller: collegeController,
                      hintText: "College",
                      prefixIcon: Icons.school,
                    ),

                    const SizedBox(height: 18),

                    PrimaryTextField(
                      controller: courseController,
                      hintText: "Course",
                      prefixIcon: Icons.menu_book,
                    ),

                    const SizedBox(height: 18),

                    PrimaryTextField(
                      controller: yearController,
                      hintText: "Year",
                      prefixIcon: Icons.calendar_today,
                    ),

                    const SizedBox(height: 18),

                    PrimaryTextField(
                      controller: skillsController,
                      hintText: "Skills (comma separated)",
                      prefixIcon: Icons.code,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 18),
                    // Currently Learning
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text('Currently Learning', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...learningList.map((s) => GestureDetector(
                                  onTap: () {
                                    // remove on tap
                                    setState(() {
                                      learningList.remove(s);
                                    });
                                  },
                                  child: Chip(
                                    backgroundColor: Theme.of(context).cardColor,
                                    label: Text(s, style: const TextStyle(color: Colors.white)),
                                    deleteIcon: const Icon(Icons.close, size: 18, color: Colors.white70),
                                    onDeleted: () {
                                      setState(() {
                                        learningList.remove(s);
                                      });
                                    },
                                  ),
                                )),
                            GestureDetector(
                              onTap: _addLearningItem,
                              child: Chip(
                                backgroundColor: Colors.white.withValues(alpha: 0.04),
                                label: Row(children: const [Icon(Icons.add, size: 18, color: Color(0xff8B5CF6)), SizedBox(width: 8), Text('Add', style: TextStyle(color: Colors.white))]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: isLoading ? "Saving..." : "Save Changes",
                isLoading: isLoading,
                onPressed: saveProfile,
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Cancel"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
