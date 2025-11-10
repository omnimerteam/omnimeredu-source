import '../../../core/constants/app_constant.dart';
import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/membership_request/membership_request_entity.dart';

/// 🔹 Data Model cho MembershipRequest
/// Trách nhiệm: ánh xạ JSON ↔ Entity
class MembershipRequestModel {
  final String? id;
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

  const MembershipRequestModel({
    this.id,
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

  /// 🔹 Parse từ JSON (backend → app)
  factory MembershipRequestModel.fromJson(Map<String, dynamic> json) {
    final user = json['userId'] as Map<String, dynamic>?;
    final school = json['schoolId'] as Map<String, dynamic>?;
    final clazz = json['classId'] as Map<String, dynamic>?;

    return MembershipRequestModel(
      id: json['_id'] as String? ?? '',
      userId: user?['_id'] as String? ?? '',
      fullName: user?['fullName'] as String?,
      schoolId: school?['_id'] as String? ?? '',
      schoolName: school?['name'] as String?,
      schoolCode: school?['code'] as String?,
      classId: clazz?['_id'] as String?,
      className: clazz?['name'] as String?,
      classCode: clazz?['code'] as String?,
      role: MembershipRoleEnum.fromString(json['role'] as String?),
      action: MembershipActionEnum.fromString(json['action'] as String?),
      status: MembershipStatusEnum.fromString(json['status'] as String?),
      note: json['note'] as String?,
      createdAt: (json['createdAt'] as String?) != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['createdAt'] as String)!,
            )
          : null,
      updatedAt: (json['updatedAt'] as String?) != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['updatedAt'] as String)!,
            )
          : null,
    );
  }

  /// 🔹 Convert Model → JSON (app → backend)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'schoolId': schoolId,
      'classId': classId,
      'role': role.name,
      'action': action.name,
      'status': status.name,
      'note': note,
    };
  }

  /// 🔹 Convert Model → Entity (Data → Domain)
  MembershipRequestEntity toEntity() {
    return MembershipRequestEntity(
      id: id,
      userId: userId,
      fullName: fullName,
      schoolId: schoolId,
      schoolName: schoolName,
      schoolCode: schoolCode,
      classId: classId,
      className: className,
      classCode: classCode,
      role: role,
      action: action,
      status: status,
      note: note,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// 🔹 Convert Entity → Model (Domain → Data)
  factory MembershipRequestModel.fromEntity(MembershipRequestEntity entity) {
    return MembershipRequestModel(
      id: entity.id,
      userId: entity.userId,
      fullName: entity.fullName,
      schoolId: entity.schoolId,
      schoolName: entity.schoolName,
      schoolCode: entity.schoolCode,
      classId: entity.classId,
      className: entity.className,
      classCode: entity.classCode,
      role: entity.role,
      action: entity.action,
      status: entity.status,
      note: entity.note,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
