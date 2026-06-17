import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/community_model.dart';
import '../../core/models/task_model.dart';
import '../../core/models/user_model.dart';
import '../../core/utils/result.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/community/domain/entities/chat_entity.dart';
import '../../features/community/domain/entities/community_entity.dart';
import '../../features/notifications/domain/entities/notification_entity.dart';
import '../../features/task/domain/entities/task_entity.dart';
import '../../features/wallet/domain/entities/wallet_entity.dart';
import '../../shared/mappers/model_mappers.dart';
import '../di/providers.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    bool clearError = false,
  }) =>
      AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : (error ?? this.error),
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(authRepositoryProvider);
    final authResult = await repo.isAuthenticated();
    if (authResult is Success<bool> && authResult.data) {
      final userResult = await repo.getCurrentUser();
      if (userResult is Success<UserEntity>) {
        state = AuthState(
          user: userResult.data.toModel(),
          isAuthenticated: true,
        );
        return;
      }
    }
    state = const AuthState(isAuthenticated: false);
  }

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(authRepositoryProvider).login(
          email: email,
          password: password,
          rememberMe: rememberMe,
        );
    return result.when(
      success: (data) {
        state = AuthState(
          user: data.user.toModel(),
          isAuthenticated: true,
        );
        return true;
      },
      failure: (message) {
        state = state.copyWith(isLoading: false, error: message);
        return false;
      },
    );
  }

  Future<bool> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String niche,
    required String country,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await ref.read(authRepositoryProvider).register(
          fullName: fullName,
          username: username,
          email: email,
          password: password,
          niche: niche,
          country: country,
        );
    return result.when(
      success: (user) {
        state = AuthState(user: user.toModel(), isAuthenticated: true);
        return true;
      },
      failure: (message) {
        state = state.copyWith(isLoading: false, error: message);
        return false;
      },
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState(isAuthenticated: false);
  }

  void updateUser(UserModel user) {
    state = state.copyWith(user: user);
    final mock = ref.read(mockAuthRepositoryProvider);
    mock.updateCurrentUser(user.toEntity());
  }

  List<UserModel> get suggestedCreators =>
      ref.read(mockAuthRepositoryProvider).suggestedCreators.map((e) => e.toModel()).toList();

  UserModel? getUserById(String id) =>
      ref.read(mockAuthRepositoryProvider).getUserById(id)?.toModel();
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));

class TaskState {
  final List<TaskModel> tasks;
  final List<TaskProofModel> pendingProofs;
  final bool isLoading;
  final String? error;

  const TaskState({
    this.tasks = const [],
    this.pendingProofs = const [],
    this.isLoading = false,
    this.error,
  });
}

class TaskNotifier extends StateNotifier<TaskState> {
  final Ref ref;

  TaskNotifier(this.ref) : super(const TaskState()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final userId = ref.read(authNotifierProvider).user?.id;
    if (userId == null) return;
    state = TaskState(tasks: state.tasks, isLoading: true);
    final result =
        await ref.read(taskRepositoryProvider).getMarketplaceTasks(userId: userId);
    final proofs = await ref
        .read(taskRepositoryProvider)
        .getPendingProofs(userId);
    if (result is Success<List<TaskEntity>>) {
      state = TaskState(
        tasks: result.data.map((t) => t.toModel()).toList(),
        pendingProofs: proofs is Success<List<TaskProofEntity>>
            ? (proofs)
                .data
                .map((p) => p.toModel())
                .toList()
            : [],
      );
    }
  }

  Future<String?> createTask(CreateTaskRequest request) async {
    final userId = ref.read(authNotifierProvider).user?.id;
    if (userId == null) return 'Not authenticated';
    final result =
        await ref.read(taskRepositoryProvider).createTask(request, userId);
    if (result is Error<TaskEntity>) return result.message;
    await loadTasks();
    final userResult = await ref.read(authRepositoryProvider).getCurrentUser();
    if (userResult is Success<UserEntity>) {
      ref.read(authNotifierProvider.notifier).updateUser(userResult.data.toModel());
    }
    return null;
  }

  Future<String?> submitProof({
    required String taskId,
    required String verificationUrl,
    Duration watchDuration = const Duration(minutes: 5),
  }) async {
    final userId = ref.read(authNotifierProvider).user?.id;
    if (userId == null) return 'Not authenticated';
    final result = await ref.read(taskRepositoryProvider).submitProof(
          taskId: taskId,
          userId: userId,
          verificationUrl: verificationUrl,
          watchDuration: watchDuration,
        );
    if (result is Error<TaskProofEntity>) return result.message;
    await loadTasks();
    final userResult = await ref.read(authRepositoryProvider).getCurrentUser();
    if (userResult is Success<UserEntity>) {
      ref.read(authNotifierProvider.notifier).updateUser(userResult.data.toModel());
    }
    return null;
  }

  Future<void> approveProof(String id) async {
    await ref.read(taskRepositoryProvider).approveProof(id);
    await loadTasks();
  }

  Future<void> rejectProof(String id) async {
    await ref.read(taskRepositoryProvider).rejectProof(id);
    await loadTasks();
  }
}

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskState>((ref) => TaskNotifier(ref));

class CommunityState {
  final List<CommunityModel> communities;
  final List<PostModel> posts;
  final bool isLoading;

  const CommunityState({
    this.communities = const [],
    this.posts = const [],
    this.isLoading = false,
  });
}

class CommunityNotifier extends StateNotifier<CommunityState> {
  final Ref ref;

  CommunityNotifier(this.ref) : super(const CommunityState()) {
    load();
  }

