import 'package:flutter/material.dart';
import '../screens/chat_detail_screen.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final bool isOnline;

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailScreen(name: name),
            ),
          );
        },
        leading: Stack(
          children: [
            const CircleAvatar(
              radius: 28,
              child: Icon(Icons.person),
            ),
            if (isOnline)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(message),
        trailing: Text(
          time,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}