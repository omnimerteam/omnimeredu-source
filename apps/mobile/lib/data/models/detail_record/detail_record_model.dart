import 'package:mobile/domain/entities/detail_record/detail_record_entity.dart';

import '../../../core/constants/app_constant.dart';
import '../../../core/constants/enum_constant.dart';

/// 🔹 DetailRecordModel - mapping JSON <-> Entity
class DetailRecordModel {
  final String? id;
  final String? studentId;
  final String? attendanceId;
  final AttendanceStatusEnum? status;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DetailRecordModel({
    required this.id,
    required this.studentId,
    required this.attendanceId,
    required this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  /// Tạo model từ JSON (MongoDB trả về)
  factory DetailRecordModel.fromJson(Map<String, dynamic> json) {
    return DetailRecordModel(
      id: json['id'] as String?,
      studentId: json['studentId'] as String?,
      attendanceId: json['attendanceId'] as String?,
      status: AttendanceStatusEnum.fromString(json['status'] as String?),
      note: json['note'] as String?,
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
      'id': id,
      'studentId': studentId,
      'attendanceId': attendanceId,
      'status': status?.name,
      'note': note,
      'createdAt': createdAt?.toUtc().toIso8601String(),
      'updatedAt': updatedAt?.toUtc().toIso8601String(),
    };
  }

  /// Convert từ Entity (dùng trong Repository mapping)
  factory DetailRecordModel.fromEntity(DetailRecordEntity entity) {
    return DetailRecordModel(
      id: entity.id,
      studentId: entity.studentId,
      attendanceId: entity.attendanceId,
      status: entity.status,
      note: entity.note,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  DetailRecordEntity toEntity() {
    return DetailRecordEntity(
      id: id,
      studentId: studentId,
      attendanceId: attendanceId,
      status: status,
      note: note,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
