import 'package:equatable/equatable.dart';

enum NotificationType {
  like,
  comment,
  follow,
  taskCompleted,
  taskApproved,
  taskRejected,
  joinRequest,
  adminAnnouncement,
}

class NotificationEntity extends Equatable {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String? image;
  final String? referenceId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.image,
    this.referenceId,
    this.isRead = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
