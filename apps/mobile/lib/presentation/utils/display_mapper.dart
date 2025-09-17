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

  /// 🔹 Danh sách môn học (key = English code, value = tên tiếng Việt)
  static const Map<String, String> subjects = {
    'Math': 'Toán',
    'Literature': 'Ngữ văn',
    'English': 'Tiếng Anh',
    'Physics': 'Vật lý',
    'Chemistry': 'Hóa học',
    'Biology': 'Sinh học',
    'History': 'Lịch sử',
    'Geography': 'Địa lý',
    'CivicEducation': 'Giáo dục công dân',
    'Informatics': 'Tin học',
    'Technology': 'Công nghệ',
    'PE': 'Thể dục',
    'Art': 'Mỹ thuật',
    'Music': 'Âm nhạc',
    'NationalDefense': 'Giáo dục quốc phòng - an ninh',
    'ExperientialActivities': 'Hoạt động trải nghiệm',
    'AdvancedInformatics': 'Tin học (Lập trình nâng cao)',
    'OtherForeignLanguage': 'Ngoại ngữ khác',
  };

  static const Map<String, String> gender = {
    'Male': 'Nam',
    'Female': 'Nữ',
    'Other': 'Khác',
  };

  static const Map<String, String> teacherQualifications = {
    'DuoiTHSP': 'Dưới trung học sư phạm',
    'TH9_3': 'THCS + 3 năm học nghề',
    'TH12_2': 'THPT + 2 năm học nghề',
    'TrungCap': 'Trung cấp',
    'TrungCapSuPham': 'Trung cấp sư phạm',
    'TrungCap_BDNVSP': 'Trung cấp + BDNVSP',
    'CaoDang': 'Cao đẳng',
    'CaoDangSuPham': 'Cao đẳng sư phạm',
    'DaiHoc': 'Đại học',
    'DaiHocSuPham': 'Đại học sư phạm',
    'ThacSi': 'Thạc sĩ',
    'TienSi': 'Tiến sĩ',
    'PGS': 'Phó Giáo sư',
    'GS': 'Giáo sư',
    'BacSiDaKhoa': 'Bác sĩ đa khoa',
    'BacSiChuyenKhoa1': 'Bác sĩ chuyên khoa 1',
    'BacSiChuyenKhoa2': 'Bác sĩ chuyên khoa 2',
    'ChuaQuaDaoTaoSP': 'Chưa qua đào tạo sư phạm',
    'CoChungChiNghe': 'Có chứng chỉ nghề',
    'TrinhDoKhac': 'Trình độ khác',
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

  static String teacherQualificationName(String? code) {
    return fromMapping(value: code ?? '', mapping: teacherQualifications);
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
