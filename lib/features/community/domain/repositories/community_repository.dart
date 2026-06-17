import '../../../../core/utils/result.dart';
import '../entities/community_entity.dart';

abstract class CommunityRepository {
  Future<Result<List<CommunityEntity>>> getCommunities({int page = 1});
  Future<Result<CommunityEntity>> getCommunityById(String id);
  Future<Result<List<PostEntity>>> getPosts(String communityId);
  Future<Result<List<CommentEntity>>> getComments(String postId);
  Future<Result<List<GroupEntity>>> getGroups(String userId);
  Future<Result<GroupEntity>> getAdminGroup();
  Future<Result<List<JoinRequestEntity>>> getPendingJoinRequests(String communityId);
  Future<Result<void>> requestJoin(String communityId, String userId);
  Future<Result<void>> approveJoinRequest(String requestId);
  Future<Result<void>> rejectJoinRequest(String requestId);
  Future<Result<void>> toggleLikePost(String postId, String userId);
  Future<Result<void>> reportCommunity(String id, String reason, String reporterId);
}
