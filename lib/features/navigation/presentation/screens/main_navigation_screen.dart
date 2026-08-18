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
            Color(0xFF070A10),
            Color(0xFF101319),
            Color(0xFF171126),
            Color(0xFF0D0D12),
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
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: NavigationBar(
                height: 72,
                backgroundColor: const Color(0xFF171C27).withValues(alpha: .90),
                indicatorColor: const Color(0xFF8B5CF6).withValues(alpha: 0.28),
                elevation: 0,
                selectedIndex: _selectedIndex,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                onDestinationSelected: _selectTab,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: "Home",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.explore_outlined),
                    selectedIcon: Icon(Icons.explore_rounded),
                    label: "Discover",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.groups_outlined),
                    selectedIcon: Icon(Icons.groups_rounded),
                    label: "Teams",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.event_outlined),
                    selectedIcon: Icon(Icons.event_rounded),
                    label: "Events",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person_rounded),
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
