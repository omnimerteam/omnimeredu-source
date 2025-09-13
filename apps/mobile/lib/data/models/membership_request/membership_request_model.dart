import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';

/// 🔹 Model cho MembershipRequest
class MembershipRequestModel extends MembershipRequestEntity {
  const MembershipRequestModel({
    required String id,
    required String userId,
    required String schoolId,
    String? classId,
    required MembershipRoleEnum role,
    required MembershipActionEnum action,
    required MembershipStatusEnum status,
    String? note,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
         id: id,
         userId: userId,
         schoolId: schoolId,
         classId: classId,
         role: role,
         action: action,
         status: status,
         note: note,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// 🔹 Parse từ JSON (backend → app)
  factory MembershipRequestModel.fromJson(Map<String, dynamic> json) {
    return MembershipRequestModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      schoolId: json['schoolId'] as String,
      classId: json['classId'] as String?,
      role: _roleFromString(json['role'] as String),
      action: _actionFromString(json['action'] as String),
      status: _statusFromString(json['status'] as String),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// 🔹 Convert sang JSON (app → backend)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'schoolId': schoolId,
      'classId': classId,
      'role': role.name, // enum -> string
      'action': action.name,
      'status': status.name,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 🔹 Convert sang Entity (Model → Domain)
  MembershipRequestEntity toEntity() {
    return MembershipRequestEntity(
      id: id,
      userId: userId,
      schoolId: schoolId,
      classId: classId,
      role: role,
      action: action,
      status: status,
      note: note,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// 🔹 Parse từ Entity (Domain → Model)
  factory MembershipRequestModel.fromEntity(MembershipRequestEntity entity) {
    return MembershipRequestModel(
      id: entity.id,
      userId: entity.userId,
      schoolId: entity.schoolId,
      classId: entity.classId,
      role: entity.role,
      action: entity.action,
      status: entity.status,
      note: entity.note,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// --- Helpers: convert String -> Enum ---
  static MembershipRoleEnum _roleFromString(String role) {
    return MembershipRoleEnum.values.firstWhere(
      (e) => e.name == role,
      orElse: () => MembershipRoleEnum.Student,
    );
  }

  static MembershipActionEnum _actionFromString(String action) {
    return MembershipActionEnum.values.firstWhere(
      (e) => e.name == action,
      orElse: () => MembershipActionEnum.Enroll,
    );
  }

  static MembershipStatusEnum _statusFromString(String status) {
    return MembershipStatusEnum.values.firstWhere(
      (e) => e.name == status,
      orElse: () => MembershipStatusEnum.Pending,
    );
  }
}
