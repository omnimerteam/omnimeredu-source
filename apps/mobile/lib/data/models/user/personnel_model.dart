import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/base_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/staff_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/teacher_entity.dart';

class PersonnelModel extends BaseUserEntity {
  final TeacherQualificationEnum? qualification;
  final List<SubjectEnum>? subjects;

  const PersonnelModel({
    super.id,
    required super.fullName,
    super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
    required super.roleKey,
    this.qualification,
    this.subjects,
  });

  /// Parse từ JSON
  factory PersonnelModel.fromJson(Map<String, dynamic> json) {
    final roleKey = json['roleKey'] as String;

    if (roleKey == 'Teacher') {
      return PersonnelModel(
        id: json['_id'] as String,
        fullName: json['fullName'] as String,
        roleId: json['roleId'] as String,
        gender: json['gender'] as String?,
        birthday: json['birthday'] != null
            ? AppConstants.toVietnamTime(
                DateTime.tryParse(json['birthday'] as String),
              )
            : null,
        phone: json['phone'] as String?,
        address: json['address'] as String?,
        isVerified: json['isVerified'] ?? false,
        schoolId: json['schoolId'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        roleKey: roleKey,
        qualification: TeacherQualificationEnum.fromString(
          json['qualification'],
        ),
        subjects: (json['subjects'] as List<dynamic>?)
            ?.map((s) => SubjectEnum.fromString(s))
            .whereType<SubjectEnum>() // loại bỏ null
            .toList(),
        createdAt: json['createdAt'] as DateTime?,
        updatedAt: json['updatedAt'] as DateTime?,
      );
    } else {
      return PersonnelModel(
        id: json['_id'] as String,
        fullName: json['fullName'] as String,
        roleId: json['roleId'] as String,
        gender: json['gender'] as String?,
        birthday: json['birthday'] != null
            ? AppConstants.toVietnamTime(
                DateTime.tryParse(json['createdAt'] as String),
              )
            : null,
        phone: json['phone'] as String?,
        address: json['address'] as String?,
        isVerified: json['isVerified'] ?? false,
        schoolId: json['schoolId'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        roleKey: roleKey,
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
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      '_id': id,
      'fullName': fullName,
      'roleId': roleId,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'phone': phone,
      'address': address,
      'isVerified': isVerified,
      'schoolId': schoolId,
      'avatarUrl': avatarUrl,
      'roleKey': roleKey,
    };

    // Chỉ add qualification nếu không null
    if (qualification != null && qualification != "") {
      data['qualification'] = qualification!.name;
    }

    // Chỉ add subjects nếu list có giá trị
    if (subjects != null && subjects!.isNotEmpty) {
      data['subjects'] = subjects!.map((s) => s.name).toList();
    }

    return data;
  }

  /// Convert Model -> Entity
  BaseUserEntity toEntity() {
    if (roleKey == 'Teacher') {
      return TeacherEntity(
        id: id,
        fullName: fullName,
        roleId: roleId,
        gender: gender,
        birthday: birthday,
        phone: phone,
        address: address,
        isVerified: isVerified,
        schoolId: schoolId,
        avatarUrl: avatarUrl,
        qualification: qualification,
        subjects: subjects,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } else {
      return StaffEntity(
        id: id,
        fullName: fullName,
        roleId: roleId,
        gender: gender,
        birthday: birthday,
        phone: phone,
        address: address,
        isVerified: isVerified,
        schoolId: schoolId,
        avatarUrl: avatarUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }
  }

  /// Convert Entity -> Model
  factory PersonnelModel.fromEntity(BaseUserEntity entity) {
    if (entity is TeacherEntity) {
      return PersonnelModel(
        id: entity.id,
        fullName: entity.fullName,
        roleId: entity.roleId,
        gender: entity.gender,
        birthday: entity.birthday,
        phone: entity.phone,
        address: entity.address,
        isVerified: entity.isVerified,
        schoolId: entity.schoolId,
        avatarUrl: entity.avatarUrl,
        roleKey: entity.roleKey,
        qualification: entity.qualification,
        subjects: entity.subjects,
      );
    } else if (entity is StaffEntity) {
      return PersonnelModel(
        id: entity.id,
        fullName: entity.fullName,
        roleId: entity.roleId,
        gender: entity.gender,
        birthday: entity.birthday,
        phone: entity.phone,
        address: entity.address,
        isVerified: entity.isVerified,
        schoolId: entity.schoolId,
        avatarUrl: entity.avatarUrl,
        roleKey: entity.roleKey,
      );
    } else {
      throw Exception("Unsupported entity type");
    }
  }
}
