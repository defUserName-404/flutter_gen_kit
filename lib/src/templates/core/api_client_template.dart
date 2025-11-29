const String apiClientTemplate = r'''
import 'package:dio/dio.dart';

import '../../common/data/exceptions/app_exceptions.dart';
import '../logger/app_logger.dart';

class ApiClient {
  final Dio dio;
  final AppLogger logger;

  ApiClient(this.dio, this.logger) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.d('Request: ${options.method} ${options.uri}');
          logger.d('Headers: ${options.headers}');
          if (options.data != null) {
            logger.d('Data: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d('Response: ${response.statusCode} ${response.requestOptions.uri}');
          logger.d('Data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e('Error: ${e.response?.statusCode} ${e.requestOptions.uri}');
          logger.e('Error data: ${e.response?.data}');
          return handler.next(e); // Pass the error along
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> delete(String path, {dynamic data}) async {
    try {
      final response = await dio.delete(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ConnectionException('Connection timed out');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] as String? ?? 'An error occurred';
        if (statusCode == 400) {
          return BadRequestException(message);
        } else if (statusCode == 401) {
          return UnauthorizedException(message);
        } else if (statusCode == 403) {
          return ForbiddenException(message);
        } else if (statusCode == 404) {
          return NotFoundException(message);
        } else if (statusCode == 500) {
          return ServerException(message);
        }
        return ApiException(message);
      case DioExceptionType.cancel:
        return RequestCancelledException('Request cancelled');
      case DioExceptionType.unknown:
      default:
        return ConnectionException('No internet connection');
    }
  }
}
''';
