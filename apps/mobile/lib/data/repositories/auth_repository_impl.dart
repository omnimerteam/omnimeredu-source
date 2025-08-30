import 'package:flutter_ios_android_platforms/domain/entities/user_entity.dart';

import '../../domain/repositories/auth_repository.dart';
import '../models/base_user_model.dart';
import '../models/role_specific_model.dart';
import '../models/school_data_model.dart';
import '../datasources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  UserEntity? _currentUser;

  AuthRepositoryImpl(this.remote);

  @override
  Future<void> register(RegisterRequestEntity req) async {
    final baseUser = BaseUserModel.fromEntity(req.baseUserInfo);
    final specific = RoleSpecificModel.fromEntity(req.specificInfo);
    final school = req.schoolData != null
        ? SchoolDataModel.fromEntity(req.schoolData!)
        : null;

    await remote.register(
      email: req.email,
      password: req.password,
      schoolId: req.schoolId,
      classId: req.classId,
      baseUserInfo: baseUser,
      specificInfo: specific,
      schoolData: school,
    );
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final user = await remote.login(email, password);
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  UserEntity? getCurrentUser() => _currentUser;
}
