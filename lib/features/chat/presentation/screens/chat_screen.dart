import 'package:flutter/material.dart';
import '../widgets/chat_tile.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [

          ChatTile(
            name: "Aman Gupta",
            message: "Bro, are you joining the hackathon?",
            time: "9:30 AM",
            isOnline: true,
          ),

          ChatTile(
            name: "Priya Sharma",
            message: "I've finished the UI design.",
            time: "Yesterday",
            isOnline: false,
          ),

          ChatTile(
            name: "Flutter Team",
            message: "Meeting at 6 PM today.",
            time: "Yesterday",
            isOnline: true,
          ),

          ChatTile(
            name: "Rahul",
            message: "Can you review my code?",
            time: "Monday",
            isOnline: false,
          ),

          ChatTile(
            name: "Campus Club",
            message: "Registrations are now open!",
            time: "Sunday",
            isOnline: true,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
    );
  }
}