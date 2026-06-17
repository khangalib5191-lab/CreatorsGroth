import '../../../../core/utils/result.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

class MockNotificationRepository implements NotificationRepository {
  final List<NotificationEntity> _notifications = [];

  MockNotificationRepository() {
    _seed();
  }

  void _seed() {
    _notifications.addAll([
      NotificationEntity(
        id: 'notif_1',
        type: NotificationType.taskApproved,
        title: 'Task Approved',
        message: 'Your proof for "Watch Video" was approved. +15 credits',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NotificationEntity(
        id: 'notif_2',
        type: NotificationType.follow,
        title: 'New Follower',
        message: 'Sarah Chen started following you',
        image:
            'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?w=150',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ]);
  }

  @override
  Future<Result<List<NotificationEntity>>> getNotifications(String userId) async =>
      Success(_notifications);

  @override
  Future<Result<void>> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index >= 0) {
      final n = _notifications[index];
      _notifications[index] = NotificationEntity(
        id: n.id,
        type: n.type,
        title: n.title,
        message: n.message,
        image: n.image,
        referenceId: n.referenceId,
        isRead: true,
        createdAt: n.createdAt,
      );
    }
    return const Success(null);
  }

  @override
  Future<Result<void>> markAllAsRead(String userId) async {
    for (var i = 0; i < _notifications.length; i++) {
      final n = _notifications[i];
      _notifications[i] = NotificationEntity(
        id: n.id,
        type: n.type,
        title: n.title,
        message: n.message,
        image: n.image,
        referenceId: n.referenceId,
        isRead: true,
        createdAt: n.createdAt,
      );
    }
    return const Success(null);
  }

  @override
  Future<Result<void>> connectRealtime(String userId) async =>
      const Success(null);
}
