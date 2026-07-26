class ChatRoomModel {
  final int teamId;
  final String teamName;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  ChatRoomModel({
    required this.teamId,
    required this.teamName,
    this.lastMessage,
    this.lastMessageTime,
  });

  factory ChatRoomModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ChatRoomModel(
      teamId: json["team_id"],
      teamName: json["team_name"],
      lastMessage: json["last_message"],
      lastMessageTime:
          json["last_message_time"] == null
              ? null
              : DateTime.parse(
                  json["last_message_time"],
                ),
    );
  }
}