import 'package:flutter_ios_android_platforms/core/app_constants.dart';
import 'package:flutter_ios_android_platforms/data/models/membership_request/membership_request_enum_helper.dart';
import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';

/// 🔹 Model cho MembershipRequest
class MembershipRequestModel extends MembershipRequestEntity {
  const MembershipRequestModel({
    required String id,
    required String userId,
    String? fullName,
    required String schoolId,
    String? schoolName,
    String? schoolCode,
    String? classId,
    String? className,
    String? classCode,
    required MembershipRoleEnum role,
    required MembershipActionEnum action,
    required MembershipStatusEnum status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
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

  /// 🔹 Parse từ JSON (backend → app)
  factory MembershipRequestModel.fromJson(Map<String, dynamic> json) {
    final user = json['userId'] as Map<String, dynamic>?;
    final school = json['schoolId'] as Map<String, dynamic>?;
    final clazz = json['classId'] as Map<String, dynamic>?;

    return MembershipRequestModel(
      id: json['_id'] as String,
      userId: user?['_id'] as String? ?? '',
      fullName: user?['fullName'] as String?,
      schoolId: school?['_id'] as String? ?? '',
      schoolName: school?['name'] as String?,
      schoolCode: school?['code'] as String?,
      classId: clazz?['_id'] as String?, // 👈 có thể null
      className: clazz?['name'] as String?,
      classCode: clazz?['code'] as String?,
      role: roleFromString(json['role'] as String),
      action: actionFromString(json['action'] as String),
      status: statusFromString(json['status'] as String),
      note: json['note'] as String?,
      createdAt: json['createdAt'] != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['createdAt'] as String),
            )
          : null,
      updatedAt: json['updatedAt'] != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['updatedAt'] as String),
            )
          : null,
    );
  }

  /// 🔹 Convert sang JSON (app → backend)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'schoolId': schoolId,
      'classId': classId, // 👈 có thể null, backend handle
      'role': role.name,
      'action': action.name,
      'status': status.name,
      'note': note,
    };
  }

  /// 🔹 Convert sang Entity (Model → Domain)
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

  /// 🔹 Parse từ Entity (Domain → Model)
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
