import 'dart:io';

import 'package:dio/dio.dart';
import 'api_response.dart';
import '../utils/logger.dart';
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
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.i("👉 [${options.method}] ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.i("✅ Response[${response.statusCode}]");
          return handler.next(response);
        },
        onError: (e, handler) {
          final status = e.response?.statusCode;
          final uri = e.requestOptions.uri;
          final method = e.requestOptions.method;
          
          // Rút gọn error message - bỏ phần giải thích dài của Dio
          String shortMessage = 'Request failed';
          if (e.type == DioExceptionType.badResponse) {
            shortMessage = 'Bad response';
          } else if (e.type == DioExceptionType.connectionTimeout) {
            shortMessage = 'Connection timeout';
          } else if (e.type == DioExceptionType.receiveTimeout) {
            shortMessage = 'Receive timeout';
          } else if (e.type == DioExceptionType.connectionError) {
            shortMessage = 'Connection error';
          } else {
            shortMessage = e.message?.split('\n').first ?? 'Request failed';
          }
          
          // Chỉ log error body nếu là JSON (không phải HTML)
          if (e.response?.data != null) {
            final errorBody = e.response!.data;
            if (errorBody is Map) {
              final errorMsg = errorBody['message'] ?? errorBody['error'] ?? 'Error';
              logger.e("❌ $method $status ${uri.path}: $errorMsg");
            } else if (errorBody is String && !errorBody.contains('<!DOCTYPE')) {
              // Chỉ log string nếu không phải HTML và ngắn
              final shortError = errorBody.length > 100 
                  ? '${errorBody.substring(0, 100)}...' 
                  : errorBody;
              logger.e("❌ $method $status ${uri.path}: $shortError");
            } else {
              // HTML error - chỉ log status và path
              logger.e("❌ $method $status ${uri.path}: ${status == 404 ? 'Not found' : shortMessage}");
            }
          } else {
            logger.e("❌ $method ${uri.path}: $shortMessage");
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Trong class ApiClient

  Future<ApiResponse<T>> uploadFile<T>(
    String path, {
    required File file,
    String fieldName = 'file',
    Map<String, dynamic>? fields,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (fields != null) ...fields,
        fieldName: await MultipartFile.fromFile(
          file.path,
          filename: file.uri.pathSegments.last,
        ),
      });

      final response = await dio.post(
        path,
        data: formData,
        options: Options(
          headers: {...?headers, 'Content-Type': 'multipart/form-data'},
        ),
      );

      return _handleResponse<T>(response, fromJsonT: parser);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  /// GET with optional parser that maps the server `data` → T
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response, fromJsonT: parser);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response, fromJsonT: parser);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response, fromJsonT: parser);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: data,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response, fromJsonT: parser);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.delete(
        path,
        queryParameters: query,
        options: Options(headers: headers),
      );
      return _handleResponse<T>(response, fromJsonT: parser);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Nếu server trả wrapper { success, data, message }, parse nó.
  ApiResponse<T> _handleResponse<T>(
    Response response, {
    T Function(dynamic)? fromJsonT,
  }) {
    final status = response.statusCode ?? 200;
    final raw = response.data;

    // ✅ Nếu 204 No Content hoặc body null → thành công nhưng không có data
    if (status == 204 || raw == null) {
      return ApiResponse<T>.success(null, message: "Thành công");
    }

    // ✅ Nếu server trả wrapper { success, data, message }
    if (raw is Map && raw.containsKey('success')) {
      try {
        return ApiResponse<T>.fromJson(raw, fromJsonT: fromJsonT);
      } catch (e, st) {
        logger.e("_parse wrapper error: $e\n$st");
        // fallback: trả toàn bộ body như data
        return ApiResponse<T>.success(raw as T?, message: "Thành công");
      }
    }

    // ✅ Server không dùng wrapper → fallback
    return ApiResponse<T>.success(raw as T?, message: "Thành công");
  }

  ApiResponse<T> _handleError<T>(DioException e) {
    final status = e.response?.statusCode ?? 500;
    String message = "Lỗi không xác định";
    dynamic data;

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      message = "Yêu cầu quá thời gian. Vui lòng thử lại";
    } else if (e.type == DioExceptionType.connectionError) {
      message = "Không có kết nối internet";
    } else if (e.response != null) {
      final body = e.response?.data;

      if (body is Map && body.containsKey('success')) {
        // ✅ Backend trả đúng format chuẩn
        return ApiResponse<T>(
          success: body['success'] ?? false,
          message: body['message']?.toString() ?? "Có lỗi xảy ra",
          data: body['data'],
        );
      }

      // fallback nếu backend không theo format chuẩn
      if (body is Map) {
        final backendMessage = body['message']?.toString();

        if (backendMessage != null && backendMessage.isNotEmpty) {
          message = backendMessage;
        } else {
          switch (status) {
            case 401:
              message = "Không có quyền truy cập";
              break;
            case 404:
              message = "Không tìm thấy thông tin";
              break;
            case 500:
              message = "Lỗi hệ thống";
              break;
            default:
              message = "Lỗi dịch vụ ($status)";
          }
        }

        // Không log lại vì đã log ở interceptor
      } else if (body is String && !body.contains('<!DOCTYPE')) {
        // Không log lại vì đã log ở interceptor
        switch (status) {
          case 401:
            message = "Không có quyền truy cập";
            break;
          case 404:
            message = "Không tìm thấy thông tin";
            break;
          case 500:
            message = "Lỗi hệ thống";
            break;
          default:
            message = "Lỗi dịch vụ ($status)";
        }
      } else {
        // HTML error hoặc body quá dài - không log chi tiết
        switch (status) {
          case 401:
            message = "Không có quyền truy cập";
            break;
          case 404:
            message = "Không tìm thấy thông tin";
            break;
          case 500:
            message = "Lỗi hệ thống";
            break;
          default:
            message = "Lỗi dịch vụ ($status)";
        }
      }
    } else {
      message = "Không thể kết nối đến server";
    }

    // ✅ Trả về ApiResponse có success=false thay vì ApiResponse.error
    return ApiResponse<T>(success: false, message: message, data: data);
  }
}
