class DisplayMapper {
  /// Map cho vai trò người dùng
  static const Map<String, String> roleNames = {
    'SuperAdmin': 'Quản trị viên hệ thống',
    'SchoolAdmin': 'Quản trị trường',
    'Teacher': 'Giáo viên',
    'Student': 'Học sinh',
    'Parent': 'Phụ huynh',
  };

  /// Map cho trạng thái chung (học phí, đăng ký, duyệt hồ sơ,...)
  static const Map<String, String> statusNames = {
    'pending': 'Đang chờ',
    'approved': 'Đã duyệt',
    'rejected': 'Từ chối',
    'paid': 'Đã thanh toán',
    'unpaid': 'Chưa thanh toán',
  };

  /// Map cho loại/cấp học
  static const Map<String, String> educationLevels = {
    'primary': 'Tiểu học',
    'secondary': 'Trung học',
    'kindergarten': 'Mầm non',
  };

  /// Hàm tiện ích chung: nhận key và map sang tên hiển thị
  static String fromMapping({
    required String value,
    Map<String, String>? mapping,
    String defaultValue = 'Không xác định',
  }) {
    if (value.isEmpty) return defaultValue;
    final mapToUse = mapping ?? {};
    return mapToUse[value] ?? value;
  }

  /// Lấy tên vai trò
  static String roleName(String? code) {
    return fromMapping(value: code ?? '', mapping: roleNames);
  }

  /// Lấy tên trạng thái
  static String statusName(String? code) {
    return fromMapping(value: code ?? '', mapping: statusNames);
  }

  /// Lấy tên cấp học / loại lớp
  static String educationLevelName(String? code) {
    return fromMapping(value: code ?? '', mapping: educationLevels);
  }
}
