import '../../../../core/utils/result.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../community/domain/entities/community_entity.dart';
import '../../../task/domain/entities/task_entity.dart';

abstract class SearchRepository {
  Future<Result<PaginatedResult<UserEntity>>> searchUsers(String query, {int page = 1});
  Future<Result<PaginatedResult<CommunityEntity>>> searchCommunities(String query, {int page = 1});
  Future<Result<PaginatedResult<TaskEntity>>> searchTasks(String query, {int page = 1});
  Future<Result<void>> reportUser(String userId, String reason, String reporterId);
  Future<Result<void>> reportTask(String taskId, String reason, String reporterId);
  Future<Result<void>> reportMessage(String messageId, String reason, String reporterId);
}
