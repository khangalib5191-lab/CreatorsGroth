import 'package:uuid/uuid.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/task_status.dart';
import '../../../../core/utils/business_logic.dart';
import '../../../../core/utils/result.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';

class MockTaskRepository implements TaskRepository {
  final MockAuthRepository authRepository;
  final _uuid = const Uuid();
  final List<TaskEntity> _tasks = [];
  final List<TaskProofEntity> _proofs = [];
  final Set<String> _completedTaskKeys = {};
  final Map<String, TaskSessionEntity> _sessions = {};
  final TaskCostCalculator _calculator =
      TaskCostCalculator(platformFeePercent: AppConfig.platformFeePercent);

  MockTaskRepository({required this.authRepository}) {
    _seedTasks();
  }

  void _seedTasks() {
    _tasks.addAll([
      TaskEntity(
        id: 'task_1',
        title: 'Watch My Latest Tech Review Video',
        description: 'Watch my comprehensive review of the new iPhone.',
        category: 'Promotion',
        taskType: 'Watch Video',
        platform: 'YouTube',
        niche: 'Technology',
        taskLink: 'https://youtube.com/watch?v=abc123',
        thumbnail:
            'https://images.pexels.com/photos/607812/pexels-photo-607812.jpeg?w=400',
        reward: 15,
        participantsNeeded: 100,
        participantsCompleted: 67,
        creatorId: 'user_2',
        creatorName: 'Sarah Chen',
        creatorImage:
            'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?w=150',
        status: TaskStatus.active,
        isVerified: true,
        escrowAmount: 1650,
        platformFee: 150,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TaskEntity(
        id: 'task_2',
        title: 'Follow My Gaming Channel',
        description: 'Subscribe for amazing gaming content!',
        category: 'Growth',
        taskType: 'Follow User',
        platform: 'YouTube',
        niche: 'Gaming',
        taskLink: 'https://youtube.com/@gamingchannel',
        thumbnail:
            'https://images.pexels.com/photos/442576/pexels-photo-442576.jpeg?w=400',
        reward: 10,
        participantsNeeded: 50,
        participantsCompleted: 23,
        creatorId: 'user_3',
        creatorName: 'Mike Rivera',
        creatorImage:
            'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?w=150',
        status: TaskStatus.active,
        escrowAmount: 550,
        platformFee: 50,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ]);

    _proofs.add(TaskProofEntity(
      id: 'proof_1',
      taskId: 'task_1',
      userId: 'user_4',
      userName: 'John Doe',
      submittedLink: 'https://youtube.com/watch?v=abc123',
      status: ProofStatus.pending,
      submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ));
  }

  @override
  Future<Result<List<TaskEntity>>> getMarketplaceTasks({
    required String userId,
    int page = 1,
  }) async {
    final filtered = _tasks.where((t) {
      if (t.creatorId == userId) return false;
      if (t.status != TaskStatus.active) return false;
      if (_completedTaskKeys.contains('$userId:${t.id}')) return false;
      return true;
    }).toList();
    return Success(filtered);
  }

  @override
  Future<Result<List<TaskEntity>>> getMyTasks(String userId) async =>
      Success(_tasks.where((t) => t.creatorId != userId).toList());

  @override
  Future<Result<List<TaskEntity>>> getCreatedTasks(String userId) async =>
      Success(_tasks.where((t) => t.creatorId == userId).toList());

  @override
  Future<Result<List<TaskEntity>>> getCompletedTasks(String userId) async {
    final completedIds = _completedTaskKeys
        .where((k) => k.startsWith('$userId:'))
        .map((k) => k.split(':').last)
        .toSet();
    return Success(_tasks.where((t) => completedIds.contains(t.id)).toList());
  }

  @override
  Future<Result<List<TaskProofEntity>>> getPendingProofs(String creatorId) async {
    final creatorTaskIds =
        _tasks.where((t) => t.creatorId == creatorId).map((t) => t.id).toSet();
    return Success(_proofs
        .where((p) =>
            creatorTaskIds.contains(p.taskId) &&
            p.status == ProofStatus.pending)
        .toList());
  }

  @override
  Future<Result<TaskEntity>> getTaskById(String id) async {
    try {
      return Success(_tasks.firstWhere((t) => t.id == id));
    } catch (_) {
      return const Error('Task not found');
    }
  }

  @override
  Future<Result<TaskCostBreakdown>> calculateCost(CreateTaskRequest request) async {
    if (!UrlValidator.isValidForPlatform(request.taskLink, request.platform)) {
      return const Error('Invalid URL for selected platform');
    }

    final total = _calculator.totalCreditsRequired(
      request.rewardPerParticipant,
      request.participantCount,
    );
    final fee = _calculator.platformFee(
      request.rewardPerParticipant,
      request.participantCount,
    );
    return Success(TaskCostBreakdown(
      totalCreditsRequired: total,
      platformFee: fee,
      finalCost: total + fee,
    ));
  }

  @override
  Future<Result<TaskEntity>> createTask(
      CreateTaskRequest request, String creatorId) async {
    final costResult = await calculateCost(request);
    if (costResult is Error<TaskCostBreakdown>) {
      return Error(costResult.message);
    }
    final cost = (costResult as Success<TaskCostBreakdown>).data;

    final user = authRepository.currentUserInternal;
    if (user == null) return const Error('Not authenticated');
    if (user.credits < cost.finalCost) {
      return const Error('Insufficient Credits');
    }

    if (_tasks.any((t) =>
        t.creatorId == creatorId &&
        t.taskLink == request.taskLink &&
        t.status == TaskStatus.active)) {
      return const Error('Duplicate task detected');
    }

    if (user.reputationScore < 50) {
      return const Error('Reputation too low to create tasks');
    }

    final task = TaskEntity(
      id: 'task_${_uuid.v4()}',
      title: request.title,
      description: request.description,
      category: request.category,
      taskType: request.taskType,
      platform: request.platform,
      niche: request.niche,
      taskLink: request.taskLink,
      thumbnail: request.thumbnail,
      reward: request.rewardPerParticipant,
      participantsNeeded: request.participantCount,
      creatorId: creatorId,
      creatorName: user.fullName,
      creatorImage: user.profileImage,
      status: TaskStatus.pendingReview,
      escrowAmount: cost.finalCost,
      platformFee: cost.platformFee,
      createdAt: DateTime.now(),
    );

    _tasks.insert(0, task);
    authRepository.updateCurrentUser(user.copyWith(
      credits: user.credits - cost.finalCost,
      creditsSpent: user.creditsSpent + cost.finalCost,
      tasksCreated: user.tasksCreated + 1,
    ));

    return Success(task);
  }

  @override
  Future<Result<TaskSessionEntity>> startTaskSession(
      String taskId, String userId, String deviceId) async {
    final session = TaskSessionEntity(
      id: _uuid.v4(),
      taskId: taskId,
      userId: userId,
      startTime: DateTime.now(),
      status: 'active',
      deviceId: deviceId,
    );
    _sessions[session.id] = session;
    return Success(session);
  }

  @override
  Future<Result<TaskProofEntity>> submitProof({
    required String taskId,
    required String userId,
    required String verificationUrl,
    required Duration watchDuration,
  }) async {
    final taskResult = await getTaskById(taskId);
    if (taskResult is Error<TaskEntity>) return Error(taskResult.message);
    final task = (taskResult as Success<TaskEntity>).data;

    final alreadyCompleted = _completedTaskKeys.contains('$userId:$taskId');
    final verification = VerificationEngine.verify(
      taskLink: task.taskLink,
      verificationUrl: verificationUrl,
      platform: task.platform,
      alreadyCompleted: alreadyCompleted,
      watchDuration: watchDuration,
      minimumWatchDuration: const Duration(minutes: 3),
    );

    final user = authRepository.currentUserInternal;
    final proof = TaskProofEntity(
      id: _uuid.v4(),
      taskId: taskId,
      userId: userId,
      userName: user?.fullName ?? 'User',
      submittedLink: verificationUrl,
      status: verification['auto_approve'] == true
          ? ProofStatus.approved
          : ProofStatus.underReview,
      rejectionReason: verification['rejection_reason']?.toString(),
      trustScore: (verification['trust_score'] as num).toDouble(),
      submittedAt: DateTime.now(),
    );

    if (proof.status == ProofStatus.approved) {
      _completedTaskKeys.add('$userId:$taskId');
      if (user != null) {
        authRepository.updateCurrentUser(user.copyWith(
          credits: user.credits + task.reward,
          creditsEarned: user.creditsEarned + task.reward,
          tasksCompleted: user.tasksCompleted + 1,
          reputationScore:
              ReputationCalculator.onProofApproved(user.reputationScore),
        ));
      }
    } else if (verification['rejection_reason'] != null &&
        verification['watch_time_pass'] == false) {
      return Error(verification['rejection_reason'].toString());
    } else {
      _proofs.add(proof);
    }

    return Success(proof);
  }

  @override
  Future<Result<void>> approveProof(String proofId) async {
    final index = _proofs.indexWhere((p) => p.id == proofId);
    if (index == -1) return const Error('Proof not found');
    _proofs.removeAt(index);
    return const Success(null);
  }

  @override
  Future<Result<void>> rejectProof(String proofId, {String? reason}) async {
    final index = _proofs.indexWhere((p) => p.id == proofId);
    if (index == -1) return const Error('Proof not found');
    _proofs.removeAt(index);
    return const Success(null);
  }
}