  Future<void> load() async {
    final communities = await ref.read(communityRepositoryProvider).getCommunities();
    if (communities is Success<List<CommunityEntity>>) {
      var posts = <PostModel>[];
      if (communities.data.isNotEmpty) {
        final postsResult = await ref
            .read(communityRepositoryProvider)
            .getPosts(communities.data.first.id);
        if (postsResult is Success<List<PostEntity>>) {
          posts = postsResult.data.map((p) => p.toModel()).toList();
        }
      }
      state = CommunityState(
        communities: communities.data.map((c) => c.toModel()).toList(),
        posts: posts,
      );
    }
  }

  Future<void> loadPosts(String communityId) async {
    final posts = await ref.read(communityRepositoryProvider).getPosts(communityId);
    if (posts is Success<List<PostEntity>>) {
      state = CommunityState(
        communities: state.communities,
        posts: posts.data.map((p) => p.toModel()).toList(),
      );
    }
  }

  Future<List<CommentModel>> getComments(String postId) async {
    final result = await ref.read(communityRepositoryProvider).getComments(postId);
    if (result is Success<List<CommentEntity>>) {
      return result.data.map((c) => c.toModel()).toList();
    }
    return [];
  }

  Future<List<GroupModel>> getGroups() async {
    final userId = ref.read(authNotifierProvider).user?.id ?? '';
    final result = await ref.read(communityRepositoryProvider).getGroups(userId);
    if (result is Success<List<GroupEntity>>) {
      return result.data.map((g) => g.toModel()).toList();
    }
    return [];
  }

  Future<GroupModel?> getAdminGroup() async {
    final result = await ref.read(communityRepositoryProvider).getAdminGroup();
    if (result is Success<GroupEntity>) return result.data.toModel();
    return null;
  }
}

final communityNotifierProvider =
    StateNotifierProvider<CommunityNotifier, CommunityState>(
        (ref) => CommunityNotifier(ref));

class ChatState {
  final List<ChatModel> chats;
  final bool isLoading;

  const ChatState({this.chats = const [], this.isLoading = false});
}

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref ref;

  ChatNotifier(this.ref) : super(const ChatState()) {
    loadChats();
  }

  Future<void> loadChats() async {
    final userId = ref.read(authNotifierProvider).user?.id ?? '';
    final result = await ref.read(chatRepositoryProvider).getChats(userId);
    if (result is Success<List<ChatEntity>>) {
      state = ChatState(chats: result.data.map((c) => c.toModel()).toList());
    }
  }

  Future<List<MessageModel>> getMessages(String chatId) async {
    final result = await ref.read(chatRepositoryProvider).getMessages(chatId);
    if (result is Success<List<MessageEntity>>) {
      return result.data.map((m) => m.toModel()).toList();
    }
    return [];
  }

  Future<List<GroupMessageModel>> getGroupMessages(String groupId) async {
    final result = await ref.read(chatRepositoryProvider).getGroupMessages(groupId);
    if (result is Success<List<GroupMessageEntity>>) {
      return result.data.map((m) => m.toModel()).toList();
    }
    return [];
  }

  Future<void> sendMessage(String chatId, String content, String senderId) async {
    await ref.read(chatRepositoryProvider).sendMessage(
          chatId: chatId,
          senderId: senderId,
          content: content,
        );
    await loadChats();
  }
}

final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, ChatState>((ref) => ChatNotifier(ref));

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;

  const NotificationState({this.notifications = const [], this.isLoading = false});

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final Ref ref;

  NotificationNotifier(this.ref) : super(const NotificationState()) {
    load();
  }

  Future<void> load() async {
    final userId = ref.read(authNotifierProvider).user?.id ?? '';
    final result =
        await ref.read(notificationRepositoryProvider).getNotifications(userId);
    if (result is Success<List<NotificationEntity>>) {
      state = NotificationState(
        notifications: result.data.map((n) => n.toModel()).toList(),
      );
    }
  }

  Future<void> markAsRead(String id) async {
    await ref.read(notificationRepositoryProvider).markAsRead(id);
    await load();
  }

  Future<void> markAllAsRead() async {
    final userId = ref.read(authNotifierProvider).user?.id ?? '';
    await ref.read(notificationRepositoryProvider).markAllAsRead(userId);
    await load();
  }
}

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
        (ref) => NotificationNotifier(ref));

class WalletState {
  final List<Map<String, dynamic>> transactions;
  final bool isLoading;

  const WalletState({this.transactions = const [], this.isLoading = false});
}

class WalletNotifier extends StateNotifier<WalletState> {
  final Ref ref;

  WalletNotifier(this.ref) : super(const WalletState()) {
    load();
  }

  Future<void> load() async {
    final userId = ref.read(authNotifierProvider).user?.id;
    if (userId == null) return;
    final result =
        await ref.read(walletRepositoryProvider).getTransactions(userId);
    if (result is Success<List<CreditTransaction>>) {
      state = WalletState(
        transactions: result.data.map((t) => t.toDisplayMap()).toList(),
      );
    }
  }
}

final walletNotifierProvider =
    StateNotifierProvider<WalletNotifier, WalletState>((ref) => WalletNotifier(ref));

class SearchNotifier {
  final Ref ref;
  SearchNotifier(this.ref);

  Future<List<UserModel>> searchUsers(String query) async {
    final result = await ref.read(searchRepositoryProvider).searchUsers(query);
    if (result is Success<PaginatedResult<UserEntity>>) {
      return result.data.items.map((u) => u.toModel()).toList();
    }
    return [];
  }
}

final searchNotifierProvider = Provider((ref) => SearchNotifier(ref));
