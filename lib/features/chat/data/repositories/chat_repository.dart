import '../datasource/chat_remote_datasource.dart';
import '../models/message_model.dart';

class ChatRepository {
  final ChatRemoteDataSource
      remoteDataSource =
      ChatRemoteDataSource();

  Future<List<MessageModel>>
      getMessages(
    int teamId,
  ) {
    return remoteDataSource
        .getMessages(teamId);
  }

  Future<void> sendMessage({
    required int teamId,
    required String content,
  }) {
    return remoteDataSource
        .sendMessage(
      teamId: teamId,
      content: content,
    );
  }
}