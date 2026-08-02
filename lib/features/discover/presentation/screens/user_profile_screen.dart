import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';

import '../../models/discover_user_model.dart';

class UserProfileScreen extends StatelessWidget {
  final DiscoverUser user;
  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Student profile')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassCard(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF5C8A), Color(0xFF5865F2)],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: const Color(0xFF17213A),
                        backgroundImage: user.profileImage?.isNotEmpty == true
                            ? NetworkImage(user.profileImage!)
                            : null,
                        child: user.profileImage?.isNotEmpty == true
                            ? null
                            : const Icon(Icons.person, color: Colors.white, size: 52),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(user.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    Text(user.course ?? 'Campus member',
                        style: const TextStyle(color: Color(0xFF8E9BB5))),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                      label: const Text('Connect'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const _Label('ABOUT'),
              GlassCard(
                child: Text(
                  user.bio?.isNotEmpty == true
                      ? user.bio!
                      : 'Here to meet people, make things, and leave campus better than I found it.',
                  style: const TextStyle(color: Color(0xFFB8C3D9), height: 1.5),
                ),
              ),
              const SizedBox(height: 20),
              const _Label('CAMPUS CARD'),
              GlassCard(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  _InfoRow(Icons.school_outlined, 'College', user.college ?? 'Not added'),
                  _InfoRow(Icons.menu_book_outlined, 'Course', user.course ?? 'Student'),
                  _InfoRow(Icons.calendar_month_outlined, 'Year', user.year ?? 'Not added'),
                ]),
              ),
              const SizedBox(height: 20),
              const _Label('SKILLS'),
              GlassCard(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (user.skills?.split(',') ?? ['Still exploring'])
                      .where((skill) => skill.trim().isNotEmpty)
                      .map((skill) => Chip(label: Text(skill.trim())))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                color: Color(0xFF8E9BB5), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: const Color(0xFF8B95FF)),
        title: Text(label, style: const TextStyle(color: Color(0xFF8E9BB5), fontSize: 13)),
        subtitle: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      );
}
