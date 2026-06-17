import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<({UserEntity user, AuthTokens tokens})>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  Future<Result<UserEntity>> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String niche,
    required String country,
  });

  Future<Result<void>> logout();
  Future<Result<UserEntity>> getCurrentUser();
  Future<Result<void>> forgotPassword(String email);
  Future<Result<void>> verifyEmail(String token);
  Future<Result<bool>> isAuthenticated();
}
