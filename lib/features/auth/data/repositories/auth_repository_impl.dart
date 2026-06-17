import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.authService,
    required this.tokenStorage,
  });

  @override
  Future<Result<({UserEntity user, AuthTokens tokens})>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final result = await authService.login(email: email, password: password);
      final tokens = AuthTokens(
        accessToken: result.tokens['access_token'] as String,
        refreshToken: result.tokens['refresh_token'] as String,
      );
      await tokenStorage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
        rememberMe: rememberMe,
      );
      return Success((user: result.user.toEntity(), tokens: tokens));
    } on AppException catch (e) {
      return Error(e.message);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<UserEntity>> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String niche,
    required String country,
  }) async {
    try {
      final user = await authService.register({
        'full_name': fullName,
        'username': username,
        'email': email,
        'password': password,
        'niche': niche,
        'country': country,
      });
      return Success(user.toEntity());
    } on AppException catch (e) {
      return Error(e.message);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await authService.logout();
      await tokenStorage.clear();
      return const Success(null);
    } on AppException catch (e) {
      await tokenStorage.clear();
      return Error(e.message);
    }
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    try {
      final user = await authService.getCurrentUser();
      return Success(user.toEntity());
    } on AppException catch (e) {
      return Error(e.message);
    }
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      await authService.forgotPassword(email);
      return const Success(null);
    } on AppException catch (e) {
      return Error(e.message);
    }
  }

  @override
  Future<Result<void>> verifyEmail(String token) async {
    try {
      await authService.verifyEmail(token);
      return const Success(null);
    } on AppException catch (e) {
      return Error(e.message);
    }
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    final token = await tokenStorage.getAccessToken();
    return Success(token != null && token.isNotEmpty);
  }
}

/// Development-only mock repository. Swap for [AuthRepositoryImpl] when backend is ready.
class MockAuthRepository implements AuthRepository {
  UserEntity? _currentUser;
  final Map<String, UserEntity> _users = {};

  MockAuthRepository() {
    _seedDemoUser();
  }

  void _seedDemoUser() {
    final demo = UserEntity(
      id: 'user_1',
      fullName: 'Alex Johnson',
      username: '@alexj',
      email: 'alex@example.com',
      bio: 'Content Creator | Tech Enthusiast',
      profileImage:
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?w=150',
      niche: 'Technology',
      country: 'United States',
      platforms: const ['YouTube', 'Instagram'],
      level: CreatorLevel.fromCreditsEarned(805),
      followers: 12500,
      following: 890,
      credits: 485,
      creditsSpent: 320,
      creditsEarned: 805,
      tasksCompleted: 47,
      tasksCreated: 12,
      reputationScore: AppConfig.initialReputationScore,
      isVerified: true,
      isReviewer: true,
      createdAt: DateTime(2024, 1, 15),
    );
    _users['alex@example.com'] = demo;
    _currentUser = demo;

    _users['sarah@example.com'] = UserEntity(
      id: 'user_2',
      fullName: 'Sarah Chen',
      username: '@sarahchen',
      email: 'sarah@example.com',
      bio: 'Tech YouTuber',
      niche: 'Technology',
      country: 'Canada',
      platforms: const ['YouTube'],
      profileImage:
          'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?w=150',
      level: CreatorLevel.fromCreditsEarned(45000),
      followers: 45000,
      isVerified: true,
      createdAt: DateTime(2023, 6, 20),
    );

    _users['mike@example.com'] = UserEntity(
      id: 'user_3',
      fullName: 'Mike Rivera',
      username: '@mikecreative',
      email: 'mike@example.com',
      bio: 'Gaming Creator',
      niche: 'Gaming',
      country: 'United States',
      platforms: const ['TikTok', 'YouTube'],
      profileImage:
          'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?w=150',
      level: CreatorLevel.platinum,
      followers: 89000,
      isVerified: true,
      createdAt: DateTime(2022, 3, 10),
    );
  }

  @override
  Future<Result<({UserEntity user, AuthTokens tokens})>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final user = _users[email.toLowerCase()];
    if (user == null) {
      return const Error('Invalid email or password');
    }
    _currentUser = user;
    return Success((
      user: user,
      tokens: const AuthTokens(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
      ),
    ));
  }

  @override
  Future<Result<UserEntity>> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String niche,
    required String country,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (_users.containsKey(email.toLowerCase())) {
      return const Error('Email already registered');
    }

    final welcomeBonus = AppConfig.welcomeBonusCredits;
    final user = UserEntity(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      username: username.startsWith('@') ? username : '@$username',
      email: email,
      niche: niche,
      country: country,
      platforms: const [],
      level: CreatorLevel.beginner,
      credits: welcomeBonus,
      creditsEarned: welcomeBonus,
      reputationScore: AppConfig.initialReputationScore,
      createdAt: DateTime.now(),
    );
    _users[email.toLowerCase()] = user;
    _currentUser = user;
    return Success(user);
  }

  @override
  Future<Result<void>> logout() async {
    _currentUser = null;
    return const Success(null);
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    if (_currentUser == null) {
      return const Error('Not authenticated');
    }
    return Success(_currentUser!);
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    return const Success(null);
  }

  @override
  Future<Result<void>> verifyEmail(String token) async {
    return const Success(null);
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    return Success(_currentUser != null);
  }

  UserEntity? get currentUserInternal => _currentUser;

  void updateCurrentUser(UserEntity user) {
    _currentUser = user;
    _users[user.email.toLowerCase()] = user;
  }

  List<UserEntity> get suggestedCreators => _users.values
      .where((u) => u.id != _currentUser?.id)
      .toList();

  UserEntity? getUserById(String id) {
    for (final user in _users.values) {
      if (user.id == id) return user;
    }
    return null;
  }
}
