import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWebSocketService {
  WebSocketChannel? _channel;

  void connect(int teamId) {
    _channel = WebSocketChannel.connect(
      Uri.parse(
        "wss://campus-connect-k76s.onrender.com/chat/ws/$teamId",
      ),
    );
  }

  Stream<Map<String, dynamic>> get stream =>
      _channel!.stream.map(
        (event) => jsonDecode(event),
      );

  void send(Map<String, dynamic> message) {
    _channel?.sink.add(
      jsonEncode(message),
    );
  }

  void disconnect() {
    _channel?.sink.close();
  }
}