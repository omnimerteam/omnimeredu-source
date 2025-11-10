import '../../../core/constants/app_constant.dart';
import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/user/personnel_entity.dart';

class PersonnelModel {
  final String? id;
  final String fullName;
  final String? roleId;
  final String roleKey;
  final String roleName;
  final String? email;
  final String? gender;
  final DateTime? birthday;
  final String? phone;
  final String? address;
  final bool isVerified;
  final String? schoolId;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // SchoolAdmin
  final SchoolAdminPositionEnum? position;
  // Teacher
  final TeacherQualificationEnum? qualification;
  final List<SubjectEnum>? subjects;

  const PersonnelModel({
    this.id,
    required this.fullName,
    this.roleId,
    required this.roleKey,
    required this.roleName,
    this.email,
    this.gender,
    this.birthday,
    this.phone,
    this.address,
    this.isVerified = false,
    this.schoolId,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
    this.qualification,
    this.subjects,
    this.position,
  });

  /// --- Factory: parse từ JSON (API -> Model)
  factory PersonnelModel.fromJson(Map<String, dynamic> json) {
    return PersonnelModel(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String,
      roleId: json['roleId']['_id'] as String,
      roleKey: json['roleKey'] as String,
      roleName: json['roleId']['name'] as String,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'])
          : null,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      isVerified: json['isVerified'] ?? false,
      schoolId: json['schoolId'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
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
      qualification: TeacherQualificationEnum.fromString(
        json['qualification'] as String?,
      ),
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((e) => SubjectEnum.fromString(e as String?))
          .toList(),
      position: SchoolAdminPositionEnum.fromString(json['position'] as String?),
    );
  }

  /// --- Convert sang Entity (Model -> Domain)
  PersonnelEntity toEntity() {
    return PersonnelEntity(
      id: id,
      fullName: fullName,
      roleId: roleId,
      roleKey: roleKey,
      roleName: roleName,
      email: email,
      gender: gender,
      birthday: birthday,
      phone: phone,
      address: address,
      isVerified: isVerified,
      schoolId: schoolId,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      qualification: qualification,
      subjects: subjects,
      position: position,
    );
  }
}
