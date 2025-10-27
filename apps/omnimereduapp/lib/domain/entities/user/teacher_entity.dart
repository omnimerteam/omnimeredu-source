import '../../../core/constants/enum_constant.dart';
import 'base_user_entity.dart';

class TeacherEntity extends BaseUserEntity {
  final TeacherQualificationEnum? qualification;
  final List<SubjectEnum>? subjects;

  const TeacherEntity({
    super.id,
    required super.fullName,
    super.roleId,
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

  /// copyWith override
  @override
  TeacherEntity copyWith({
    String? id,
    String? fullName,
    String? roleId,
    String? email,
    String? gender,
    DateTime? birthday,
    String? phone,
    String? address,
    bool? isVerified,
    String? schoolId,
    String? avatarUrl,
    String? roleKey, // bắt buộc để match abstract
    DateTime? createdAt,
    DateTime? updatedAt,
    TeacherQualificationEnum? qualification,
    List<SubjectEnum>? subjects,
  }) {
    return TeacherEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      roleId: roleId ?? this.roleId,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isVerified: isVerified ?? this.isVerified,
      schoolId: schoolId ?? this.schoolId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      qualification: qualification ?? this.qualification,
      subjects: subjects ?? this.subjects,
      // roleKey luôn cố định 'Teacher'
    );
  }

  @override
  List<Object?> get props => [...super.props, qualification, subjects];
}
