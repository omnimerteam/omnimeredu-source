import 'package:flutter_ios_android_platforms/domain/entities/auth/register_user_entity.dart';

import '../repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repo;
  RegisterUserUseCase(this.repo);
  Future<void> call(RegisterUserEntity req) => repo.register(req);
}
