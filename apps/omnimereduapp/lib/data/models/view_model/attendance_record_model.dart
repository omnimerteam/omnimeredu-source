import '../../../core/constants/app_constant.dart';
import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/view_model/attendance_record_view_entity.dart';

/// 🔹 Model cho StudentAttendanceEntity
class StudentAttendanceModel {
  final String id;
  final String name;
  final String? phone;
  final String guardianName;
  final String guardianPhone;
  final String? gender;
  final DateTime? birthday;
  final String detailRecordId;
  final AttendanceStatusEnum status;
  final String? note;

  const StudentAttendanceModel({
    required this.id,
    required this.name,
    this.phone,
    required this.guardianName,
    required this.guardianPhone,
    this.gender,
    this.birthday,
    required this.detailRecordId,
    required this.status,
    this.note,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      guardianName: json['guardianName'] as String,
      guardianPhone: json['guardianPhone'] as String,
      gender: json['gender'] as String?,
      birthday: (json['birthday'] as String?) != null
          ? AppConstants.toVietnamTime(
              DateTime.parse(json['birthday'] as String),
            )
          : null,
      detailRecordId: json['detailRecordId'] as String,
      status: AttendanceStatusEnum.fromString(json['status'] as String?),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'guardianName': guardianName,
      'guardianPhone': guardianPhone,
      'gender': gender,
      'birthday': birthday?.toUtc().toIso8601String(),
      'detailRecordId': detailRecordId,
      'status': status.name,
      'note': note,
    };
  }

  factory StudentAttendanceModel.fromEntity(StudentAttendanceEntity entity) {
    return StudentAttendanceModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      guardianName: entity.guardianName,
      guardianPhone: entity.guardianPhone,
      gender: entity.gender,
      birthday: entity.birthday,
      detailRecordId: entity.detailRecordId,
      status: entity.status,
      note: entity.note,
    );
  }

  StudentAttendanceEntity toEntity() {
    return StudentAttendanceEntity(
      id: id,
      name: name,
      phone: phone,
      guardianName: guardianName,
      guardianPhone: guardianPhone,
      gender: gender,
      birthday: birthday,
      detailRecordId: detailRecordId,
      status: status,
      note: note,
    );
  }
}

/// 🔹 Model cho AttendanceClassInfoEntity
class AttendanceClassInfoModel {
  final String id;
  final String name;
  final String code;

  const AttendanceClassInfoModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory AttendanceClassInfoModel.fromJson(Map<String, dynamic> json) {
    return AttendanceClassInfoModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'code': code};

  factory AttendanceClassInfoModel.fromEntity(
    AttendanceClassInfoEntity entity,
  ) {
    return AttendanceClassInfoModel(
      id: entity.id,
      name: entity.name,
      code: entity.code,
    );
  }

  AttendanceClassInfoEntity toEntity() {
    return AttendanceClassInfoEntity(id: id, name: name, code: code);
  }
}

/// 🔹 Model cho AttendanceSchoolInfoEntity
class AttendanceSchoolInfoModel {
  final String id;
  final String name;
  final String code;

  const AttendanceSchoolInfoModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory AttendanceSchoolInfoModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSchoolInfoModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'code': code};

  factory AttendanceSchoolInfoModel.fromEntity(
    AttendanceSchoolInfoEntity entity,
  ) {
    return AttendanceSchoolInfoModel(
      id: entity.id,
      name: entity.name,
      code: entity.code,
    );
  }

  AttendanceSchoolInfoEntity toEntity() {
    return AttendanceSchoolInfoEntity(id: id, name: name, code: code);
  }
}

/// 🔹 Model chính: AttendanceRecordViewEntity
class AttendanceRecordViewModel {
  final String id;
  final String classId;
  final String schoolId;
  final AttendanceClassInfoModel classInfo;
  final AttendanceSchoolInfoModel schoolInfo;
  final DateTime date;
  final List<StudentAttendanceModel?>? students;

  const AttendanceRecordViewModel({
    required this.id,
    required this.classId,
    required this.schoolId,
    required this.classInfo,
    required this.schoolInfo,
    required this.date,
    required this.students,
  });

  factory AttendanceRecordViewModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordViewModel(
      id: json['_id'] as String,
      classId: json['classId'] as String,
      schoolId: json['schoolId'] as String,
      classInfo: AttendanceClassInfoModel.fromJson(json['class']),
      schoolInfo: AttendanceSchoolInfoModel.fromJson(json['school']),
      date: AppConstants.toVietnamTime(DateTime.parse(json['date'] as String))!,
      students:
          (json['students'] as List<dynamic>?)
              ?.where((e) => e != null) // loại bỏ null trong list
              .map(
                (e) =>
                    StudentAttendanceModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [], // nếu null thì trả list rỗng
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'classId': classId,
      'schoolId': schoolId,
      'classInfo': classInfo.toJson(),
      'schoolInfo': schoolInfo.toJson(),
      'date': date.toUtc().toIso8601String(),
      'students': students?.map((e) => e?.toJson()).toList(),
    };
  }

  factory AttendanceRecordViewModel.fromEntity(
    AttendanceRecordViewEntity entity,
  ) {
    return AttendanceRecordViewModel(
      id: entity.id,
      classId: entity.classId,
      schoolId: entity.schoolId,
      classInfo: AttendanceClassInfoModel.fromEntity(entity.classInfo),
      schoolInfo: AttendanceSchoolInfoModel.fromEntity(entity.schoolInfo),
      date: entity.date,
      students:
          entity.students
              ?.where((e) => e != null)
              .map((e) => StudentAttendanceModel.fromEntity(e!))
              .toList() ??
          [],
    );
  }

  AttendanceRecordViewEntity toEntity() {
    return AttendanceRecordViewEntity(
      id: id,
      classId: classId,
      schoolId: schoolId,
      classInfo: classInfo.toEntity(),
      schoolInfo: schoolInfo.toEntity(),
      date: date,
      students:
          students
              ?.where((e) => e != null) // loại bỏ null trước khi convert
              .map((e) => e!.toEntity())
              .toList() ??
          [],
    );
  }
}
