import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/login_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Thực hiện login với LoginEntity
  Future<AuthUserEntity> call({required LoginEntity loginInfo}) {
    return repository.login(loginInfo: loginInfo);
  }
}
