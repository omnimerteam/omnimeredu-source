enum EducationSystemLevelsEnum {
  Preschool("Mầm non"),
  Primary("Tiểu học"),
  Secondary("Trung học cơ sở"),
  HighSchool("Trung học phổ thông"),
  University("Đại học");

  final String displayName;
  const EducationSystemLevelsEnum(this.displayName);

  String get asString => name;

  static EducationSystemLevelsEnum fromString(String? value) {
    return EducationSystemLevelsEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EducationSystemLevelsEnum.Preschool,
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
  TrinhDoKhac("Trình độ khác");

  final String displayName;
  const TeacherQualificationEnum(this.displayName);

  String get asString => name;

  static TeacherQualificationEnum fromString(String? value) {
    return TeacherQualificationEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TeacherQualificationEnum.TrinhDoKhac,
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
  OtherForeignLanguage("Ngoại ngữ khác");

  final String displayName;
  const SubjectEnum(this.displayName);

  String get asString => name;

  static SubjectEnum fromString(String? value) {
    return SubjectEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SubjectEnum.OtherForeignLanguage,
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
  University_5("Đại học Năm 5");

  final String displayName;
  const EducationGradesEnum(this.displayName);

  static EducationGradesEnum fromString(String? value) {
    return EducationGradesEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EducationGradesEnum.Nursery,
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
    }
  }
}
