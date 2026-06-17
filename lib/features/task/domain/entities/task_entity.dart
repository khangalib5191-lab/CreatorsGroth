import 'package:equatable/equatable.dart';
import '../../../../core/constants/task_status.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final String taskType;
  final String platform;
  final String niche;
  final String taskLink;
  final String thumbnail;
  final int reward;
  final int verificationReward;
  final int participantsNeeded;
  final int participantsCompleted;
  final String creatorId;
  final String creatorName;
  final String? creatorImage;
  final TaskStatus status;
  final bool isVerified;
  final int escrowAmount;
  final int platformFee;
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.taskType,
    required this.platform,
    required this.niche,
    required this.taskLink,
    required this.thumbnail,
    required this.reward,
    this.verificationReward = 0,
    required this.participantsNeeded,
    this.participantsCompleted = 0,
    required this.creatorId,
    required this.creatorName,
    this.creatorImage,
    this.status = TaskStatus.active,
    this.isVerified = false,
    this.escrowAmount = 0,
    this.platformFee = 0,
    required this.createdAt,
  });

  int get totalCost => reward * participantsNeeded + platformFee;
  int get remainingSlots => participantsNeeded - participantsCompleted;

  @override
  List<Object?> get props => [id, status, participantsCompleted];
}

class TaskProofEntity extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final String userName;
  final String submittedLink;
  final ProofStatus status;
  final String? userImage;
  final String? rejectionReason;
  final double trustScore;
  final DateTime submittedAt;

  const TaskProofEntity({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.userName,
    required this.submittedLink,
    this.status = ProofStatus.pending,
    this.userImage,
    this.rejectionReason,
    this.trustScore = 100,
    required this.submittedAt,
  });

  @override
  List<Object?> get props => [id, status];
}

class TaskSessionEntity extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final DateTime startTime;
  final String status;
  final String deviceId;

  const TaskSessionEntity({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.startTime,
    required this.status,
    required this.deviceId,
  });

  @override
  List<Object?> get props => [id];
}

class CreateTaskRequest extends Equatable {
  final String title;
  final String description;
  final String taskType;
  final String platform;
  final String niche;
  final String taskLink;
  final String thumbnail;
  final int rewardPerParticipant;
  final int participantCount;
  final String category;

  const CreateTaskRequest({
    required this.title,
    required this.description,
    required this.taskType,
    required this.platform,
    required this.niche,
    required this.taskLink,
    required this.thumbnail,
    required this.rewardPerParticipant,
    required this.participantCount,
    this.category = 'Growth',
  });

  @override
  List<Object?> get props => [title, taskLink, rewardPerParticipant];
}

class TaskCostBreakdown extends Equatable {
  final int totalCreditsRequired;
  final int platformFee;
  final int finalCost;

  const TaskCostBreakdown({
    required this.totalCreditsRequired,
    required this.platformFee,
    required this.finalCost,
  });

  @override
  List<Object?> get props => [finalCost];
}
