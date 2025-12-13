import 'base_user_model.dart';
import '../../../domain/entities/user/base_user_entity.dart';
import '../../../domain/entities/user/teacher_entity.dart';
import '../../../domain/entities/user/user_role_enum.dart';

class TeacherModel extends BaseUserModel {
  const TeacherModel({
    super.id,
    required super.fullName,
    super.roleId,
    super.email,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified,
    super.schoolId,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
  }) : super(roleKey: UserRole.Teacher);

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    final base = BaseUserModel.fromJson(json, roleKey: 'Teacher');
    return TeacherModel(
      id: base.id,
      fullName: base.fullName,
      roleId: base.roleId,
      email: base.email,
      gender: base.gender,
      birthday: base.birthday,
      phone: base.phone,
      address: base.address,
      isVerified: base.isVerified,
      schoolId: base.schoolId,
      avatarUrl: base.avatarUrl,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
    );
  }

  @override
  BaseUserEntity toEntity() {
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
    );
  }
}
