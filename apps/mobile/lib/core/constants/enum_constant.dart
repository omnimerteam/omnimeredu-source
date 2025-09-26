enum EducationSystemLevelsEnum {
  Preschool("Mầm non"),
  Primary("Tiểu học"),
  Secondary("Trung học cơ sở"),
  HighSchool("Trung học phổ thông"),
  University("Đại học"),
  None("");

  final String displayName;
  const EducationSystemLevelsEnum(this.displayName);

  String get asString => name;

  static EducationSystemLevelsEnum fromString(String? value) {
    return EducationSystemLevelsEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EducationSystemLevelsEnum.None,
    );
  }
}

enum TeacherQualificationEnum {
  DuoiTHSP("Dưới trung học sư phạm"),
  TH9_3("THCS + 3 năm học nghề"),
  TH12_2("THPT + 2 năm học nghề"),
  TrungCap("Trung cấp"),
  TrungCapSuPham("Trung cấp sư phạm"),
  TrungCap_BDNVSP("Trung cấp + BDNVSP"),
  CaoDang("Cao đẳng"),
  CaoDangSuPham("Cao đẳng sư phạm"),
  DaiHoc("Đại học"),
  DaiHocSuPham("Đại học sư phạm"),
  ThacSi("Thạc sĩ"),
  TienSi("Tiến sĩ"),
  PGS("Phó Giáo sư"),
  GS("Giáo sư"),
  BacSiDaKhoa("Bác sĩ đa khoa"),
  BacSiChuyenKhoa1("Bác sĩ chuyên khoa 1"),
  BacSiChuyenKhoa2("Bác sĩ chuyên khoa 2"),
  ChuaQuaDaoTaoSP("Chưa qua đào tạo sư phạm"),
  CoChungChiNghe("Có chứng chỉ nghề"),
  TrinhDoKhac("Trình độ khác"),
  None("Chưa đăng ký trình độ");

  final String displayName;
  const TeacherQualificationEnum(this.displayName);

  String get asString => name;

  static TeacherQualificationEnum fromString(String? value) {
    return TeacherQualificationEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TeacherQualificationEnum.None,
    );
  }
}

enum SubjectEnum {
  Math("Toán"),
  Literature("Ngữ văn"),
  English("Tiếng Anh"),
  Physics("Vật lý"),
  Chemistry("Hóa học"),
  Biology("Sinh học"),
  History("Lịch sử"),
  Geography("Địa lý"),
  CivicEducation("Giáo dục công dân"),
  Informatics("Tin học"),
  Technology("Công nghệ"),
  PE("Thể dục"),
  Art("Mỹ thuật"),
  Music("Âm nhạc"),
  NationalDefense("Giáo dục quốc phòng - an ninh"),
  ExperientialActivities("Hoạt động trải nghiệm"),
  AdvancedInformatics("Tin học (Lập trình nâng cao)"),
  OtherForeignLanguage("Ngoại ngữ khác"),
  None("Chưa đăng ký");

  final String displayName;
  const SubjectEnum(this.displayName);

  String get asString => name;

  static SubjectEnum fromString(String? value) {
    return SubjectEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SubjectEnum.None,
    );
  }
}

// 🔹 Enum cho các lớp/grade (theo hệ thống giáo dục Việt Nam)
enum EducationGradesEnum {
  // Mầm non
  Nursery("Nhà trẻ (3 tháng - 3 tuổi)"),
  Preschool_Baby("Lớp mầm (3-4 tuổi)"),
  Preschool_Middle("Lớp chồi (4-5 tuổi)"),
  Preschool_Large("Lớp lá (5-6 tuổi)"),

  // Tiểu học
  Primary_1("Lớp 1"),
  Primary_2("Lớp 2"),
  Primary_3("Lớp 3"),
  Primary_4("Lớp 4"),
  Primary_5("Lớp 5"),

  // Trung học cơ sở
  Secondary_6("Lớp 6"),
  Secondary_7("Lớp 7"),
  Secondary_8("Lớp 8"),
  Secondary_9("Lớp 9"),

  // Trung học phổ thông
  HighSchool_10("Lớp 10"),
  HighSchool_11("Lớp 11"),
  HighSchool_12("Lớp 12"),

  // Đại học
  University_1("Đại học Năm 1"),
  University_2("Đại học Năm 2"),
  University_3("Đại học Năm 3"),
  University_4("Đại học Năm 4"),
  University_5("Đại học Năm 5"),

  None("Chưa đăng ký");

