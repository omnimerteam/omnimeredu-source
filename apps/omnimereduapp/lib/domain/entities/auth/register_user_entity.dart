import 'package:equatable/equatable.dart';
import 'base_user_entity.dart';
import '../school/school_data_entity.dart';

class RegisterUserEntity extends Equatable {
  final String email;
  final String password;
  final String? schoolId;
  final String? classId;
  final BaseUserForRegisterEntity baseUserInfo;
  final Map<String, dynamic>? specificInfo;
  final SchoolDataEntity? schoolData;

  const RegisterUserEntity({
    required this.email,
    required this.password,
    required this.baseUserInfo,
    this.classId,
    this.schoolId,
    this.specificInfo,
    this.schoolData,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    schoolId,
    classId,
    baseUserInfo,
    specificInfo,
    schoolData,
  ];
}
