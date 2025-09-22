import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'base_user_entity.dart';

class TeacherEntity extends BaseUserEntity {
  final TeacherQualificationEnum? qualification;
  final List<SubjectEnum>? subjects;

  const TeacherEntity({
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
    this.qualification,
    this.subjects,
  }) : super(roleKey: 'Teacher');

  @override
  List<Object?> get props => [...super.props, qualification, subjects];
}
