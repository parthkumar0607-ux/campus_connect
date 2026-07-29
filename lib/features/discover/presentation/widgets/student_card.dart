import 'package:flutter/material.dart';

import '../../models/discover_user_model.dart';

class StudentCard extends StatelessWidget {
  final DiscoverUser user;

  const StudentCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage:
                  user.profileImage != null &&
                          user.profileImage!.isNotEmpty
                      ? NetworkImage(user.profileImage!)
                      : null,
              child:
                  user.profileImage == null ||
                          user.profileImage!.isEmpty
                      ? const Icon(Icons.person)
                      : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${user.course ?? ""} • ${user.year ?? ""}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.skills?.isNotEmpty == true
                        ? user.skills!
                        : "No skills added",
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.bio?.isNotEmpty == true
                        ? user.bio!
                        : "No bio available",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}