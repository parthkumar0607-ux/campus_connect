import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';

import 'package:campus_connect_v2/core/services/storage_service.dart';
import 'package:campus_connect_v2/features/auth/presentation/screens/login_screen.dart';
import 'package:campus_connect_v2/features/profile/data/models/user_model.dart';
import 'package:campus_connect_v2/features/profile/data/repositories/profile_repository.dart';
import 'package:campus_connect_v2/features/profile/presentation/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileRepository repository = ProfileRepository();

  late Future<UserModel> profileFuture;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() {
    profileFuture = repository.getProfile();
  }

  Future<void> logout() async {
    await StorageService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> openEditProfile(UserModel user) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(user: user),
      ),
    );

    if (updated == true) {
      setState(loadProfile);
    }
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSkillChips(String? skills) {
    if (skills == null || skills.trim().isEmpty) {
      return const Text(
        "No skills added yet.",
        style: TextStyle(color: Colors.white70),
      );
    }

    final items = skills
        .split(",")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.08),
            borderRadius:
                BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(.12),
            ),
          ),
          child: Text(
            skill,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: FutureBuilder<UserModel>(
          future: profileFuture,
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

            final user = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  GlassCard(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor:
                              Colors.white,
                          backgroundImage:
                              user.profileImage !=
                                          null &&
                                      user
                                          .profileImage!
                                          .trim()
                                          .isNotEmpty
                                  ? NetworkImage(
                                      user.profileImage!,
                                    )
                                  : null,
                          child: user.profileImage ==
                                      null ||
                                  user.profileImage!
                                      .trim()
                                      .isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 55,
                                  color:
                                      Color(0xff6366F1),
                                )
                              : null,
                        ),

                        const SizedBox(height: 18),

                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: const [
                            _StatCard(
                              value: "4",
                              label: "Teams",
                            ),
                            SizedBox(width: 12),
                            _StatCard(
                              value: "7",
                              label: "Events",
                            ),
                            SizedBox(width: 12),
                            _StatCard(
                              value: "3",
                              label: "Projects",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  buildSectionTitle("About Me"),

                  GlassCard(
                    child: Text(
                      user.bio == null ||
                              user.bio!
                                  .trim()
                                  .isEmpty
                          ? "Passionate student eager to collaborate, learn and build impactful projects."
                          : user.bio!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  buildSectionTitle(
                    "Academic Information",
                  ),
                                    buildInfoCard(
                    icon: Icons.school,
                    title: "College",
                    value: user.college?.isNotEmpty == true
                        ? user.college!
                        : "-",
                  ),

                  buildInfoCard(
                    icon: Icons.menu_book,
                    title: "Course",
                    value: user.course?.isNotEmpty == true
                        ? user.course!
                        : "-",
                  ),

                  buildInfoCard(
                    icon: Icons.calendar_month,
                    title: "Year",
                    value: user.year?.isNotEmpty == true
                        ? user.year!
                        : "-",
                  ),

                  const SizedBox(height: 30),

                  buildSectionTitle("Skills"),

                  GlassCard(
                    child: buildSkillChips(user.skills),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: FilledButton.icon(
                      onPressed: () =>
                          openEditProfile(user),
                      icon: const Icon(Icons.edit),
                      label: const Text(
                        "Edit Profile",
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: logout,
                      icon: const Icon(Icons.logout),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.white
                              .withOpacity(.25),
                        ),
                        foregroundColor:
                            Colors.white,
                      ),
                      label: const Text(
                        "Logout",
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xff818CF8),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}