import 'package:equatable/equatable.dart';

/// Kết quả chuyển lớp cho học sinh
class TransferClassForStudentEntity extends Equatable {
  final int transferred; // số học sinh chuyển thành công
  final int failedCount; // số học sinh thất bại
  final List<FailedReason>? failed; // danh sách chi tiết học sinh thất bại

  const TransferClassForStudentEntity({
    required this.transferred,
    required this.failedCount,
    this.failed,
  });

  @override
  List<Object?> get props => [transferred, failedCount, failed];

  /// copyWith tiện lợi
  TransferClassForStudentEntity copyWith({
    int? transferred,
    int? failedCount,
    List<FailedReason>? failed,
  }) {
    return TransferClassForStudentEntity(
      transferred: transferred ?? this.transferred,
      failedCount: failedCount ?? this.failedCount,
      failed: failed ?? this.failed,
    );
  }
}

/// Chi tiết học sinh chuyển lớp thất bại
class FailedReason extends Equatable {
  final String studentId;
  final String reason;

  const FailedReason({required this.studentId, required this.reason});

  @override
  List<Object?> get props => [studentId, reason];

  /// copyWith tiện lợi
  FailedReason copyWith({String? studentId, String? reason}) {
    return FailedReason(
      studentId: studentId ?? this.studentId,
      reason: reason ?? this.reason,
    );
  }
}
