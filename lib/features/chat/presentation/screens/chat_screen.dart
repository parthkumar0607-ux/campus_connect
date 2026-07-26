import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Open a team and tap 'Open Team Chat' to start chatting.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}