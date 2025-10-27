import '../../../domain/entities/class/add_student_to_class_entity.dart';

/// Model dùng để parse JSON từ API
class AddStudentToClassModel {
  final int addedCount;
  final int failedCount;
  final List<ReasonFailedModel>? failed;

  const AddStudentToClassModel({
    required this.addedCount,
    required this.failedCount,
    this.failed,
  });

  /// Tạo từ JSON
  factory AddStudentToClassModel.fromJson(Map<String, dynamic> json) {
    return AddStudentToClassModel(
      addedCount: json['addedCount'] as int? ?? 0,
      failedCount: json['failedCount'] as int? ?? 0,
      failed: (json['failed'] as List<dynamic>?)
          ?.map((e) => ReasonFailedModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Chuyển sang Entity
  AddStudentToClassEntity toEntity() {
    return AddStudentToClassEntity(
      addedCount: addedCount,
      failedCount: failedCount,
      failed: failed?.map((e) => e.toEntity()).toList(),
    );
  }
}

/// Model ReasonFailed từ API
class ReasonFailedModel {
  final String studentId;
  final String reason;

  const ReasonFailedModel({required this.studentId, required this.reason});

  factory ReasonFailedModel.fromJson(Map<String, dynamic> json) {
    return ReasonFailedModel(
      studentId: json['studentId'] as String,
      reason: json['reason'] as String,
    );
  }

  ReasonFailed toEntity() {
    return ReasonFailed(studentId: studentId, reason: reason);
  }
}
