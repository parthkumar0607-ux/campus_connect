import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';

import '../widgets/quick_action_card.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigate;
  final VoidCallback? onOpenChats;

  const HomeScreen({super.key, this.onNavigate, this.onOpenChats});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFF5865F2),
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good evening',
                              style: TextStyle(
                                  color: Color(0xFF8E9BB5), fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Your campus is buzzing',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      tooltip: 'Notifications',
                      icon: const Icon(Icons.notifications_none_rounded,
                          color: Color(0xFF8E9BB5)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: _StatCard(value: '850+', label: 'Students')),
                    SizedBox(width: 12),
                    Expanded(child: _StatCard(value: '34', label: 'Teams')),
                    SizedBox(width: 12),
                    Expanded(child: _StatCard(value: '12', label: 'Events')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Stories'),
          const SizedBox(height: 12),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _storyNames.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) => _StoryAvatar(name: _storyNames[index]),
            ),
          ),
          const SizedBox(height: 22),
          const _SectionTitle('Quick access'),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.05,
            children: [
              QuickActionCard(
                  icon: Icons.groups, title: 'Teams', onTap: () => onNavigate?.call(2)),
              QuickActionCard(
                  icon: Icons.event, title: 'Events', onTap: () => onNavigate?.call(3)),
              QuickActionCard(
                  icon: Icons.chat,
                  title: 'Chat',
                  onTap: () => onOpenChats?.call()),
              QuickActionCard(
                  icon: Icons.travel_explore,
                  title: 'Discover',
                  onTap: () => onNavigate?.call(1)),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Trending communities'),
          const SizedBox(height: 12),
          const _CommunityCard(
            title: 'AI Builders',
            subtitle: 'Build the future together',
            members: '2.1k members',
          ),
          const SizedBox(height: 12),
          const _CommunityCard(
            title: 'Design Dojo',
            subtitle: 'UI/UX critiques tonight',
            members: '980 members',
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Tonight’s highlight'),
          const SizedBox(height: 12),
          GlassCard(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Campus mixer',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('Meet students from design, AI, and product in one place.',
                    style: TextStyle(color: Color(0xFF8E9BB5), height: 1.5)),
                SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded,
                        color: Color(0xFF8E9BB5), size: 17),
                    SizedBox(width: 6),
                    Text('7:30 PM • Rooftop Lab',
                        style: TextStyle(color: Color(0xFF8E9BB5))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _storyNames = ['Mia', 'Ava', 'Jules', 'Noah', 'Riya'];

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Text(title,
      style: const TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700));
}

class _StoryAvatar extends StatelessWidget {
  final String name;
  const _StoryAvatar({required this.name});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                  colors: [Color(0xFF5865F2), Color(0xFF8B5CF6)]),
              border: Border.all(color: Colors.white.withValues(alpha: .16), width: 1.5),
            ),
            child: Text(name.substring(0, 1),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(color: Color(0xFF8E9BB5), fontSize: 12)),
        ],
      );
}

class _CommunityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String members;
  const _CommunityCard(
      {required this.title, required this.subtitle, required this.members});

  @override
  Widget build(BuildContext context) => GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF5865F2).withValues(alpha: .18),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.group, color: Color(0xFF8B95FF)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(color: Color(0xFF8E9BB5), fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(members,
                style: const TextStyle(color: Color(0xFF8E9BB5), fontSize: 12)),
          ],
        ),
      );
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(color: Color(0xFF8E9BB5), fontSize: 12)),
          ],
        ),
      );
}
