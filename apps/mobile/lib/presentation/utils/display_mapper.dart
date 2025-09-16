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

  /// Map cho loại/cấp học
  static const Map<String, String> educationLevels = {
    'Preschool': 'Mầm non',
    'Primary': 'Tiểu học',
    'Secondary': 'Trung học cơ sở',
    'HighSchool': 'Trung học phổ thông',
    'University': 'Đại học',
  };

  static const Map<String, String> subjects = {
    'Math': 'Toán',
    'Literature': 'Ngữ văn',
    'History': 'Lịch sử',
    'Geography': 'Địa lý',
    'Biology': 'Sinh học',
    'Chemistry': 'Hóa học',
    'Physics': 'Vật lý',
  };

  static const Map<String, String> gender = {
    'Male': 'Nam',
    'Female': 'Nữ',
    'Other': 'Khác',
  };

  static const Map<String, String> literacyLevels = {
    'beginner': 'Sơ cấp',
    'intermediate': 'Trung cấp',
    'advanced': 'Cao cấp',
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

  /// Lấy tên cấp học / loại lớp
  static String educationLevelName(String? code) {
    return fromMapping(value: code ?? '', mapping: educationLevels);
  }

  static String genderName(String? code) {
    return fromMapping(value: code ?? '', mapping: gender);
  }

  static String literacyLevelsName(String? code) {
    return fromMapping(value: code ?? '', mapping: literacyLevels);
  }

  static String subjectsName(String? code) {
    return fromMapping(value: code ?? '', mapping: subjects);
  }

  static String membershipStatusName(String? code) {
    return fromMapping(value: code ?? '', mapping: membershipStatuses);
  }

  static String membershipActionName(String? code) {
    return fromMapping(value: code ?? '', mapping: membershipActions);
  }
}
