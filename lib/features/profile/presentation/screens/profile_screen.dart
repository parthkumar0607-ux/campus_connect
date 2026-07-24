import 'package:flutter/material.dart';

import 'package:campus_connect_v2/core/services/storage_service.dart';
import 'package:campus_connect_v2/features/auth/presentation/screens/login_screen.dart';

import '../widgets/profile_stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await StorageService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 55,
            child: Icon(
              Icons.person,
              size: 60,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Parth Kumar",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "BCA • RKGIT",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 30),

          const Row(
            children: [
              ProfileStatCard(
                title: "Projects",
                value: "2",
              ),
              SizedBox(width: 12),
              ProfileStatCard(
                title: "Skills",
                value: "6",
              ),
              SizedBox(width: 12),
              ProfileStatCard(
                title: "Teams",
                value: "1",
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            "Skills",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              Chip(label: Text("Flutter")),
              Chip(label: Text("Python")),
              Chip(label: Text("C")),
              Chip(label: Text("HTML")),
              Chip(label: Text("CSS")),
              Chip(label: Text("JavaScript")),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            "Projects",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Card(
            child: ListTile(
              leading: Icon(Icons.mobile_friendly),
              title: Text("CampusConnect"),
              subtitle: Text("College Community App"),
            ),
          ),

          const Card(
            child: ListTile(
              leading: Icon(Icons.school),
              title: Text("Student Management System"),
              subtitle: Text("Built using C"),
            ),
          ),

          const SizedBox(height: 30),

          FilledButton(
            onPressed: () {},
            child: const Text("Edit Profile"),
          ),

          const SizedBox(height: 16),

          FilledButton.tonalIcon(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}