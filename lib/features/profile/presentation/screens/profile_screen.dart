import 'package:flutter/material.dart';

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
      setState(() {
        loadProfile();
      });
    }
  }

  Widget infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: FutureBuilder<UserModel>(
        future: profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      user.profileImage != null &&
                          user.profileImage!.trim().isNotEmpty
                      ? NetworkImage(user.profileImage!)
                      : null,
                  child:
                      user.profileImage == null ||
                          user.profileImage!.trim().isEmpty
                      ? const Icon(Icons.person, size: 55)
                      : null,
                ),

                const SizedBox(height: 20),

                Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  user.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                ),

                const SizedBox(height: 30),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bio",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.bio == null || user.bio!.trim().isEmpty
                              ? "No bio added yet."
                              : user.bio!,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                infoTile(
                  icon: Icons.school,
                  title: "College",
                  value: user.college?.isNotEmpty == true ? user.college! : "-",
                ),

                infoTile(
                  icon: Icons.menu_book,
                  title: "Course",
                  value: user.course?.isNotEmpty == true ? user.course! : "-",
                ),

                infoTile(
                  icon: Icons.calendar_today,
                  title: "Year",
                  value: user.year?.isNotEmpty == true ? user.year! : "-",
                ),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Skills",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.skills == null || user.skills!.trim().isEmpty
                              ? "No skills added yet."
                              : user.skills!,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                FilledButton.icon(
                  onPressed: () => openEditProfile(user),
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                ),

                const SizedBox(height: 16),

                FilledButton.tonalIcon(
                  onPressed: logout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
