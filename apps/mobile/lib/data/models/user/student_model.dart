import 'base_user_model.dart';
import '../../../domain/entities/user/base_user_entity.dart';
import '../../../domain/entities/user/student_entity.dart';

class StudentModel extends BaseUserModel {
  const StudentModel({
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
  }) : super(roleKey: 'Student');

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final base = BaseUserModel.fromJson(json, roleKey: 'Student');
    return StudentModel(
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
    return StudentEntity(
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
      roleKey: roleKey,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
