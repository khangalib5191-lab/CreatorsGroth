import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String lastMessage;
  final String? userImage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  const ChatEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.lastMessage,
    required this.lastMessageTime,
    this.userImage,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [id];
}

class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String content;
  final String? senderImage;
  final bool isRead;
  final DateTime createdAt;
  final String? replyToId;
  final Map<String, int> reactions;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.senderImage,
    this.isRead = false,
    required this.createdAt,
    this.replyToId,
    this.reactions = const {},
  });

  @override
  List<Object?> get props => [id];
}

class GroupMessageEntity extends Equatable {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String content;
  final String? senderImage;
  final DateTime createdAt;

  const GroupMessageEntity({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.senderImage,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
