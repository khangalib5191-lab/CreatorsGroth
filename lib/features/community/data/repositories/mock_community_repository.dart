import '../../../../core/utils/result.dart';
import '../../domain/entities/community_entity.dart';
import '../../domain/repositories/community_repository.dart';

class MockCommunityRepository implements CommunityRepository {
  final List<CommunityEntity> _communities = [];
  final List<PostEntity> _posts = [];
  final Map<String, List<CommentEntity>> _comments = {};
  final List<GroupEntity> _groups = [];
  final List<JoinRequestEntity> _joinRequests = [];

  MockCommunityRepository() {
    _seed();
  }

  void _seed() {
    _communities.addAll([
      CommunityEntity(
        id: 'comm_1',
        name: 'Tech Creators Hub',
        description: 'Connect with fellow tech content creators',
        image:
            'https://images.pexels.com/photos/3861969/pexels-photo-3861969.jpeg?w=400',
        category: 'Technology',
        membersCount: 1250,
        postsCount: 340,
        isJoined: true,
        createdAt: DateTime(2024, 3, 1),
      ),
      CommunityEntity(
        id: 'comm_2',
        name: 'Gaming Legends',
        description: 'For gaming content creators',
        image:
            'https://images.pexels.com/photos/442576/pexels-photo-442576.jpeg?w=400',
        category: 'Gaming',
        type: CommunityType.private,
        membersCount: 890,
        postsCount: 156,
        createdAt: DateTime(2024, 2, 15),
      ),
    ]);

    _posts.add(PostEntity(
      id: 'post_1',
      communityId: 'comm_1',
      userId: 'user_2',
      userName: 'Sarah Chen',
      content: 'Just hit 50K subscribers! Tips for growth?',
      userImage:
          'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?w=150',
      likesCount: 45,
      commentsCount: 12,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ));

    _comments['post_1'] = [
      CommentEntity(
        id: 'comment_1',
        postId: 'post_1',
        userId: 'user_1',
        userName: 'Alex Johnson',
        content: 'Congrats! Consistency is key.',
        userImage:
            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?w=150',
        likesCount: 5,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];

    _groups.addAll([
      GroupEntity(
        id: 'group_1',
        name: 'Tech Creators Chat',
        description: 'Daily discussions',
        image:
            'https://images.pexels.com/photos/3861969/pexels-photo-3861969.jpeg?w=150',
        memberIds: const ['user_1', 'user_2'],
        createdAt: DateTime(2024, 4, 1),
      ),
      GroupEntity(
        id: 'group_2',
        name: 'Growth Strategies',
        description: 'Share growth tips',
        image:
            'https://images.pexels.com/photos/3184296/pexels-photo-3184296.jpeg?w=150',
        memberIds: const ['user_1', 'user_3'],
        isPrivate: true,
        createdAt: DateTime(2024, 5, 10),
      ),
    ]);
  }

  @override
  Future<Result<List<CommunityEntity>>> getCommunities({int page = 1}) async =>
      Success(_communities);

  @override
  Future<Result<CommunityEntity>> getCommunityById(String id) async {
    try {
      return Success(_communities.firstWhere((c) => c.id == id));
    } catch (_) {
      return const Error('Community not found');
    }
  }

  @override
  Future<Result<List<PostEntity>>> getPosts(String communityId) async =>
      Success(_posts.where((p) => p.communityId == communityId).toList());

  @override
  Future<Result<List<CommentEntity>>> getComments(String postId) async =>
      Success(_comments[postId] ?? []);

  @override
  Future<Result<List<GroupEntity>>> getGroups(String userId) async =>
      Success(_groups.where((g) => g.memberIds.contains(userId)).toList());

  @override
  Future<Result<GroupEntity>> getAdminGroup() async => Success(GroupEntity(
        id: 'admin_group',
        name: 'GroCal Announcements',
        description: 'Official platform announcements',
        image:
            'https://images.pexels.com/photos/3184296/pexels-photo-3184296.jpeg?w=150',
        memberIds: const ['all'],
        createdAt: DateTime(2024, 1, 1),
      ));

  @override
  Future<Result<List<JoinRequestEntity>>> getPendingJoinRequests(
          String communityId) async =>
      Success(_joinRequests
          .where((r) =>
              r.communityId == communityId && r.status == 'pending')
          .toList());

  @override
  Future<Result<void>> requestJoin(String communityId, String userId) async {
    _joinRequests.add(JoinRequestEntity(
      id: 'jr_${DateTime.now().millisecondsSinceEpoch}',
      communityId: communityId,
      userId: userId,
      userName: 'User',
      createdAt: DateTime.now(),
    ));
    return const Success(null);
  }

  @override
  Future<Result<void>> approveJoinRequest(String requestId) async =>
      const Success(null);

  @override
  Future<Result<void>> rejectJoinRequest(String requestId) async =>
      const Success(null);

  @override
  Future<Result<void>> toggleLikePost(String postId, String userId) async =>
      const Success(null);

  @override
  Future<Result<void>> reportCommunity(
          String id, String reason, String reporterId) async =>
      const Success(null);
}
