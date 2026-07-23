import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  final String name;

  const ChatDetailScreen({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _message(
                  "Hey! Are you joining the hackathon?",
                  false,
                ),
                _message(
                  "Yes, definitely!",
                  true,
                ),
                _message(
                  "Awesome. We need one Flutter developer.",
                  false,
                ),
                _message(
                  "I'm interested 😄",
                  true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _message(String text, bool mine) {
    return Align(
      alignment:
          mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: mine ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: mine ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}