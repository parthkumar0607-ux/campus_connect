import 'dart:ui';

import 'package:flutter/material.dart';

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

  final List<Widget> _pages = const [
    HomeScreen(),
    DiscoverScreen(),
    TeamsScreen(),
    EventsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },

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
    );
  }
}