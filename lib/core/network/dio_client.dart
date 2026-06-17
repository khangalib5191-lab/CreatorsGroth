import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../errors/app_exception.dart';
import 'api_endpoints.dart';

class TokenStorage {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _rememberMeKey = 'remember_me';

  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<String?> getAccessToken() => _storage.read(key: _accessKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);
  Future<bool> getRememberMe() async =>
      (await _storage.read(key: _rememberMeKey)) == 'true';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    bool rememberMe = false,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
    await _storage.write(key: _rememberMeKey, value: rememberMe.toString());
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
    await _storage.delete(key: _rememberMeKey);
  }
}

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Dio dio;
  bool _isRefreshing = false;

  AuthInterceptor({required this.tokenStorage, required this.dio});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != ApiEndpoints.authRefresh) {
      try {
        if (!_isRefreshing) {
          _isRefreshing = true;
          final refreshToken = await tokenStorage.getRefreshToken();
          if (refreshToken == null) {
            await tokenStorage.clear();
            _isRefreshing = false;
            return handler.next(err);
          }

          final response = await dio.post(
            ApiEndpoints.authRefresh,
            data: {'refresh_token': refreshToken},
            options: Options(headers: {'Authorization': null}),
          );

          final access = response.data['access_token'] as String;
          final refresh = response.data['refresh_token'] as String? ?? refreshToken;
          await tokenStorage.saveTokens(
            accessToken: access,
            refreshToken: refresh,
            rememberMe: await tokenStorage.getRememberMe(),
          );
          _isRefreshing = false;

          final retry = await dio.fetch(err.requestOptions
            ..headers['Authorization'] = 'Bearer $access');
          return handler.resolve(retry);
        }
      } catch (_) {
        _isRefreshing = false;
        await tokenStorage.clear();
      }
    }
    handler.next(err);
  }
}

class DioClient {
  late final Dio dio;
  final TokenStorage tokenStorage;

  DioClient({required this.tokenStorage}) {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
    dio.interceptors.add(AuthInterceptor(tokenStorage: tokenStorage, dio: dio));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}

AppException mapDioException(DioException e) {
  final status = e.response?.statusCode;
  final message = e.response?.data is Map
      ? (e.response?.data['message']?.toString() ?? e.message)
      : e.message ?? 'Network error';

  if (status == 401) return AuthException(message ?? 'Unauthorized', statusCode: status);
  if (status == 422) {
    return ValidationException(message ?? 'Validation failed', statusCode: status);
  }
  if (status == 404) {
    return NotFoundException(message ?? 'Not found', statusCode: status);
  }
  return NetworkException(message ?? 'Network error', statusCode: status);
}
