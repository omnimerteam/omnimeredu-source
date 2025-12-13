import '../../../../../core/errors/failures.dart';
import '../../../../../core/typedefs.dart';
import '../../../../../domain/entities/auth/register_user_entity.dart';
import '../../../../../domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  FutureResult<void> call(RegisterUserEntity user) async {
    return await repository.registerUser(user);
  }
}