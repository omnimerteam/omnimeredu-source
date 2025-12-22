import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'api_response.dart';
import '../utils/logger.dart';
import 'endpoints.dart';
import '../../services/token_storage_service.dart';

/// JWT API Client với tự động refresh token khi hết hạn
class JwtApiClient {
  final Dio dio;
  final TokenStorageService tokenStorage;
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  /// Callback khi refresh token thất bại (user cần re-login)
  final void Function()? onAuthError;

  JwtApiClient({required this.tokenStorage, this.onAuthError})
    : dio = Dio(
        BaseOptions(
          baseUrl: Endpoints.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        ),
      ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Gắn access token vào header (nếu có)
          final token = await tokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          logger.i("👉 [JWT] [${options.method}] ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.i("✅ [JWT] Response[${response.statusCode}]");
          return handler.next(response);
        },
        onError: (e, handler) async {
          // Nếu 401 thì thử refresh token
          if (e.response?.statusCode == 401) {
            // Nếu chưa có request nào đang refresh thì bắt đầu refresh
            if (_refreshCompleter == null || _refreshCompleter!.isCompleted) {
              _refreshCompleter = Completer<bool>();
              _tryRefreshToken().then((success) {
                _refreshCompleter?.complete(success);
              });
            }

            // Đợi kết quả refresh
            final success = await _refreshCompleter?.future ?? false;

            if (success) {
              // Retry request với token mới
              try {
                final retryResponse = await _retryRequest(e.requestOptions);
                return handler.resolve(retryResponse);
              } catch (retryError) {
                logger.e("❌ [JWT] Retry failed after refresh");
              }
            } else {
              // Refresh thất bại → gọi callback logout (chỉ gọi 1 lần)
              if (!_isRefreshing) {
                onAuthError?.call();
              }
            }
          }

          // Log error
          final status = e.response?.statusCode;
          final uri = e.requestOptions.uri;
          logger.e("❌ [JWT] ${e.requestOptions.method} $status ${uri.path}");
          return handler.next(e);
        },
      ),
    );
  }

  /// Thử refresh token
  Future<bool> _tryRefreshToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        logger.w("⚠️ [JWT] No refresh token available");
        _isRefreshing = false;
        return false;
      }

      logger.i("🔄 [JWT] Refreshing token...");

      // Dùng Dio mới để tránh interceptor loop, set explicit headers
      final response = await Dio().post(
        '${Endpoints.baseUrl}${Endpoints.jwtRefreshToken}',
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        // Handle wrapper response if needed
        final responseData = data is Map && data.containsKey('data')
            ? data['data']
            : data;

        final newAccessToken = responseData['accessToken'] as String?;
        final newRefreshToken = responseData['refreshToken'] as String?;

        if (newAccessToken != null && newRefreshToken != null) {
          await tokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
          logger.i("✅ [JWT] Token refreshed successfully");
          _isRefreshing = false;
          return true;
        } else {
          logger.e("❌ [JWT] Invalid response format: missing tokens");
        }
      } else {
        logger.e(
          "❌ [JWT] Refresh failed with status: ${response.statusCode} - ${response.data}",
        );
      }
    } catch (e) {
      logger.e("❌ [JWT] Refresh token exception: $e");
    }

    // Refresh thất bại → xóa tokens để buộc user login lại
    logger.w("⚠️ [JWT] Clearing tokens due to refresh failure");
    await tokenStorage.clearTokens();
    _isRefreshing = false;
    return false;
  }

  /// Retry request với token mới
  Future<Response> _retryRequest(RequestOptions options) async {
    final token = await tokenStorage.getAccessToken();
    options.headers['Authorization'] = 'Bearer $token';
    return dio.fetch(options);
  }

  // ==================== HTTP METHODS ====================

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

  // ==================== RESPONSE HANDLERS ====================

  ApiResponse<T> _handleResponse<T>(
    Response response, {
    T Function(dynamic)? fromJsonT,
  }) {
    final status = response.statusCode ?? 200;
    final raw = response.data;

    if (status == 204 || raw == null) {
      return ApiResponse<T>.success(null, message: "Thành công");
    }

    if (raw is Map && raw.containsKey('success')) {
      try {
        return ApiResponse<T>.fromJson(raw, fromJsonT: fromJsonT);
      } catch (e, st) {
        logger.e("_parse wrapper error: $e\n$st");
        return ApiResponse<T>.success(raw as T?, message: "Thành công");
      }
    }

    return ApiResponse<T>.success(raw as T?, message: "Thành công");
  }

  ApiResponse<T> _handleError<T>(DioException e) {
    final status = e.response?.statusCode ?? 500;
    String message = "Lỗi không xác định";

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      message = "Yêu cầu quá thời gian. Vui lòng thử lại";
    } else if (e.type == DioExceptionType.connectionError) {
      message = "Không có kết nối internet";
    } else if (e.response != null) {
      final body = e.response?.data;

      if (body is Map && body.containsKey('success')) {
        return ApiResponse<T>(
          success: body['success'] ?? false,
          message: body['message']?.toString() ?? "Có lỗi xảy ra",
          data: body['data'],
        );
      }

      if (body is Map) {
        message = body['message']?.toString() ?? _getDefaultMessage(status);
      } else {
        message = _getDefaultMessage(status);
      }
    } else {
      message = "Không thể kết nối đến server";
    }

    return ApiResponse<T>(success: false, message: message, data: null);
  }

  String _getDefaultMessage(int status) {
    switch (status) {
      case 401:
        return "Phiên đăng nhập hết hạn";
      case 403:
        return "Không có quyền truy cập";
      case 404:
        return "Không tìm thấy thông tin";
      case 500:
        return "Lỗi hệ thống";
      default:
        return "Lỗi dịch vụ ($status)";
    }
  }
}
