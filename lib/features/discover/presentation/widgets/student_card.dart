import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';

import '../../models/discover_user_model.dart';
import '../screens/user_profile_screen.dart';

class StudentCard extends StatelessWidget {
  final DiscoverUser user;

  const StudentCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserProfileScreen(user: user),
          ),
        );
      },
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: "user_${user.id}",
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: const Color(0xff6366F1),
                    backgroundImage: user.profileImage != null &&
                            user.profileImage!.isNotEmpty
                        ? NetworkImage(user.profileImage!)
                        : null,
                    child: user.profileImage == null ||
                            user.profileImage!.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 34,
                          )
                        : null,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "${user.course ?? "Student"} • ${user.year ?? ""}",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        user.college ?? "",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 18,
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              user.bio?.isNotEmpty == true
                  ? user.bio!
                  : "Passionate student looking to collaborate on exciting projects.",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            if (user.skills != null &&
                user.skills!.trim().isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: user.skills!
                    .split(",")
                    .map(
                      (skill) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
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
                          skill.trim(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  borderRadius:
                      BorderRadius.circular(30),
                ),
                child: const Text(
                  "No Skills Added",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          UserProfileScreen(user: user),
                    ),
                  );
                },
                icon: const Icon(Icons.person),
                label: const Text("View Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}