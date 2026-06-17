import '../../../../core/utils/result.dart';
import '../entities/chat_entity.dart';

abstract class ChatRepository {
  Future<Result<List<ChatEntity>>> getChats(String userId);
  Future<Result<List<MessageEntity>>> getMessages(String chatId);
  Future<Result<List<GroupMessageEntity>>> getGroupMessages(String groupId);
  Future<Result<MessageEntity>> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String? replyToId,
  });
  Future<Result<void>> connectWebSocket(String userId);
  Future<void> disconnectWebSocket();
}
