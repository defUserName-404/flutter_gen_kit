class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, [this.statusCode]);
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class AppException implements Exception {
  final String message;
  final String prefix;

  AppException(this.message, this.prefix);

  @override
  String toString() {
    return '$prefix: $message';
  }
}

class FetchDataException extends AppException {
  FetchDataException(String message) : super(message, 'Error During Communication');
}

class BadRequestException extends AppException {
  BadRequestException(String message) : super(message, 'Invalid Request');
}

class UnauthorisedException extends AppException {
  UnauthorisedException(String message) : super(message, 'Unauthorised');
}

class InvalidInputException extends AppException {
  InvalidInputException(String message) : super(message, 'Invalid Input');
}

class RequestCancelledException extends AppException {
  RequestCancelledException(String message) : super(message, 'Request Cancelled');
}
