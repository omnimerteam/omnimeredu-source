import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/auth/auth_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/auth/auth_user_model.dart';
import 'package:flutter_ios_android_platforms/data/models/auth/registration_user_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/login_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/register_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthUserModel? _currentUser;

  AuthRepositoryImpl(this.remote);

  @override
  Future<void> register(RegisterUserEntity req) async {
    try {
      final requestModel = RegisterUserModel(
        email: req.email,
        password: req.password,
        schoolId: req.schoolId,
        classId: req.classId,
        baseUserInfo: req.baseUserInfo,
        specificInfo: req.specificInfo,
        schoolData: req.schoolData,
      );

      await remote.register(requestModel);
    } catch (e) {
      throw ServerFailure("${e.toString()}");
    }
  }

  @override
  Future<AuthUserEntity> login({required LoginEntity loginInfo}) async {
    try {
      final userModel = await remote.login(loginInfo);
      _currentUser = userModel;
      logger.i("_currentUser: ${_currentUser}");
      return userModel.toEntity();
    } catch (e) {
      throw ServerFailure("Đăng nhập thất bại: ${e.toString()}");
    }
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  AuthUserEntity? getCurrentUser() => _currentUser?.toEntity();
}
