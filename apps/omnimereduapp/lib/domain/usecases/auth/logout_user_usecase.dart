import '../../repositories/auth/auth_repository.dart';

class LogoutUserUseCase {
  final AuthRepository repository;

  LogoutUserUseCase(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}
