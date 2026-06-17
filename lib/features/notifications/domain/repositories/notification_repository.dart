import '../../../../core/utils/result.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Result<List<NotificationEntity>>> getNotifications(String userId);
  Future<Result<void>> markAsRead(String id);
  Future<Result<void>> markAllAsRead(String userId);
  Future<Result<void>> connectRealtime(String userId);
}
