import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';
import 'package:campus_connect_v2/features/home/data/repositories/home_repository.dart';
import 'package:campus_connect_v2/core/theme/app_colors.dart';

import '../widgets/quick_action_card.dart';

class _HomeStateHolder {
  final HomeRepository repo = HomeRepository();
}

class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigate;
  final VoidCallback? onOpenChats;

  const HomeScreen({super.key, this.onNavigate, this.onOpenChats});

  @override
  Widget build(BuildContext context) {
    final holder = _HomeStateHolder();

    return SafeArea(
      child: FutureBuilder(
        future: holder.repo.getStats(),
        builder: (context, AsyncSnapshot snapshot) {
          Widget statRow;

          if (snapshot.connectionState == ConnectionState.waiting) {
            statRow = const Row(
              children: [
                Expanded(child: _StatCard(value: '...', label: 'Students')),
                SizedBox(width: 12),
                Expanded(child: _StatCard(value: '...', label: 'Teams')),
                SizedBox(width: 12),
                Expanded(child: _StatCard(value: '...', label: 'Events')),
              ],
            );
          } else if (snapshot.hasError) {
            statRow = Row(
              children: [
                Expanded(child: _StatCard(value: 'Error', label: 'Students')),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(value: 'Error', label: 'Teams')),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(value: 'Error', label: 'Events')),
              ],
            );
          } else {
            final stats = snapshot.data;
            statRow = Row(
              children: [
                Expanded(child: _StatCard(value: stats.usersCount.toString(), label: 'Students')),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(value: stats.teamsCount.toString(), label: 'Teams')),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(value: stats.eventsCount.toString(), label: 'Events')),
              ],
            );
          }

          return ListView(
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
                              colors: [AppColors.blue, AppColors.primary],
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 26,
                            backgroundColor: AppColors.surface,
                            child: Icon(Icons.person, color: AppColors.textPrimary, size: 28),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('GOOD EVENING',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
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
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    statRow,
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
              // If backend supports posts/communities later, re-enable those sections.
              const SizedBox(height: 24),
              const _SectionTitle('Tonight’s highlight'),
              const SizedBox(height: 12),
              FutureBuilder(
                future: holder.repo.getStats(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const GlassCard(child: SizedBox(height: 72));
                  }
                  if (snap.hasError) {
                    return GlassCard(child: Padding(padding: const EdgeInsets.all(12), child: Text('No upcoming events', style: TextStyle(color: AppColors.textSecondary))));
                  }

                  final stats = snap.data as dynamic;
                  final upcoming = stats?.upcomingEvent ?? stats['upcoming_event'];
                  if (upcoming == null) {
                    return GlassCard(child: Padding(padding: const EdgeInsets.all(12), child: Text('No upcoming events', style: TextStyle(color: AppColors.textSecondary))));
                  }

                  return GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(upcoming['title'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(upcoming['description'] ?? '', style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
                        const SizedBox(height: 14),
                        Row(children: [
                          const Icon(Icons.schedule_rounded, color: AppColors.textSecondary, size: 17),
                          const SizedBox(width: 6),
                          Text(upcoming['date_time'] ?? '', style: const TextStyle(color: AppColors.textSecondary)),
                        ])
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Text(title,
      style: const TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700));
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
