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

  Widget messageBubble(MessageModel message) {
    final avatarColor = _avatarColors[message.senderId % _avatarColors.length];
    final createdAt = message.createdAt.toLocal();
    final time =
        '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

    final senderName = message.senderName.isNotEmpty
        ? message.senderName
        : 'User ${message.senderId}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: avatarColor,
            child: Text(
              senderName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      senderName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFF7B7F8D),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message.content,
                  style: const TextStyle(
                    color: Color(0xFFEAEAF2),
                    fontSize: 15,
                    height: 1.42,
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
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF11151D),
        elevation: 0,
        leadingWidth: 42,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Text(
              '# ${widget.teamName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: Icon(Icons.people_alt_rounded, color: Color(0xFFD9DEE9)),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF101319), Color(0xFF0B0D12), Color(0xFF090B10)],
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(56, 2, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Team channel · Keep it kind',
                  style: TextStyle(
                    color: Color(0xFF8D93A6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFF8B7AFB)),
                    )
                  : RefreshIndicator(
                      onRefresh: loadMessages,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 18),
                        itemCount: messages.length,
                        itemBuilder: (context, index) =>
                            messageBubble(messages[index]),
                      ),
                    ),
            ),
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF11151D),
                  border: Border(
                    top: BorderSide(color: Color(0xFF1C212D), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B3039),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 22,
                        color: Color(0xFFD9DEE9),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2430),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFF2D3542), width: 1),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: messageController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              hintText: 'Message #channel',
                              hintStyle: TextStyle(
                                color: Color(0xFF8D93A6),
                                fontSize: 15,
                              ),
                            ),
                            onSubmitted: (_) {
                              if (!sending) sendMessage();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF5865F2)],
                        ),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                        color: Colors.white,
                        onPressed: sending ? null : sendMessage,
                        icon: sending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.arrow_upward_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}

const _avatarColors = [
  Color(0xFF7C3AED),
  Color(0xFFE85AD7),
  Color(0xFF0EA5E9),
  Color(0xFF22C55E),
  Color(0xFFF59E0B),
];
