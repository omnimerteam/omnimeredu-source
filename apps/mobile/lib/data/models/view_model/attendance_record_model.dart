import '../../../core/constants/app_constant.dart';
import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/attendance/attendance_record_view_entity.dart';

class AttendanceRecordViewModel {
  final String id;
  final String classId;
  final String schoolId;
  final AttendanceClassInfoModel classInfo;
  final AttendanceSchoolInfoModel schoolInfo;
  final DateTime date;
  final List<StudentAttendanceModel>? students;

  AttendanceRecordViewModel({
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
      id: json['_id'] ?? '',
      classId: json['classId'] ?? '',
      schoolId: json['schoolId'] ?? '',
      classInfo: AttendanceClassInfoModel.fromJson(json['classInfo']),
      schoolInfo: AttendanceSchoolInfoModel.fromJson(json['schoolInfo']),
      date:
          AppConstants.toVietnamTime(DateTime.tryParse(json['date'])) ??
          DateTime.now(),
      students: (json['students'] as List?)
          ?.map((e) => StudentAttendanceModel.fromJson(e))
          .toList(),
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
      students: students?.map((e) => e.toEntity()).toList(),
    );
  }
}

class AttendanceClassInfoModel {
  final String id;
  final String name;
  final String code;

  AttendanceClassInfoModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory AttendanceClassInfoModel.fromJson(Map<String, dynamic> json) {
    return AttendanceClassInfoModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  AttendanceClassInfoEntity toEntity() {
    return AttendanceClassInfoEntity(id: id, name: name, code: code);
  }
}

class AttendanceSchoolInfoModel {
  final String id;
  final String name;
  final String code;

  AttendanceSchoolInfoModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory AttendanceSchoolInfoModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSchoolInfoModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  AttendanceSchoolInfoEntity toEntity() {
    return AttendanceSchoolInfoEntity(id: id, name: name, code: code);
  }
}

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

  StudentAttendanceModel({
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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      guardianName: json['guardianName'] ?? '',
      guardianPhone: json['guardianPhone'] ?? '',
      gender: json['gender'],
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'])
          : null,
      detailRecordId: json['detailRecordId'] ?? '',
      status: AttendanceStatusEnum.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AttendanceStatusEnum.Present,
      ),
      note: json['note'],
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
