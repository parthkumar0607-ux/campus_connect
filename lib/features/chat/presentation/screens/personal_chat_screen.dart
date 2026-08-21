import 'package:campus_connect_v2/core/network/api_client.dart';
import 'package:campus_connect_v2/features/profile/data/models/user_model.dart';
import 'package:campus_connect_v2/features/profile/data/repositories/profile_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:campus_connect_v2/core/theme/app_colors.dart';

import '../../data/models/message_model.dart';

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
  final ProfileRepository _profileRepository = ProfileRepository();
  UserModel? _currentUser;
  bool _loadingProfile = true;
  bool _sending = false;
  List<MessageModel> _messages = [];
  bool _hasNewMessages = false;

  @override
  void initState() {
    super.initState();
    _loadProfileAndMessages();
  }

  Future<void> _loadProfileAndMessages() async {
    try {
      final user = await _profileRepository.getProfile();
      final response = await ApiClient.dio.get('/direct-messages/${widget.otherUserId}');
      final loadedMessages = (response.data as List)
          .map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      if (!mounted) return;

      setState(() {
        _currentUser = user;
        _messages = loadedMessages;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _currentUser = null;
        _messages = [];
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
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);

    try {
      final response = await ApiClient.dio.post(
        '/direct-messages/${widget.otherUserId}',
        data: {'content': text},
      );

      final created = MessageModel.fromJson(Map<String, dynamic>.from(response.data));

      if (!mounted) return;

      setState(() {
        _messages = [..._messages, created];
        _hasNewMessages = true;
      });
      messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } on DioException catch (error) {
      if (mounted) {
        String message = 'Message failed to send';

        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          message = 'The server is taking too long to respond. Please try again.';
        } else if (error.response?.data is Map && error.response!.data['detail'] != null) {
          message = error.response!.data['detail'].toString();
        } else if (error.message != null) {
          message = error.message!;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Widget _messageBubble(MessageModel message) {
    final bool fromMe = message.senderId == (_currentUser?.id ?? 1);
    final String displayName = fromMe ? (_currentUser?.name ?? 'You') : widget.otherUserName;
    final avatarColor = fromMe ? AppColors.primary : AppColors.success;
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
                      color: AppColors.textPrimary,
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
                      color: fromMe ? AppColors.primary : AppColors.surfaceElevated,
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
                      color: AppColors.textSecondary,
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
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceElevated,
          foregroundColor: AppColors.textPrimary,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceElevated,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(_hasNewMessages),
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.success,
                child: Text(
                  widget.otherUserName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.otherUserName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(Icons.call_outlined, color: AppColors.textPrimary),
            ),
          ],
        ),
        body: _loadingProfile
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.surface, AppColors.surface.withAlpha(250), AppColors.background],
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
                    color: AppColors.surfaceElevated,
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceSoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 22,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.border, width: 1),
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
                                  color: AppColors.textSecondary,
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
                            colors: [AppColors.primary, AppColors.blue],
                          ),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          color: Colors.white,
                          onPressed: _sending ? null : _sendMessage,
                          icon: _sending
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
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
      ),
    );
  }
}
