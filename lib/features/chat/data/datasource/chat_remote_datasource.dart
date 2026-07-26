import '../../../../core/network/api_client.dart';

import '../models/message_model.dart';

class ChatRemoteDataSource {
  Future<List<MessageModel>> getMessages(
    int teamId,
  ) async {
    final response =
        await ApiClient.dio.get(
      "/chat/$teamId",
    );

    return (response.data as List)
        .map(
          (e) => MessageModel.fromJson(
            e,
          ),
        )
        .toList();
  }

  Future<void> sendMessage({
    required int teamId,
    required String content,
  }) async {
    await ApiClient.dio.post(
      "/chat/$teamId",
      data: {
        "content": content,
      },
    );
  }
}