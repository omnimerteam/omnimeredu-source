import '../../../core/network/api_response.dart';
import '../../entities/auth/auth_user_entity.dart';
import '../../entities/auth/login_entity.dart';
import '../../entities/auth/register_user_entity.dart';
import '../../entities/user/base_user_entity.dart';

abstract class AuthRepository {
  Future<void> register(RegisterUserEntity req);

  Future<AuthUserEntity> login({required LoginEntity loginInfo});

  Future<void> logout();

  Future<AuthUserEntity?> getCurrentUser();

  Future<ApiResponse<void>> changePassword(
    String oldPassword,
    String newPassword,
  );

  Future<ApiResponse<BaseUserEntity>> getUserProfileById(String userId);
}
