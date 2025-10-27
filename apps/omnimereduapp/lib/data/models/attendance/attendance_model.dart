import '../../../core/constants/app_constant.dart';
import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/attendance/attendance_entity.dart';

/// 🔹 AttendanceModel - mapping JSON <-> Entity
class AttendanceModel {
  final String? id;
  final String? classId;
  final String? schoolId;
  final DateTime? date;
  final AttendanceSessionTypeEnum? sessionType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AttendanceModel({
    required this.id,
    required this.classId,
    required this.schoolId,
    this.date,
    this.sessionType,
    this.createdAt,
    this.updatedAt,
  });

  /// Tạo model từ JSON (MongoDB trả về)
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['_id'] as String,
      classId: json['classId'] as String,
      schoolId: json['schoolId'] as String,
      date: (json['date'] as String?) != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['date'] as String)!,
            )
          : null,
      sessionType: AttendanceSessionTypeEnum.fromString(
        json['sessionType'] as String?,
      ),
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

  /// Convert model -> JSON (gửi API)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'classId': classId,
      'schoolId': schoolId,
      'date': date?.toUtc().toIso8601String(),
      'sessionType': sessionType?.name,
    };
  }

  /// Convert từ Entity (dùng trong Repository mapping)
  factory AttendanceModel.fromEntity(AttendanceEntity entity) {
    return AttendanceModel(
      id: entity.id,
      classId: entity.classId,
      schoolId: entity.schoolId,
      date: entity.date,
      sessionType: entity.sessionType,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  AttendanceEntity toEntity() {
    return AttendanceEntity(
      id: id,
      classId: classId,
      schoolId: schoolId,
      date: date,
      sessionType: sessionType,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
