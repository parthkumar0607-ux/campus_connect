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

  late Future<List<MessageModel>>
      messagesFuture;

  bool sending = false;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  void loadMessages() {
    messagesFuture =
        repository.getMessages(
      widget.teamId,
    );
  }

  Future<void> refreshMessages() async {
    setState(() {
      loadMessages();
    });
  }

  Future<void> sendMessage() async {
    if (messageController.text
        .trim()
        .isEmpty) {
      return;
    }

    setState(() {
      sending = true;
    });

    try {
      await repository.sendMessage(
        teamId: widget.teamId,
        content:
            messageController.text
                .trim(),
      );

      messageController.clear();

      await refreshMessages();
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
          color: mine
              ? Colors.blue
              : Colors.grey.shade300,
          borderRadius:
              BorderRadius.circular(
            16,
          ),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: mine
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.teamName,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<
                List<MessageModel>>(
              future: messagesFuture,
              builder: (
                context,
                snapshot,
              ) {
                if (snapshot
                        .connectionState ==
                    ConnectionState
                        .waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error
                          .toString(),
                    ),
                  );
                }

                final messages =
                    snapshot.data ??
                        [];

                if (messages
                    .isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages yet",
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh:
                      refreshMessages,
                  child:
                      ListView.builder(
                    padding:
                        const EdgeInsets
                            .all(16),
                    itemCount:
                        messages.length,
                    itemBuilder:
                        (
                      context,
                      index,
                    ) {
                      return messageBubble(
                        messages[
                            index],
                      );
                    },
                  ),
                );
              },
            ),
          ),
                    Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        messageController,
                    decoration:
                        InputDecoration(
                      hintText:
                          "Type a message...",
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                CircleAvatar(
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