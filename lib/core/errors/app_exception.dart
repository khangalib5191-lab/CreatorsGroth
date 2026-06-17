class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'AppException($statusCode): $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.statusCode, super.data});
}

class AuthException extends AppException {
  const AuthException(super.message, {super.statusCode, super.data});
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.statusCode, super.data});
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.statusCode, super.data});
}
