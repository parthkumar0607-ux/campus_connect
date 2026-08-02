import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';

import '../../data/models/chat_room_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'chat_detail_screen.dart';

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
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: loadChats,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                    children: [
                      const Text('Your spaces',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      const Text('Keep the campus conversation moving.',
                          style: TextStyle(color: Color(0xFF8E9BB5))),
                      const SizedBox(height: 20),
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
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5865F2), Color(0xFF8B5CF6)],
                  ),
                ),
                child: const Icon(Icons.tag_rounded, color: Colors.white),
              ),
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
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF8E9BB5)),
            ],
          ),
        ),
      );
}
