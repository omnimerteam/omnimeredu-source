import 'package:equatable/equatable.dart';
import '../../../../core/constants/enum_constant.dart';
import 'student_detail_record_entity.dart';

class DetailRecordStudentEntity extends Equatable {
  final String? id;
  final StudentDetailRecordEntity? studentId;
  final String? attendanceId;
  final AttendanceStatusEnum? status;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DetailRecordStudentEntity({
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
