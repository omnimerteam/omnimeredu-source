import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'endpoints.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: Endpoints.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        ),
      ) {
    // Thêm interceptor để log request/response
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("👉 [${options.method}] ${options.uri}");
          print("Headers: ${options.headers}");
          print("Query: ${options.queryParameters}");
          print("Data: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ Response[${response.statusCode}]: ${response.data}");
          return handler.next(response);
        },
        onError: (e, handler) {
          print("❌ Error: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  /// GET request
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.delete(
        path,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Chuyển DioException thành ApiException
  ApiException _handleError(DioException e) {
    // Timeout
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return TimeoutException();
    }
    // Lỗi mạng
    else if (e.type == DioExceptionType.connectionError) {
      return NetworkException();
    }
    // Backend có trả response
    else if (e.response != null) {
      final status = e.response?.statusCode ?? 500;

      // Ưu tiên lấy message do backend trả về (nếu có)
      final backendMessage = e.response?.data?['message'];

      if (backendMessage != null && backendMessage.toString().isNotEmpty) {
        return ApiException(backendMessage.toString(), statusCode: status);
      }

      // Nếu backend không trả message, fallback theo status code
      switch (status) {
        case 401:
          return UnauthorizedException();
        case 404:
          return NotFoundException();
        case 500:
          return ServerException();
        default:
          return ApiException("Unexpected error", statusCode: status);
      }
    }
    // Không có response gì cả
    else {
      return ApiException("Unknown error");
    }
  }
}
