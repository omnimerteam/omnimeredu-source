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
  final String? fullName;

  final String schoolId;
  final String? schoolName;
  final String? schoolCode;

  final String? classId;
  final String? className;
  final String? classCode;

  final MembershipRoleEnum role;
  final MembershipActionEnum action;
  final MembershipStatusEnum status;

  final String? note;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MembershipRequestEntity({
    required this.id,
    required this.userId,
    this.fullName,
    required this.schoolId,
    this.schoolName,
    this.schoolCode,
    this.classId,
    this.className,
    this.classCode,
    required this.role,
    required this.action,
    required this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    fullName,
    schoolId,
    schoolName,
    schoolCode,
    classId,
    className,
    classCode,
    role,
    action,
    status,
    note,
    createdAt,
    updatedAt,
  ];

  MembershipRequestEntity copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? schoolId,
    String? schoolName,
    String? schoolCode,
    String? classId,
    String? className,
    String? classCode,
    MembershipRoleEnum? role,
    MembershipActionEnum? action,
    MembershipStatusEnum? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MembershipRequestEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      schoolCode: schoolCode ?? this.schoolCode,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      classCode: classCode ?? this.classCode,
      role: role ?? this.role,
      action: action ?? this.action,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
