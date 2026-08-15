import 'package:campus_connect_v2/features/chat/data/models/message_model.dart';
import 'package:campus_connect_v2/features/chat/data/repositories/personal_chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('saves and loads personal chat messages for a specific user', () async {
    final repository = PersonalChatRepository();
    final messages = [
      MessageModel(
        id: 101,
        teamId: 0,
        senderId: 42,
        senderName: 'Aarav',
        content: 'Hi, are you free this evening?',
        createdAt: DateTime.now(),
      ),
      MessageModel(
        id: 102,
        teamId: 0,
        senderId: 1,
        senderName: 'You',
        content: 'Yes, let’s do 6 PM.',
        createdAt: DateTime.now().add(const Duration(minutes: 2)),
      ),
    ];

    await repository.saveMessages(42, messages);
    final loaded = await repository.loadMessages(42);

    expect(loaded.length, 2);
    expect(loaded.first.content, 'Hi, are you free this evening?');
    expect(loaded.last.content, 'Yes, let’s do 6 PM.');
  });
}
