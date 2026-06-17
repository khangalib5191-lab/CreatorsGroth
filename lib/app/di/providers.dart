import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/app_config.dart';
import '../../core/network/dio_client.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/services/auth_service.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/community/data/repositories/mock_chat_repository.dart';
import '../../features/community/data/repositories/mock_community_repository.dart';
import '../../features/community/domain/repositories/chat_repository.dart';
import '../../features/community/domain/repositories/community_repository.dart';
import '../../features/notifications/data/repositories/mock_notification_repository.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/search/data/repositories/mock_search_repository.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/task/data/repositories/mock_task_repository.dart';
import '../../features/task/domain/repositories/task_repository.dart';
import '../../features/wallet/data/repositories/mock_wallet_repository.dart';
import '../../features/wallet/domain/repositories/wallet_repository.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(tokenStorage: ref.watch(tokenStorageProvider));
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(dioClientProvider));
});

final mockAuthRepositoryProvider = Provider<MockAuthRepository>((ref) {
  return MockAuthRepository();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (AppConfig.useMockRepositories) {
    return ref.watch(mockAuthRepositoryProvider);
  }
  return AuthRepositoryImpl(
    authService: ref.watch(authServiceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return MockTaskRepository(
    authRepository: ref.watch(mockAuthRepositoryProvider),
  );
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return MockWalletRepository(
    authRepository: ref.watch(mockAuthRepositoryProvider),
  );
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return MockCommunityRepository();
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return MockChatRepository();
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return MockNotificationRepository();
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return MockSearchRepository(
    authRepository: ref.watch(mockAuthRepositoryProvider),
    communityRepository:
        ref.watch(communityRepositoryProvider) as MockCommunityRepository,
    taskRepository: ref.watch(taskRepositoryProvider) as MockTaskRepository,
  );
});
