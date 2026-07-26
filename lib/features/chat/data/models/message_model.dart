class MessageModel {
  final int id;
  final int teamId;
  final int senderId;
  final String content;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.teamId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  factory MessageModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MessageModel(
      id: json["id"],
      teamId: json["team_id"],
      senderId: json["sender_id"],
      content: json["content"],
      createdAt: DateTime.parse(
        json["created_at"],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "content": content,
    };
  }
}