  final String displayName;
  const EducationGradesEnum(this.displayName);

  static EducationGradesEnum fromString(String? value) {
    return EducationGradesEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EducationGradesEnum.None,
    );
  }
}

extension EducationGradeByLevelX on EducationSystemLevelsEnum {
  List<EducationGradesEnum> get grades {
    switch (this) {
      case EducationSystemLevelsEnum.Preschool:
        return [
          EducationGradesEnum.Nursery,
          EducationGradesEnum.Preschool_Baby,
          EducationGradesEnum.Preschool_Middle,
          EducationGradesEnum.Preschool_Large,
        ];
      case EducationSystemLevelsEnum.Primary:
        return [
          EducationGradesEnum.Primary_1,
          EducationGradesEnum.Primary_2,
          EducationGradesEnum.Primary_3,
          EducationGradesEnum.Primary_4,
          EducationGradesEnum.Primary_5,
        ];
      case EducationSystemLevelsEnum.Secondary:
        return [
          EducationGradesEnum.Secondary_6,
          EducationGradesEnum.Secondary_7,
          EducationGradesEnum.Secondary_8,
          EducationGradesEnum.Secondary_9,
        ];
      case EducationSystemLevelsEnum.HighSchool:
        return [
          EducationGradesEnum.HighSchool_10,
          EducationGradesEnum.HighSchool_11,
          EducationGradesEnum.HighSchool_12,
        ];
      case EducationSystemLevelsEnum.University:
        return [
          EducationGradesEnum.University_1,
          EducationGradesEnum.University_2,
          EducationGradesEnum.University_3,
          EducationGradesEnum.University_4,
          EducationGradesEnum.University_5,
        ];
      case EducationSystemLevelsEnum.None:
        return [EducationGradesEnum.None];
    }
  }
}

// 🔹 Chức vụ quản trị trường học
enum SchoolAdminPositionEnum {
  // Nhóm sáng lập / cổ đông
  Founder("Người sáng lập"),
  CoFounder("Đồng sáng lập"),
  Owner("Chủ sở hữu"),

  // Nhóm quản lý điều hành
  HieuTruong("Hiệu trưởng"),
  PhoHieuTruong("Phó hiệu trưởng"),
  TruongPhongDaoTao("Trưởng phòng đào tạo"),
  PhoPhongDaoTao("Phó phòng đào tạo"),
  TruongPhongHanhChinh("Trưởng phòng hành chính"),
  PhoPhongHanhChinh("Phó phòng hành chính"),
  KeToanTruong("Kế toán trưởng"),
  ThuQuy("Thủ quỹ"),
  TruongBanCNTT("Trưởng ban CNTT"),
  PhoBanCNTT("Phó ban CNTT"),

  None("Chưa được cấp chức vụ");

  final String displayName;
  const SchoolAdminPositionEnum(this.displayName);

  String get asString => name;

  static SchoolAdminPositionEnum fromString(String? value) {
    return SchoolAdminPositionEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SchoolAdminPositionEnum.None,
    );
  }
}

/// 🔹 Enum cho vai trò
enum MembershipRoleEnum {
  Student("Học sinh"),
  Teacher("Giáo viên"),
  Staff("Nhân viên"),
  SchoolAdmin("Quản trị trường"),
  None("");

  final String displayName;
  const MembershipRoleEnum(this.displayName);

  String get asString => name;

  static MembershipRoleEnum fromString(String? value) {
    return MembershipRoleEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MembershipRoleEnum.None,
    );
  }
}

/// 🔹 Enum cho hành động
enum MembershipActionEnum {
  Enroll("Nhập học / Nhận công tác"),
  Transfer("Chuyển lớp"),
  Assign("Phân công giảng dạy / làm việc"),
  Resign("Nghỉ học / Thôi công tác"),
  None("");

  final String displayName;
  const MembershipActionEnum(this.displayName);

  String get asString => name;

  static MembershipActionEnum fromString(String? value) {
    return MembershipActionEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MembershipActionEnum.None,
    );
  }
}

/// 🔹 Enum cho trạng thái
enum MembershipStatusEnum {
  Pending("Chờ duyệt"),
  Approved("Đã duyệt"),
  Rejected("Từ chối"),
  None("");

  final String displayName;
  const MembershipStatusEnum(this.displayName);

  String get asString => name;

  static MembershipStatusEnum fromString(String? value) {
    return MembershipStatusEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MembershipStatusEnum.None,
    );
  }
}
