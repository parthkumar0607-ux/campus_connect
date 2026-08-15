import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';

import '../../data/models/chat_room_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'chat_detail_screen.dart';
import 'personal_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatRepository repository = ChatRepository();
  bool loading = true;
  List<ChatRoomModel> chatRooms = [];

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  Future<void> loadChats() async {
    try {
      final rooms = await repository.getChatRooms();
      if (mounted) setState(() => chatRooms = rooms);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF090B10),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF101319), Color(0xFF0B0D12), Color(0xFF090B10)],
            ),
          ),
          child: SafeArea(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                  onRefresh: loadChats,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                    children: [
                      Row(children: [
                        const Expanded(
                          child: Text('Chats',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .08),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add, color: Colors.white),
                            tooltip: 'New chat',
                          ),
                        ),
                      ]),
                      const SizedBox(height: 14),
                      const TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Search chats...',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (chatRooms.isNotEmpty) ...[
                        const Text('ACTIVE NOW',
                            style: TextStyle(
                                color: Color(0xFFA9A6B4),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 76,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: chatRooms.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 12),
                            itemBuilder: (_, index) {
                              final room = chatRooms[index];
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PersonalChatScreen(
                                      otherUserName: room.teamName,
                                      otherUserId: room.teamId,
                                    ),
                                  ),
                                ),
                                child: _ActiveChannel(room: room),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      const Text('YOUR CHANNELS',
                          style: TextStyle(
                              color: Color(0xFFA9A6B4),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1)),
                      const SizedBox(height: 12),
                      if (chatRooms.isEmpty)
                        const GlassCard(
                          child: Column(
                            children: [
                              Icon(Icons.forum_outlined,
                                  size: 44, color: Color(0xFF8B95FF)),
                              SizedBox(height: 12),
                              Text('No channels yet',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18)),
                              SizedBox(height: 6),
                              Text('Join a team to unlock its private channel.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFF8E9BB5))),
                            ],
                          ),
                        )
                      else
                        ...chatRooms.map(
                          (room) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ChannelCard(
                              room: room,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatDetailScreen(
                                    teamId: room.teamId,
                                    teamName: room.teamName,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
          ),
        ),
      );
}

class _ChannelCard extends StatelessWidget {
  final ChatRoomModel room;
  final VoidCallback onTap;
  const _ChannelCard({required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: GlassCard(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Stack(children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFFE85AD7)],
                  ),
                ),
                child: const Icon(Icons.tag_rounded, color: Colors.white),
              ),
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  height: 13,
                  width: 13,
                  decoration: BoxDecoration(
                    color: const Color(0xFF57F287),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF18181F), width: 2),
                  ),
                ),
              ),
              ]),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.teamName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(room.lastMessage ?? 'Start the conversation',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF8E9BB5))),
                  ],
                ),
              ),
              Column(children: [
                Text(_timeAgo(room.lastMessageTime),
                    style: const TextStyle(color: Color(0xFFA9A6B4), fontSize: 11)),
                const SizedBox(height: 7),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFFA9A6B4), size: 19),
              ]),
            ],
          ),
        ),
      );
}

class _ActiveChannel extends StatelessWidget {
  final ChatRoomModel room;
  const _ActiveChannel({required this.room});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 62,
        child: Column(children: [
          Stack(children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: const Color(0xFF28223A),
              child: Text(room.teamName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 13,
                width: 13,
                decoration: BoxDecoration(
                  color: const Color(0xFF57F287),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0B0B10), width: 2),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 6),
          Text(room.teamName, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFFA9A6B4), fontSize: 11)),
        ]),
      );
}

String _timeAgo(DateTime? value) {
  if (value == null) return '';
  final difference = DateTime.now().difference(value.toLocal());
  if (difference.inMinutes < 1) return 'now';
  if (difference.inHours < 1) return '${difference.inMinutes}m';
  if (difference.inDays < 1) return '${difference.inHours}h';
  return '${difference.inDays}d';
}
