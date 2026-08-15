import 'package:campus_connect_v2/features/profile/data/models/user_model.dart';
import 'package:campus_connect_v2/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter/material.dart';

import '../../data/models/message_model.dart';
import '../../data/repositories/personal_chat_repository.dart';

class PersonalChatScreen extends StatefulWidget {
  final String otherUserName;
  final int otherUserId;

  const PersonalChatScreen({
    super.key,
    required this.otherUserName,
    this.otherUserId = 2,
  });

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PersonalChatRepository _repository = PersonalChatRepository();
  final ProfileRepository _profileRepository = ProfileRepository();
  UserModel? _currentUser;
  bool _loadingProfile = true;
  List<MessageModel> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadProfileAndMessages();
  }

  Future<void> _loadProfileAndMessages() async {
    try {
      final user = await _profileRepository.getProfile();
      final savedMessages = await _repository.loadMessages(widget.otherUserId);

      if (!mounted) return;

      setState(() {
        _currentUser = user;
        _messages = savedMessages.isNotEmpty
            ? savedMessages
            : [
                MessageModel(
                  id: DateTime.now().millisecondsSinceEpoch,
                  teamId: 0,
                  senderId: widget.otherUserId,
                  senderName: widget.otherUserName,
                  content: 'Hey! Let’s connect on this project.',
                  createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
                ),
              ];
      });

      await _repository.saveMessages(widget.otherUserId, _messages);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _currentUser = null;
        _messages = [
          MessageModel(
            id: DateTime.now().millisecondsSinceEpoch,
            teamId: 0,
            senderId: widget.otherUserId,
            senderName: widget.otherUserName,
            content: 'Hey! Let’s connect on this project.',
            createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
          ),
        ];
      });
    } finally {
      if (mounted) {
        setState(() => _loadingProfile = false);
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final currentUserId = _currentUser?.id ?? 1;
    final currentUserName = _currentUser?.name ?? 'You';

    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch,
      teamId: 0,
      senderId: currentUserId,
      senderName: currentUserName,
      content: text,
      createdAt: DateTime.now(),
    );

    final updatedMessages = [..._messages, newMessage];
    setState(() {
      _messages = updatedMessages;
    });

    messageController.clear();
    await _repository.saveMessages(widget.otherUserId, updatedMessages);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Widget _messageBubble(MessageModel message) {
    final bool fromMe = message.senderId == (_currentUser?.id ?? 1);
    final String displayName = fromMe ? (_currentUser?.name ?? 'You') : widget.otherUserName;
    final avatarColor = fromMe ? const Color(0xFF7C3AED) : const Color(0xFF22C55E);
    final time =
        '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          textDirection: fromMe ? TextDirection.rtl : TextDirection.ltr,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: avatarColor,
              child: Text(
                displayName.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.68,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: fromMe ? const Color(0xFF5865F2) : const Color(0xFF1F2430),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: Radius.circular(fromMe ? 14 : 4),
                        bottomRight: Radius.circular(fromMe ? 4 : 14),
                      ),
                    ),
                    child: Text(
                      message.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Color(0xFF8D93A6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0D12),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF11151D),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0D12),
        appBar: AppBar(
          backgroundColor: const Color(0xFF11151D),
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
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF22C55E),
                child: Text(
                  widget.otherUserName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.otherUserName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(Icons.call_outlined, color: Color(0xFFD9DEE9)),
            ),
          ],
        ),
        body: _loadingProfile
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF101319), Color(0xFF0B0D12), Color(0xFF090B10)],
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(top: 12, bottom: 18),
                        itemCount: _messages.length,
                        itemBuilder: (_, index) => _messageBubble(_messages[index]),
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
                        decoration: const BoxDecoration(
                          color: Color(0xFF2B3039),
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
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                              decoration: const InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                hintText: 'Message...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF8D93A6),
                                  fontSize: 15,
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
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
                          onPressed: _sendMessage,
                          icon: const Icon(Icons.arrow_upward_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
