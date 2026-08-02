import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:campus_connect_v2/features/chat/presentation/screens/chat_screen.dart';
import 'package:campus_connect_v2/features/discover/presentation/screens/discover_screen.dart';
import 'package:campus_connect_v2/features/events/presentation/screens/events_screen.dart';
import 'package:campus_connect_v2/features/home/presentation/screens/home_screen.dart';
import 'package:campus_connect_v2/features/profile/presentation/screens/profile_screen.dart';
import 'package:campus_connect_v2/features/teams/presentation/screens/teams_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        onNavigate: _selectTab,
        onOpenChats: _openChats,
      ),
      const DiscoverScreen(),
      const TeamsScreen(),
      const EventsScreen(),
      const ProfileScreen(),
    ];
  }

  void _selectTab(int index) => setState(() => _selectedIndex = index);

  void _openChats() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B1020),
            Color(0xFF121A2F),
            Color(0xFF1A2542),
            Color(0xFF2A1F5B),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: _pages[_selectedIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20,
              sigmaY: 20,
            ),
            child: NavigationBar(
              height: 72,
              backgroundColor:
                  Colors.white.withValues(alpha: .08),

              indicatorColor:
                  const Color(0xff6366F1),

              elevation: 0,

              selectedIndex: _selectedIndex,

              labelBehavior:
                  NavigationDestinationLabelBehavior
                      .alwaysHide,

              onDestinationSelected: _selectTab,

              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.search),
                  selectedIcon: Icon(Icons.search),
                  label: "Discover",
                ),
                NavigationDestination(
                  icon: Icon(Icons.groups_outlined),
                  selectedIcon: Icon(Icons.groups),
                  label: "Teams",
                ),
                NavigationDestination(
                  icon: Icon(Icons.event_outlined),
                  selectedIcon: Icon(Icons.event),
                  label: "Events",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}
