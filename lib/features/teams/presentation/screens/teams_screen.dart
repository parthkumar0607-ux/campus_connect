import 'package:flutter/material.dart';
import '../widgets/team_card.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hackathon Teams"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search Teams",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          const SizedBox(height: 25),

          const TeamCard(
            teamName: "Team Alpha",
            roleNeeded: "Flutter Developer",
            members: "2/4",
            techStack: "Flutter • Firebase",
          ),

          const TeamCard(
            teamName: "VisionX",
            roleNeeded: "AI/ML Engineer",
            members: "3/5",
            techStack: "Python • TensorFlow",
          ),

          const TeamCard(
            teamName: "CodeStorm",
            roleNeeded: "UI/UX Designer",
            members: "1/4",
            techStack: "Figma • Flutter",
          ),

          const TeamCard(
            teamName: "CyberGuard",
            roleNeeded: "Backend Developer",
            members: "2/4",
            techStack: "FastAPI • PostgreSQL",
          ),
        ],
      ),
    );
  }
}