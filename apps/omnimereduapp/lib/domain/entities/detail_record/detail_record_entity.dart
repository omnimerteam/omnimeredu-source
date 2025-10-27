import 'package:equatable/equatable.dart';
import '../../../core/constants/enum_constant.dart';

/// 🔹 DetailRecordEntity - Đại diện dữ liệu chi tiết điểm danh ở tầng domain
class DetailRecordEntity extends Equatable {
  final String? id;
  final String? studentId;
  final String? attendanceId;
  final AttendanceStatusEnum? status;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DetailRecordEntity({
    this.id,
    this.studentId,
    this.attendanceId,
    this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    attendanceId,
    status,
    note,
    createdAt,
    updatedAt,
  ];
}
