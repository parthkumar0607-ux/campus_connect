class ChatRoomModel {
  final String kind; // 'team' or 'dm'
  final int id;
  final String name;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  ChatRoomModel({
    required this.kind,
    required this.id,
    required this.name,
    this.lastMessage,
    this.lastMessageTime,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      kind: json['kind'] ?? 'team',
      id: json['id'] ?? json['team_id'] ?? 0,
      name: json['name'] ?? json['team_name'] ?? 'Unknown',
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'] == null
          ? null
          : DateTime.parse(json['last_message_time']),
    );
  }
}