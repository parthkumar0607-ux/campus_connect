import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/message_model.dart';

class PersonalChatRepository {
  static const String _keyPrefix = 'personal_chat_messages_';

  Future<List<MessageModel>> loadMessages(int otherUserId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawValue = prefs.getString('$_keyPrefix$otherUserId');

    if (rawValue == null || rawValue.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map((item) => MessageModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> saveMessages(int otherUserId, List<MessageModel> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final data = messages
        .map(
          (message) => {
            'id': message.id,
            'team_id': message.teamId,
            'sender_id': message.senderId,
            'sender_name': message.senderName,
            'content': message.content,
            'created_at': message.createdAt.toUtc().toIso8601String(),
          },
        )
        .toList();

    await prefs.setString('$_keyPrefix$otherUserId', jsonEncode(data));
  }

  Future<void> clearMessages(int otherUserId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyPrefix$otherUserId');
  }
}
