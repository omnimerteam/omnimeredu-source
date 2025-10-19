import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/attendance/attendance_class_entity.dart';

class AttendanceClassModel {
  final String id;
  final ClassAttendanceModel classId;
  final String schoolId;
  final DateTime date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AttendanceClassModel({
    required this.id,
    required this.classId,
    required this.schoolId,
    required this.date,
    this.createdAt,
    this.updatedAt,
  });

  /// ✅ Parse từ JSON trả về từ API
  factory AttendanceClassModel.fromJson(Map<String, dynamic> json) {
    return AttendanceClassModel(
      id: json['_id'] ?? '',
      classId: ClassAttendanceModel.fromJson(json['classId']),
      schoolId: json['schoolId'] ?? '',
      date: AppConstants.toVietnamTime(
        DateTime.tryParse(json['date'] as String),
      )!,
      createdAt: (json['createdAt'] as String?) != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['createdAt'] as String)!,
            )
          : null,
      updatedAt: (json['updatedAt'] as String?) != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['updatedAt'] as String)!,
            )
          : null,
    );
  }

  /// ✅ Chuyển về JSON (nếu cần gửi lên API)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'classId': classId.toJson(),
      'schoolId': schoolId,
      'date': date.toUtc().toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toUtc().toIso8601String(),
    };
  }

  /// ✅ Convert sang Entity ở tầng domain
  AttendanceClassEntity toEntity() {
    return AttendanceClassEntity(
      id: id,
      classId: classId.toEntity(),
      schoolId: schoolId,
      date: date,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class ClassAttendanceModel {
  final String id;
  final String name;
  final String code;

  ClassAttendanceModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ClassAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'code': code};
  }

  ClassAttendanceEntity toEntity() {
    return ClassAttendanceEntity(id: id, name: name, code: code);
  }
}
