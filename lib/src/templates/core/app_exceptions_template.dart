const String appExceptionsTemplate = r'''
abstract class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, [this.prefix]);

  @override
  String toString() {
    return '$prefix: $message';
  }
}

class ApiException extends AppException {
  ApiException(String message) : super(message, 'API Error');
}

class ConnectionException extends AppException {
  ConnectionException(String message) : super(message, 'Connection Error');
}

class BadRequestException extends AppException {
  BadRequestException(String message) : super(message, 'Bad Request');
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message) : super(message, 'Unauthorized');
}

class ForbiddenException extends AppException {
  ForbiddenException(String message) : super(message, 'Forbidden');
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super(message, 'Not Found');
}

class ServerException extends AppException {
  ServerException(String message) : super(message, 'Server Error');
}

class RequestCancelledException extends AppException {
  RequestCancelledException(String message) : super(message, 'Request Cancelled');
}
''';
