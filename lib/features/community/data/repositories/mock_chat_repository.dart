import '../../../../core/utils/result.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';

class MockChatRepository implements ChatRepository {
  final Map<String, List<MessageEntity>> _messages = {};
  final List<ChatEntity> _chats = [];
  final Map<String, List<GroupMessageEntity>> _groupMessages = {};

  MockChatRepository() {
    _seed();
  }

  void _seed() {
    _chats.add(ChatEntity(
      id: 'chat_1',
      userId: 'user_2',
      userName: 'Sarah Chen',
      lastMessage: 'Thanks for completing my task!',
      userImage:
          'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?w=150',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
      unreadCount: 2,
      isOnline: true,
    ));

    _messages['chat_1'] = [
      MessageEntity(
        id: 'msg_1',
        chatId: 'chat_1',
        senderId: 'user_2',
        senderName: 'Sarah Chen',
        content: 'Hey! Can you help with my task?',
        senderImage:
            'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?w=150',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      MessageEntity(
        id: 'msg_2',
        chatId: 'chat_1',
        senderId: 'user_1',
        senderName: 'Alex Johnson',
        content: 'Sure, I will check it out!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
    ];

    _groupMessages['group_1'] = [
      GroupMessageEntity(
        id: 'gmsg_1',
        groupId: 'group_1',
        senderId: 'user_2',
        senderName: 'Sarah Chen',
        content: 'Welcome everyone!',
        senderImage:
            'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?w=150',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];

    _groupMessages['admin_group'] = [
      GroupMessageEntity(
        id: 'admin_msg_1',
        groupId: 'admin_group',
        senderId: 'admin',
        senderName: 'GroCal Admin',
        content: 'Welcome to GroCal! Complete tasks to earn credits.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<Result<List<ChatEntity>>> getChats(String userId) async =>
      Success(_chats);

  @override
  Future<Result<List<MessageEntity>>> getMessages(String chatId) async =>
      Success(_messages[chatId] ?? []);

  @override
  Future<Result<List<GroupMessageEntity>>> getGroupMessages(
          String groupId) async =>
      Success(_groupMessages[groupId] ?? []);

  @override
  Future<Result<MessageEntity>> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String? replyToId,
  }) async {
    final message = MessageEntity(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      senderId: senderId,
      senderName: 'You',
      content: content,
      createdAt: DateTime.now(),
      replyToId: replyToId,
    );
    _messages.putIfAbsent(chatId, () => []).add(message);
    return Success(message);
  }

  @override
  Future<Result<void>> connectWebSocket(String userId) async =>
      const Success(null);

  @override
  Future<void> disconnectWebSocket() async {}
}
