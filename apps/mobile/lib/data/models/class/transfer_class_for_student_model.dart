import 'package:flutter_ios_android_platforms/domain/entities/class/transfer_class_for_student_entity.dart';

/// Model nhận dữ liệu từ API cho việc chuyển lớp học sinh
class TransferClassForStudentModel {
  final int transferred; // số học sinh chuyển thành công
  final int failedCount; // số học sinh thất bại
  final List<FailedReasonModel>? failed; // chi tiết học sinh thất bại

  const TransferClassForStudentModel({
    required this.transferred,
    required this.failedCount,
    this.failed,
  });

  /// Tạo từ JSON
  factory TransferClassForStudentModel.fromJson(Map<String, dynamic> json) {
    return TransferClassForStudentModel(
      transferred: json['transferred'] as int? ?? 0,
      failedCount: json['failedCount'] as int? ?? 0,
      failed: (json['failed'] as List<dynamic>?)
          ?.map((e) => FailedReasonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Chuyển sang Entity để sử dụng trong domain
  TransferClassForStudentEntity toEntity() {
    return TransferClassForStudentEntity(
      transferred: transferred,
      failedCount: failedCount,
      failed: failed?.map((e) => e.toEntity()).toList(),
    );
  }
}

/// Model chi tiết học sinh chuyển lớp thất bại
class FailedReasonModel {
  final String studentId;
  final String reason;

  const FailedReasonModel({required this.studentId, required this.reason});

  factory FailedReasonModel.fromJson(Map<String, dynamic> json) {
    return FailedReasonModel(
      studentId: json['studentId'] as String,
      reason: json['reason'] as String,
    );
  }

  FailedReason toEntity() {
    return FailedReason(studentId: studentId, reason: reason);
  }
}
