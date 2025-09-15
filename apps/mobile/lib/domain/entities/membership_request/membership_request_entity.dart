import 'package:equatable/equatable.dart';

/// 🔹 Enum cho vai trò
enum MembershipRoleEnum { Student, Teacher, Staff, SchoolAdmin }

/// 🔹 Enum cho hành động
enum MembershipActionEnum {
  Enroll, // Nhập học / Nhận công tác
  Transfer, // Chuyển lớp
  Assign, // Phân công giảng dạy / làm việc
  Resign, // Nghỉ học / Thôi công tác
}

/// 🔹 Enum cho trạng thái
enum MembershipStatusEnum { Pending, Approved, Rejected }

/// 🔹 Entity MembershipRequest
class MembershipRequestEntity extends Equatable {
  final String id;
  final String userId;
  final String schoolId;
  final String? classId;

  final MembershipRoleEnum role;
  final MembershipActionEnum action;
  final MembershipStatusEnum status;

  final String? note;

  final DateTime createdAt;
  final DateTime updatedAt;

  const MembershipRequestEntity({
    required this.id,
    required this.userId,
    required this.schoolId,
    this.classId,
    required this.role,
    required this.action,
    required this.status,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    schoolId,
    classId,
    role,
    action,
    status,
    note,
    createdAt,
    updatedAt,
  ];
}
