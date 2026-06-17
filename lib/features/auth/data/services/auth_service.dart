import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../dto/user_dto.dart';

class AuthService {
  final DioClient client;

  AuthService(this.client);

  Future<({UserDto user, Map<String, dynamic> tokens})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.dio.post(ApiEndpoints.authLogin, data: {
        'email': email,
        'password': password,
      });
      return (
        user: UserDto.fromJson(response.data['user']),
        tokens: response.data['tokens'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<UserDto> register(Map<String, dynamic> data) async {
    try {
      final response =
          await client.dio.post(ApiEndpoints.authRegister, data: data);
      return UserDto.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await client.dio.post(ApiEndpoints.authLogout);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<UserDto> getCurrentUser() async {
    try {
      final response = await client.dio.get(ApiEndpoints.authMe);
      return UserDto.fromJson(response.data['user'] ?? response.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await client.dio.post(ApiEndpoints.authForgotPassword, data: {
        'email': email,
      });
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> verifyEmail(String token) async {
    try {
      await client.dio.post(ApiEndpoints.authVerifyEmail, data: {'token': token});
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
