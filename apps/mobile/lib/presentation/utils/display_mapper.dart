class DisplayMapper {
  /// Map cho vai trò người dùng
  static const Map<String, String> roleNames = {
    'SuperAdmin': 'Quản trị viên hệ thống',
    'SchoolAdmin': 'Quản trị trường',
    'Teacher': 'Giáo viên',
    'Student': 'Học sinh',
    'Parent': 'Phụ huynh',
    'Security': 'Bảo vệ',
    'Nurse': 'Y tá',
    'CanteenStaff': 'Nhân viên căng tin',
    'Staff': 'Nhân viên',
  };

  static const Map<String, String> gender = {
    'Male': 'Nam',
    'Female': 'Nữ',
    'Other': 'Khác',
  };

  /// Map cho trạng thái Membership
  static const Map<String, String> membershipStatuses = {
    'Pending': 'Chờ duyệt',
    'Approved': 'Đã duyệt',
    'Rejected': 'Từ chối',
  };

  /// Map cho hành động Membership
  static const Map<String, String> membershipActions = {
    'Enroll': 'Nhập học/Nhận công tác',
    'Transfer': 'Chuyển lớp',
    'Assign': 'Phân công',
    'Resign': 'Nghỉ học/Thôi công tác',
  };

  /// Hàm tiện ích chung: nhận key và map sang tên hiển thị
  static String fromMapping({
    required String value,
    Map<dynamic, String>? mapping,
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

  static String genderName(String? code) {
    return fromMapping(value: code ?? '', mapping: gender);
  }

  static String membershipStatusName(String? code) {
    return fromMapping(value: code ?? '', mapping: membershipStatuses);
  }

  static String membershipActionName(String? code) {
    return fromMapping(value: code ?? '', mapping: membershipActions);
  }
}
