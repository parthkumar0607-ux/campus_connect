import 'package:flutter/material.dart';
import '../widgets/quick_action_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "👋 Good Evening, Parth",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Welcome back to CampusConnect",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 25),

          TextField(
            decoration: InputDecoration(
              hintText: "Search events, teams...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              QuickActionCard(
                icon: Icons.event,
                title: "Events",
                onTap: () {},
              ),
              QuickActionCard(
                icon: Icons.groups,
                title: "Teams",
                onTap: () {},
              ),
              QuickActionCard(
                icon: Icons.chat,
                title: "Chat",
                onTap: () {},
              ),
              QuickActionCard(
                icon: Icons.store,
                title: "Marketplace",
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            "Announcements",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: Icon(Icons.campaign),
              title: Text("Welcome to CampusConnect 🎉"),
              subtitle: Text(
                "Stay tuned for college updates and hackathons.",
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Upcoming Events",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: Icon(Icons.emoji_events),
              title: Text("Hackathon 2026"),
              subtitle: Text("Registration closes in 5 days"),
            ),
          ),
        ],
      ),
    );
  }
}