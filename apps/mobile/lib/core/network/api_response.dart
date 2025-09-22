class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  const ApiResponse({required this.success, this.data, required this.message});

  /// Parse từ JSON server trả về:
  /// server format: { success: bool, data: any, message: string, error?: any }
  factory ApiResponse.fromJson(
    Map<dynamic, dynamic> json, {
    T Function(dynamic)? fromJsonT,
  }) {
    final rawData = json['data'];
    final T? parsedData = (fromJsonT != null && rawData != null)
        ? fromJsonT(rawData)
        : (rawData as T?);
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: parsedData,
      message: (json['message'] ?? '').toString(),
    );
  }

  /// Response lỗi (client tạo ra)
  factory ApiResponse.error(String message) =>
      ApiResponse<T>(success: false, data: null, message: message);

  /// Response thành công (client tạo ra)
  factory ApiResponse.success(T? data, {String message = "Thành công"}) =>
      ApiResponse<T>(success: true, data: data, message: message);
}
