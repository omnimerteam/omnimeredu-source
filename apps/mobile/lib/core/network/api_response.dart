/// Wrapper chuẩn cho mọi response trong app
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;

  ApiResponse({required this.success, this.data, required this.message});

  /// Parse từ JSON (từ server trả về)
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? fromJsonT,
  }) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'],
      message: json['message'] ?? json['error'] ?? '',
    );
  }

  /// Response lỗi (client tạo ra)
  factory ApiResponse.error(String message) {
    return ApiResponse<T>(success: false, message: message, data: null);
  }

  /// Response thành công (client tạo ra)
  factory ApiResponse.success(T data, {String message = "Thành công"}) {
    return ApiResponse<T>(success: true, data: data, message: message);
  }
}
