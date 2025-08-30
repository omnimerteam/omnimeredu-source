import '../repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repo;
  RegisterUserUseCase(this.repo);
  Future<void> call(RegisterRequestEntity req) => repo.register(req);
}
