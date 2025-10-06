import 'package:equatable/equatable.dart';

/// Thông tin kết quả thêm học sinh vào lớp
class AddStudentToClassEntity extends Equatable {
  final int addedCount;
  final int failedCount;
  final List<ReasonFailed>? failed;

  const AddStudentToClassEntity({
    required this.addedCount,
    required this.failedCount,
    this.failed,
  });

  @override
  List<Object?> get props => [addedCount, failedCount, failed];

  /// copyWith tiện lợi
  AddStudentToClassEntity copyWith({
    int? addedCount,
    int? failedCount,
    List<ReasonFailed>? failed,
  }) {
    return AddStudentToClassEntity(
      addedCount: addedCount ?? this.addedCount,
      failedCount: failedCount ?? this.failedCount,
      failed: failed ?? this.failed,
    );
  }
}

/// Chi tiết học sinh bị thêm thất bại
class ReasonFailed extends Equatable {
  final String studentId;
  final String reason;

  const ReasonFailed({required this.studentId, required this.reason});

  @override
  List<Object?> get props => [studentId, reason];

  /// copyWith tiện lợi
  ReasonFailed copyWith({String? studentId, String? reason}) {
    return ReasonFailed(
      studentId: studentId ?? this.studentId,
      reason: reason ?? this.reason,
    );
  }
}
