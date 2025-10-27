import '../../../core/constants/app_constant.dart';
import '../../../core/constants/enum_constant.dart';
import 'base_user_model.dart';
import '../../../domain/entities/user/teacher_entity.dart';

/// Model đại diện cho Teacher trong tầng data (dùng để parse JSON)
class TeacherModel extends BaseUserModel {
  final TeacherQualificationEnum? qualification;
  final List<SubjectEnum>? subjects;

  const TeacherModel({
    required super.id,
    required super.fullName,
    required super.roleId,
    super.email,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
    this.qualification,
    this.subjects,
  }) : super(roleKey: 'Teacher');

  /// Parse từ JSON
  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['_id'] as String,
      fullName: json['fullName'] as String? ?? '',
      roleId: json['roleId'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      birthday: json['birthday'] != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['birthday'] as String),
            )
          : null,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
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
      qualification: json['qualification'] != null
          ? TeacherQualificationEnum.values.firstWhere(
              (e) => e.name == json['qualification'],
              orElse: () => TeacherQualificationEnum.None,
            )
          : null,
      subjects: (json['subjects'] as List?)
          ?.map(
            (e) => SubjectEnum.values.firstWhere(
              (x) => x.name == e,
              orElse: () => SubjectEnum.None,
            ),
          )
          .toList(),
    );
  }

  /// Convert sang JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'qualification': qualification?.name,
      'subjects': subjects?.map((e) => e.name).toList(),
    };
  }

  /// Convert sang Entity (domain)
  @override
  TeacherEntity toEntity() {
    return TeacherEntity(
      id: id,
      fullName: fullName,
      roleId: roleId,
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
    );
  }

  /// Convert từ Entity sang Model
  factory TeacherModel.fromEntity(TeacherEntity entity) {
    return TeacherModel(
      id: entity.id,
      fullName: entity.fullName,
      roleId: entity.roleId,
      email: entity.email,
      gender: entity.gender,
      birthday: entity.birthday,
      phone: entity.phone,
      address: entity.address,
      isVerified: entity.isVerified,
      schoolId: entity.schoolId,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      qualification: entity.qualification,
      subjects: entity.subjects,
    );
  }
}
