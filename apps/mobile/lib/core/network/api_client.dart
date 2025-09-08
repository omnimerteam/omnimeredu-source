import 'package:dio/dio.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
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
          logger.i("👉 [${options.method}] ${options.uri}");
          logger.i("Headers: ${options.headers}");
          logger.i("Query: ${options.queryParameters}");
          logger.i("Data: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.i("✅ Response[${response.statusCode}]: ${response.data}");
          return handler.next(response);
        },
        onError: (e, handler) {
          logger.e("❌ Error: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  /// GET
  Future<ApiResponse<T>> get<T>(
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
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  /// POST
  Future<ApiResponse<T>> post<T>(
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
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  /// PUT
  Future<ApiResponse<T>> put<T>(
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
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  /// DELETE
  Future<ApiResponse<T>> delete<T>(
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
      return _handleResponse<T>(response);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Xử lý response OK
  ApiResponse<T> _handleResponse<T>(Response response) {
    final data = response.data;
    return ApiResponse.success(
      data as T,
      message: data is Map && data['message'] != null ? data['message'] : null,
    );
  }

  /// Xử lý lỗi (return ApiResponse chứ không throw Exception)
  ApiResponse<T> _handleError<T>(DioException e) {
    final status = e.response?.statusCode ?? 500;

    String message;

    // Timeout
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      message = "Hệ thống quá tải";
    }
    // Lỗi mạng
    else if (e.type == DioExceptionType.connectionError) {
      message = "Không có kết nối internet";
    }
    // Backend trả lỗi
    else if (e.response != null) {
      final backendMessage = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : null;

      if (backendMessage != null && backendMessage.isNotEmpty) {
        message = backendMessage;
      } else {
        switch (status) {
          case 401:
            message = "Không có quyền truy cập";
            break;
          case 404:
            message = "Không tìm thấy thôgn tin";
            break;
          case 500:
            message = "Lỗi hệ thống";
            break;
          default:
            message = "Lỗi Trí không ngờ tới :)))";
        }
      }
    } else {
      message = "Lỗi mà Trí chưa biết";
    }

    return ApiResponse.error(message);
  }
}
