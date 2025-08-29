import '../entities/base_user.dart';
import '../entities/role_specific.dart';
import '../entities/school_data.dart';

class RegisterRequestEntity {
  final String email;
  final String password;
  final String? schoolId;
  final String? classId;
  final BaseUserEntity baseUserInfo;
  final RoleSpecificEntity specificInfo;
  final SchoolDataEntity? schoolData; // optional

  RegisterRequestEntity({
    required this.email,
    required this.password,
    this.schoolId,
    this.classId,
    required this.baseUserInfo,
    required this.specificInfo,
    this.schoolData,
  });
}

abstract class AuthRepository {
  Future<void> register(RegisterRequestEntity req);
}
