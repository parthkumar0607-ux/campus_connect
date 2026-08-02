import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/models/message_model.dart';
import '../../data/repositories/chat_repository.dart';

class ChatDetailScreen extends StatefulWidget {
  final int teamId;
  final String teamName;

  const ChatDetailScreen({
    super.key,
    required this.teamId,
    required this.teamName,
  });

  @override
  State<ChatDetailScreen> createState() =>
      _ChatDetailScreenState();
}

class _ChatDetailScreenState
    extends State<ChatDetailScreen> {
  final ChatRepository repository =
      ChatRepository();

  final TextEditingController
      messageController =
      TextEditingController();

  List<MessageModel> messages = [];

  bool loading = true;
  bool sending = false;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final loaded =
          await repository.getMessages(
        widget.teamId,
      );

      if (!mounted) return;

      setState(() {
        messages = loaded;
        loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                "Failed to load messages",
          ),
        ),
      );
    }
  }

  Future<void> sendMessage() async {
    final text =
        messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    try {
      setState(() {
        sending = true;
      });

      await repository.sendMessage(
        teamId: widget.teamId,
        content: text,
      );

      messageController.clear();

      await loadMessages();
    } on DioException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                "Failed to send message",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          sending = false;
        });
      }
    }
  }

  Widget messageBubble(
    MessageModel message,
  ) {
    final mine =
        message.senderId == 1;

    return Align(
      alignment: mine
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin:
            const EdgeInsets.symmetric(
          vertical: 6,
        ),
        padding:
            const EdgeInsets.all(14),
        constraints:
            const BoxConstraints(
          maxWidth: 280,
        ),
        decoration: BoxDecoration(
          color: mine ? const Color(0xFF5865F2) : const Color(0xFF17213A),
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          border: mine
              ? null
              : Border.all(color: Colors.white.withValues(alpha: .10)),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          '# ${widget.teamName}',
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.people_alt_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: loading
                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh:
                        loadMessages,
                    child:
                        ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount:
                          messages.length,
                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        return messageBubble(
                          messages[index],
                        );
                      },
                    ),
                  ),
          ),
                    Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Message #channel',
                      prefixIcon: Icon(Icons.add_circle_outline),
                    ),
                    onSubmitted: (_) {
                      if (!sending) {
                        sendMessage();
                      }
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF5865F2), Color(0xFF8B5CF6)],
                    ),
                  ),
                  child: IconButton(
                    onPressed: sending
                        ? null
                        : sendMessage,
                    icon: sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.send,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
