import 'package:flutter/material.dart';

import '../../models/discover_user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final DiscoverUser user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

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
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
                  user.profileImage != null &&
                          user.profileImage!.isNotEmpty
                      ? NetworkImage(user.profileImage!)
                      : null,
              child:
                  user.profileImage == null ||
                          user.profileImage!.isEmpty
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
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  user.bio?.isNotEmpty == true
                      ? user.bio!
                      : "No bio added yet.",
                ),
              ),
            ),

            const SizedBox(height: 15),

            infoTile(
              icon: Icons.school,
              title: "College",
              value: user.college ?? "-",
            ),

            infoTile(
              icon: Icons.menu_book,
              title: "Course",
              value: user.course ?? "-",
            ),

            infoTile(
              icon: Icons.calendar_today,
              title: "Year",
              value: user.year ?? "-",
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  user.skills?.isNotEmpty == true
                      ? user.skills!
                      : "No skills added.",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}