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
      // 1. Cache memory - nếu có thì trả về ngay
      if (_currentUser != null) {
        return _currentUser!.toEntity();
      }

      // 2. Kiểm tra tokens từ local storage
      final tokens = await local.getTokens();
      if (tokens == null) {
        return null;
      }

      // 3. Gọi API /me để lấy thông tin user mới nhất từ server
      try {
        final user = await remote.getMe(tokens.accessToken);
        _currentUser = user;

        // Lưu user mới vào local storage
        await local.saveUser(user);

        return user.toEntity();
      } catch (e) {
        final errorMessage = e.toString().toLowerCase();

        // Kiểm tra nếu token hết hạn -> thử refresh token
        if (errorMessage.contains('expired') || errorMessage.contains('401')) {
          logger.i("Access token hết hạn, đang refresh token...");

          try {
            // Refresh token
            final newTokens = await remote.refreshToken(tokens.refreshToken);
            await local.saveTokens(newTokens);

            // Retry getMe với token mới
            final user = await remote.getMe(newTokens.accessToken);
            _currentUser = user;
            await local.saveUser(user);

            logger.i("Refresh token thành công, đã lấy lại thông tin user");
            return user.toEntity();
          } catch (refreshError) {
            logger.w("Refresh token thất bại: $refreshError");
          }
        }

        logger.w("Gọi API /me thất bại, thử dùng local cache: $e");

        // Fallback: đọc từ local cache nếu API fail
        final storedUser = await local.getUser();
        if (storedUser != null) {
          _currentUser = storedUser;
          return storedUser.toEntity();
        }

        // Token hết hạn hoặc không hợp lệ -> clear và return null
        await local.clearTokens();
        return null;
      }
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
