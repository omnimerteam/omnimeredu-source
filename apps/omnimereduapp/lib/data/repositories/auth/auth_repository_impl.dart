import '../../../core/error/failures.dart';
import '../../../core/network/api_response.dart';
import '../../../core/utils/logger.dart';
import '../../datasources/local/auth_local_data_source.dart';
import '../../datasources/remote/auth/auth_jwt_remote_data_source.dart';
import '../../models/auth/auth_user_model.dart';
import '../../models/auth/registration_user_model.dart';
import '../../../domain/entities/auth/auth_user_entity.dart';
import '../../../domain/entities/auth/login_entity.dart';
import '../../../domain/entities/auth/register_user_entity.dart';
import '../../../domain/entities/user/base_user_entity.dart';
import '../../../domain/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthJwtRemoteDataSource remote;
  final AuthLocalDataSource local;
  AuthUserModel? _currentUser;

  AuthRepositoryImpl({required this.remote, required this.local});

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

      final tokens = await remote.register(requestModel);
      await local.saveTokens(tokens);
      _currentUser = tokens.user;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<AuthUserEntity> login({required LoginEntity loginInfo}) async {
    try {
      final tokens = await remote.login(loginInfo.email, loginInfo.password);

      await local.saveTokens(tokens);
      _currentUser = tokens.user;

      if (_currentUser == null) {
        throw ServerFailure(
          "Đăng nhập thành công nhưng không có thông tin user",
        );
      }

      return _currentUser!.toEntity();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      final tokens = await local.getTokens();
      if (tokens != null) {
        // Gọi API logout nếu cần (để invalidate token trên server)
        try {
          await remote.logout(tokens.accessToken);
        } catch (e) {
          logger.w("Logout remote failed (ignored): $e");
        }
      }
      await local.clearTokens();
      _currentUser = null;
    } catch (e) {
      throw ServerFailure("Đăng xuất thất bại: ${e.toString()}");
    }
  }

  @override
  Future<AuthUserEntity?> getCurrentUser() async {
    try {
      // 1. Cache memory
      if (_currentUser != null) {
        return _currentUser!.toEntity();
      }

      // 2. Cache disk
      final storedUser = await local.getUser();
      final tokens = await local.getTokens();

      if (tokens == null || storedUser == null) {
        return null;
      }

      _currentUser = storedUser;

      // Optional: Verify token / refresh / fetch fresh profile
      // TODO: Implement token verification logic here if needed

      return storedUser.toEntity();
    } catch (e) {
      logger.e("getCurrentUser error: $e");
      return null;
    }
  }

  @override
  Future<ApiResponse<void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final tokens = await local.getTokens();
      if (tokens == null) {
        throw ServerFailure("Bạn chưa đăng nhập");
      }

      await remote.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        accessToken: tokens.accessToken,
      );

      return ApiResponse.success(null, message: "Đổi mật khẩu thành công");
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  @override
  Future<ApiResponse<BaseUserEntity>> getUserProfileById(String userId) async {
    try {
      final tokens = await local.getTokens();
      if (tokens == null) {
        throw ServerFailure("Bạn chưa đăng nhập");
      }

      final res = await remote.getUserById(
        userId: userId,
        accessToken: tokens.accessToken,
      );

      return ApiResponse(
        success: res.success,
        message: res.message,
        data: res.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
