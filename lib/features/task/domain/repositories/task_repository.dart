import '../../../../core/utils/result.dart';
import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<Result<List<TaskEntity>>> getMarketplaceTasks({
    required String userId,
    int page = 1,
  });

  Future<Result<List<TaskEntity>>> getMyTasks(String userId);
  Future<Result<List<TaskEntity>>> getCreatedTasks(String userId);
  Future<Result<List<TaskEntity>>> getCompletedTasks(String userId);
  Future<Result<List<TaskProofEntity>>> getPendingProofs(String creatorId);
  Future<Result<TaskEntity>> getTaskById(String id);
  Future<Result<TaskCostBreakdown>> calculateCost(CreateTaskRequest request);
  Future<Result<TaskEntity>> createTask(CreateTaskRequest request, String creatorId);
  Future<Result<TaskSessionEntity>> startTaskSession(String taskId, String userId, String deviceId);
  Future<Result<TaskProofEntity>> submitProof({
    required String taskId,
    required String userId,
    required String verificationUrl,
    required Duration watchDuration,
  });
  Future<Result<void>> approveProof(String proofId);
  Future<Result<void>> rejectProof(String proofId, {String? reason});
}
