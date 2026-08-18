import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';
import 'package:campus_connect_v2/shared/widgets/skill_chip.dart';
import 'package:campus_connect_v2/core/theme/app_colors.dart';

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
  final List<String> currentlyLearning = ['Flutter', 'SQL', 'Data Structures'];

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
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> openEditProfile(UserModel user) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
    );

    if (updated == true) {
      setState(loadProfile);
    }
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _statPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget buildSkillChips(String? skills) {
    if (skills == null || skills.trim().isEmpty) {
      return const Text('No skills added yet.', style: TextStyle(color: Colors.white70));
    }

      // Accept comma, semicolon, or newline-separated lists from different sources
      final items = skills.split(RegExp(r'[;,\n]+')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      return SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: items.map((s) => SkillChip(label: s)).toList(),
        ),
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString(), style: const TextStyle(color: Colors.white)),
              );
            }

            final user = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Stack(
                    children: [
                      GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.12), width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: 52,
                                  backgroundColor: AppColors.surfaceElevated,
                                  backgroundImage: user.profileImage != null && user.profileImage!.trim().isNotEmpty
                                      ? NetworkImage(user.profileImage!)
                                      : null,
                                  child: user.profileImage == null || user.profileImage!.trim().isEmpty
                                      ? const Icon(Icons.person, size: 48, color: AppColors.primary)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 6),
                                    Text(user.email, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                    const SizedBox(height: 12),
                                    Row(children: [
                                      _statPill('Teams', '4'),
                                      const SizedBox(width: 8),
                                      _statPill('Events', '7'),
                                    ])
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: FilledButton(
                          onPressed: () => openEditProfile(user),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: .06),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Icon(Icons.edit, size: 18),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  buildSectionTitle('About'),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        user.bio == null || user.bio!.trim().isEmpty
                            ? 'Passionate student eager to collaborate and learn.'
                            : user.bio!,
                        style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  buildSectionTitle('Academic'),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      child: Column(
                        children: [
                          _ProfileInfoRow(label: 'College', value: user.college?.isNotEmpty == true ? user.college! : '-'),
                          const Divider(color: Colors.white12, height: 18),
                          _ProfileInfoRow(label: 'Course', value: user.course?.isNotEmpty == true ? user.course! : '-'),
                          const Divider(color: Colors.white12, height: 18),
                          _ProfileInfoRow(label: 'Year', value: user.year?.isNotEmpty == true ? user.year! : '-'),
                          const Divider(color: Colors.white12, height: 18),
                          _ProfileInfoRow(label: 'Email', value: user.email),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  buildSectionTitle('Skills'),
                  GlassCard(
                    child: Padding(padding: const EdgeInsets.all(12), child: buildSkillChips(user.skills)),
                  ),

                  const SizedBox(height: 14),
                  buildSectionTitle('Currently Learning'),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: currentlyLearning.map((s) => SkillChip(label: s, secondary: true)).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(children: [
                    Expanded(child: FilledButton(onPressed: () => openEditProfile(user), child: const Text('Edit Profile'))),
                    const SizedBox(width: 12),
                    SizedBox(width: 120, height: 48, child: OutlinedButton(onPressed: logout, child: const Text('Logout'))),
                  ]),

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

class _ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(value, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

 
