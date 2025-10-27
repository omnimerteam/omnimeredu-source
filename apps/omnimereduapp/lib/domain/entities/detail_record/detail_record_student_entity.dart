import 'package:equatable/equatable.dart';
import '../../../core/constants/enum_constant.dart';
import '../view_model/attendance_record_view_entity.dart';

/// 🔹 DetailRecordEntity - Đại diện dữ liệu chi tiết điểm danh ở tầng domain
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

  StudentAttendanceEntity toStudentAttendanceEntity() {
    return StudentAttendanceEntity(
      id: studentId?.id ?? '',
      name: studentId?.name ?? '',
      phone: studentId?.phone,
      guardianName: studentId?.guardianName ?? '',
      guardianPhone: studentId?.guardianPhone ?? '',
      gender: studentId?.gender,
      birthday: null, // vì DetailRecord không có trường này
      detailRecordId: id ?? '',
      status: status ?? AttendanceStatusEnum.Present, // fallback default
      note: note,
    );
  }
}

class StudentDetailRecordEntity extends Equatable {
  final String id;
  final String name;
  final String gender;
  final String? phone;
  final String guardianName;
  final String guardianPhone;

  const StudentDetailRecordEntity({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    required this.guardianName,
    required this.guardianPhone,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    gender,
    phone,
    guardianName,
    guardianPhone,
  ];
}
