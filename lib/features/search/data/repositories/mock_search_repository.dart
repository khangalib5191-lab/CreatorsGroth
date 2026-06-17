import '../../../../core/utils/result.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../community/data/repositories/mock_community_repository.dart';
import '../../../community/domain/entities/community_entity.dart';
import '../../../task/data/repositories/mock_task_repository.dart';
import '../../../task/domain/entities/task_entity.dart';
import '../../domain/repositories/search_repository.dart';

class MockSearchRepository implements SearchRepository {
  final MockAuthRepository authRepository;
  final MockCommunityRepository communityRepository;
  final MockTaskRepository taskRepository;

  MockSearchRepository({
    required this.authRepository,
    required this.communityRepository,
    required this.taskRepository,
  });

  @override
  Future<Result<PaginatedResult<UserEntity>>> searchUsers(String query,
      {int page = 1}) async {
    final q = query.toLowerCase();
    final users = authRepository.suggestedCreators
        .where((u) =>
            u.fullName.toLowerCase().contains(q) ||
            u.username.toLowerCase().contains(q) ||
            u.niche.toLowerCase().contains(q))
        .toList();
    return Success(PaginatedResult(
      items: users,
      currentPage: page,
      lastPage: 1,
      total: users.length,
    ));
  }

  @override
  Future<Result<PaginatedResult<CommunityEntity>>> searchCommunities(
      String query,
      {int page = 1}) async {
    final result = await communityRepository.getCommunities(page: page);
    if (result is Error) return Error((result as Error).message);
    final all = (result as Success<List<CommunityEntity>>).data;
    final q = query.toLowerCase();
    final filtered = all
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.description.toLowerCase().contains(q))
        .toList();
    return Success(PaginatedResult(
      items: filtered,
      currentPage: page,
      lastPage: 1,
      total: filtered.length,
    ));
  }

  @override
  Future<Result<PaginatedResult<TaskEntity>>> searchTasks(String query,
      {int page = 1}) async {
    final userId = authRepository.currentUserInternal?.id ?? '';
    final result =
        await taskRepository.getMarketplaceTasks(userId: userId, page: page);
    if (result is Error) return Error((result as Error).message);
    final all = (result as Success<List<TaskEntity>>).data;
    final q = query.toLowerCase();
    final filtered = all
        .where((t) =>
            t.title.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q))
        .toList();
    return Success(PaginatedResult(
      items: filtered,
      currentPage: page,
      lastPage: 1,
      total: filtered.length,
    ));
  }

  @override
  Future<Result<void>> reportUser(
          String userId, String reason, String reporterId) async =>
      const Success(null);

  @override
  Future<Result<void>> reportTask(
          String taskId, String reason, String reporterId) async =>
      const Success(null);

  @override
  Future<Result<void>> reportMessage(
          String messageId, String reason, String reporterId) async =>
      const Success(null);
}
