import 'package:flutter/material.dart';

import '../../data/models/chat_room_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {
  final ChatRepository repository =
      ChatRepository();

  bool loading = true;

  List<ChatRoomModel> chatRooms = [];

  @override
  void initState() {
    super.initState();
    loadChats();
  }

  Future<void> loadChats() async {
    try {
      final rooms =
          await repository.getChatRooms();

      if (!mounted) return;

      setState(() {
        chatRooms = rooms;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  String subtitle(
    ChatRoomModel room,
  ) {
    if (room.lastMessage == null) {
      return "No messages yet";
    }

    return room.lastMessage!;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : chatRooms.isEmpty
              ? const Center(
                  child: Text(
                    "Join a team to start chatting.",
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadChats,
                  child:
                      ListView.builder(
                    itemCount:
                        chatRooms.length,
                    itemBuilder:
                        (
                      context,
                      index,
                    ) {
                      final room =
                          chatRooms[index];

                      return ListTile(
                        leading:
                            const CircleAvatar(
                          child: Icon(
                            Icons.groups,
                          ),
                        ),
                        title: Text(
                          room.teamName,
                        ),
                        subtitle: Text(
                          subtitle(room),
                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                        ),
                        trailing:
                            const Icon(
                          Icons
                              .chevron_right,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChatDetailScreen(
                                teamId:
                                    room.teamId,
                                teamName:
                                    room.teamName,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}