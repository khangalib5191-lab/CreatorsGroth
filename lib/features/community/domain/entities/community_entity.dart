import 'package:equatable/equatable.dart';

enum CommunityType { public, private, inviteOnly }

class CommunityEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String image;
  final String? banner;
  final String category;
  final CommunityType type;
  final List<String> tags;
  final String? rules;
  final int membersCount;
  final int postsCount;
  final bool isJoined;
  final DateTime createdAt;

  const CommunityEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    this.banner,
    this.type = CommunityType.public,
    this.tags = const [],
    this.rules,
    this.membersCount = 0,
    this.postsCount = 0,
    this.isJoined = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}

class PostEntity extends Equatable {
  final String id;
  final String communityId;
  final String userId;
  final String userName;
  final String content;
  final String? userImage;
  final String? image;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.communityId,
    required this.userId,
    required this.userName,
    required this.content,
    this.userImage,
    this.image,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}

class GroupEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String image;
  final List<String> memberIds;
  final bool isPrivate;
  final DateTime createdAt;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.memberIds,
    this.isPrivate = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}

class CommentEntity extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String content;
  final String? userImage;
  final int likesCount;
  final DateTime createdAt;

  const CommentEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.content,
    this.userImage,
    this.likesCount = 0,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}

class JoinRequestEntity extends Equatable {
  final String id;
  final String communityId;
  final String userId;
  final String userName;
  final String status;
  final DateTime createdAt;

  const JoinRequestEntity({
    required this.id,
    required this.communityId,
    required this.userId,
    required this.userName,
    this.status = 'pending',
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
