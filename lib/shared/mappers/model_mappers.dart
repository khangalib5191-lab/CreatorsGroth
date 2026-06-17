import '../../core/models/community_model.dart';
import '../../core/models/task_model.dart';
import '../../core/models/user_model.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/community/domain/entities/chat_entity.dart';
import '../../features/community/domain/entities/community_entity.dart';
import '../../features/notifications/domain/entities/notification_entity.dart';
import '../../features/task/domain/entities/task_entity.dart';
import '../../features/wallet/domain/entities/wallet_entity.dart';

extension UserEntityMapper on UserEntity {
  UserModel toModel() => UserModel(
        id: id,
        fullName: fullName,
        username: username,
        email: email,
        niche: niche,
        country: country,
        level: level,
        bio: bio,
        profileImage: profileImage,
        coverImage: coverImage,
        platforms: platforms,
        followers: followers,
        following: following,
        points: creditsEarned,
        credits: credits,
        creditsSpent: creditsSpent,
        creditsEarned: creditsEarned,
        tasksCompleted: tasksCompleted,
        tasksCreated: tasksCreated,
        reputationScore: reputationScore,
        isVerified: isVerified,
        isReviewer: isReviewer,
        createdAt: createdAt,
      );
}

extension UserModelMapper on UserModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        fullName: fullName,
        username: username,
        email: email,
        niche: niche,
        country: country,
        level: level,
        bio: bio,
        profileImage: profileImage,
        coverImage: coverImage,
        platforms: platforms,
        followers: followers,
        following: following,
        credits: credits,
        creditsSpent: creditsSpent,
        creditsEarned: creditsEarned,
        tasksCompleted: tasksCompleted,
        tasksCreated: tasksCreated,
        reputationScore: reputationScore,
        isVerified: isVerified,
        isReviewer: isReviewer,
        createdAt: createdAt,
      );
}

extension TaskEntityMapper on TaskEntity {
  TaskModel toModel() => TaskModel(
        id: id,
        title: title,
        description: description,
        category: category,
        taskType: taskType,
        platform: platform,
        niche: niche,
        taskLink: taskLink,
        thumbnail: thumbnail,
        reward: reward,
        verificationReward: verificationReward,
        participantsNeeded: participantsNeeded,
        participantsCompleted: participantsCompleted,
        creatorId: creatorId,
        creatorName: creatorName,
        creatorImage: creatorImage,
        isVerified: isVerified,
        createdAt: createdAt,
      );
}

extension TaskProofEntityMapper on TaskProofEntity {
  TaskProofModel toModel() => TaskProofModel(
        id: id,
        taskId: taskId,
        userId: userId,
        userName: userName,
        submittedLink: submittedLink,
        status: status.name,
        userImage: userImage,
        submittedAt: submittedAt,
      );
}

extension CommunityEntityMapper on CommunityEntity {
  CommunityModel toModel() => CommunityModel(
        id: id,
        name: name,
        description: description,
        image: image,
        category: category,
        membersCount: membersCount,
        postsCount: postsCount,
        isJoined: isJoined,
        createdAt: createdAt,
      );
}

extension PostEntityMapper on PostEntity {
  PostModel toModel() => PostModel(
        id: id,
        communityId: communityId,
        userId: userId,
        userName: userName,
        content: content,
        userImage: userImage,
        image: image,
        likesCount: likesCount,
        commentsCount: commentsCount,
        isLiked: isLiked,
        createdAt: createdAt,
      );
}

extension GroupEntityMapper on GroupEntity {
  GroupModel toModel() => GroupModel(
        id: id,
        name: name,
        description: description,
        image: image,
        memberIds: memberIds,
        isPrivate: isPrivate,
        createdAt: createdAt,
      );
}

extension CommentEntityMapper on CommentEntity {
  CommentModel toModel() => CommentModel(
        id: id,
        postId: postId,
        userId: userId,
        userName: userName,
        content: content,
        userImage: userImage,
        likesCount: likesCount,
        createdAt: createdAt,
      );
}

extension ChatEntityMapper on ChatEntity {
  ChatModel toModel() => ChatModel(
        id: id,
        userId: userId,
        userName: userName,
        lastMessage: lastMessage,
        userImage: userImage,
        lastMessageTime: lastMessageTime,
        unreadCount: unreadCount,
        isOnline: isOnline,
      );
}

extension MessageEntityMapper on MessageEntity {
  MessageModel toModel() => MessageModel(
        id: id,
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        content: content,
        senderImage: senderImage,
        isRead: isRead,
        createdAt: createdAt,
      );
}

extension GroupMessageEntityMapper on GroupMessageEntity {
  GroupMessageModel toModel() => GroupMessageModel(
        id: id,
        groupId: groupId,
        senderId: senderId,
        senderName: senderName,
        content: content,
        senderImage: senderImage,
        createdAt: createdAt,
      );
}

extension NotificationEntityMapper on NotificationEntity {
  NotificationModel toModel() => NotificationModel(
        id: id,
        type: type.name,
        title: title,
        message: message,
        image: image,
        isRead: isRead,
        createdAt: createdAt,
      );
}

extension CreditTransactionMapper on CreditTransaction {
  Map<String, dynamic> toDisplayMap() => {
        'id': id,
        'type': type.name,
        'amount': amount,
        'reason': reason,
        'reference_id': referenceId,
        'created_at': createdAt,
      };
}
