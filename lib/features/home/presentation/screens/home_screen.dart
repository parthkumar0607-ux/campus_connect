import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';
import '../widgets/quick_action_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xff6366F1),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening 👋",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Parth",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white70,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    _StatCard(
                      value: "850+",
                      label: "Students",
                    ),
                    _StatCard(
                      value: "34",
                      label: "Teams",
                    ),
                    _StatCard(
                      value: "12",
                      label: "Events",
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          TextField(
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: "Search students, teams, events...",
              hintStyle: const TextStyle(
                color: Colors.white54,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white70,
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Quick Actions",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.18,
            children: [
              QuickActionCard(
                icon: Icons.groups,
                title: "Teams",
                onTap: () {},
              ),
              QuickActionCard(
                icon: Icons.event,
                title: "Events",
                onTap: () {},
              ),
              QuickActionCard(
                icon: Icons.chat,
                title: "Chat",
                onTap: () {},
              ),
              QuickActionCard(
                icon: Icons.travel_explore,
                title: "Discover",
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            "Trending Teams",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 15),

          _buildTeamCard(
            "AI Innovators",
            "Looking for Flutter & ML developers",
            Icons.smart_toy,
          ),

          const SizedBox(height: 14),

          _buildTeamCard(
            "Hackathon Squad",
            "Registration closes tomorrow",
            Icons.emoji_events,
          ),

          const SizedBox(height: 30),

          const Text(
            "Upcoming Events",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 15),

          _buildEventCard(
            "Flutter Workshop",
            "Tomorrow • Seminar Hall",
            Icons.flutter_dash,
          ),

          const SizedBox(height: 14),

          _buildEventCard(
            "Hackathon 2026",
            "Registration closes in 5 days",
            Icons.code,
          ),

          const SizedBox(height: 30),

          const Text(
            "Announcements",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 15),

          _buildAnnouncementCard(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
    Widget _buildTeamCard(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xff6366F1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
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
    );
  }

  Widget _buildEventCard(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff6366F1),
                  Color(0xff8B5CF6),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard() {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Color(0xff6366F1),
            child: Icon(
              Icons.campaign,
              color: Colors.white,
            ),
          ),

          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to CampusConnect 🎉",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Discover students, build amazing teams and never miss important campus events.",
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  }

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: .12),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}