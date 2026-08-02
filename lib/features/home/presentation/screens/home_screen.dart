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
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF5C8A), Color(0xFF8B5CF6)],
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 26,
                        backgroundColor: Color(0xFF17213A),
                        child: Icon(Icons.person, color: Colors.white, size: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('GOOD EVENING',
                              style: TextStyle(
                                  color: Color(0xFF8E9BB5),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1)),
                          SizedBox(height: 4),
                          Text('Your campus is buzzing ✦',
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
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _TopicChip(label: 'For you', selected: true),
                _TopicChip(label: '#design'),
                _TopicChip(label: '#hackathon'),
                _TopicChip(label: '#placements'),
              ],
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
          const _SectionTitle('Hot on campus'),
          const SizedBox(height: 12),
          const _CampusPost(
            community: 'r/AI Builders',
            time: '18 min ago',
            title: 'Anyone joining the overnight hackathon team?',
            body: 'Looking for one Flutter dev and a product brain. We already have the coffee covered.',
            votes: '142',
            comments: '26',
          ),
          const SizedBox(height: 12),
          const _CampusPost(
            community: 'r/Design Dojo',
            time: '42 min ago',
            title: 'Drop your portfolio for a friendly roast',
            body: 'No gatekeeping — sharing feedback and wins before placement season.',
            votes: '89',
            comments: '18',
            accent: Color(0xFFFF5C8A),
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

class _TopicChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _TopicChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF5865F2)
              : Colors.white.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: selected ? .08 : .12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      );
}

class _CampusPost extends StatelessWidget {
  final String community;
  final String time;
  final String title;
  final String body;
  final String votes;
  final String comments;
  final Color accent;

  const _CampusPost({
    required this.community,
    required this.time,
    required this.title,
    required this.body,
    required this.votes,
    required this.comments,
    this.accent = const Color(0xFF22D3EE),
  });

  @override
  Widget build(BuildContext context) => GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(Icons.keyboard_arrow_up_rounded, color: accent),
                Text(
                  votes,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF8E9BB5),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$community  ·  $time',
                    style: TextStyle(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: const TextStyle(
                      color: Color(0xFFB8C3D9),
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.mode_comment_outlined,
                        color: Color(0xFF8E9BB5),
                        size: 17,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$comments comments',
                        style: const TextStyle(
                          color: Color(0xFF8E9BB5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Icon(
                        Icons.ios_share_outlined,
                        color: Color(0xFF8E9BB5),
                        size: 17,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
