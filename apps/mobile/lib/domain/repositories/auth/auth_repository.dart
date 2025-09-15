import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/login_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/register_user_entity.dart';

abstract class AuthRepository {
  Future<void> register(RegisterUserEntity req);

  Future<AuthUserEntity> login({required LoginEntity loginInfo});

  Future<void> logout();

  Future<AuthUserEntity?> getCurrentUser();
}
