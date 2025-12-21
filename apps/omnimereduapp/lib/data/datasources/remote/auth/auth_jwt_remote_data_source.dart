import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../models/auth/auth_tokens_model.dart';
import '../../../models/auth/auth_user_model.dart';
import '../../../models/auth/registration_user_model.dart';
import '../../../models/user/base_user_model.dart';
import '../../../models/user/school_admin_model.dart';
import '../../../models/user/staff_mode.dart';
import '../../../models/user/student_model.dart';
import '../../../models/user/teacher_model.dart';
import '../../../../core/network/api_response.dart';

/// Remote data source cho JWT Authentication
/// Sử dụng basic ApiClient (không kèm token) cho các endpoint auth
class AuthJwtRemoteDataSource {
  final ApiClient client;

  AuthJwtRemoteDataSource(this.client);

  /// Đăng nhập bằng email/password
  /// Trả về accessToken, refreshToken và user info
  Future<AuthTokensModel> login(String email, String password) async {
    final res = await client.post(
      Endpoints.jwtLogin,
      data: {'email': email, 'password': password},
    );

    if (!res.success || res.data == null) {
      throw Exception(res.message ?? 'Đăng nhập thất bại');
    }

    return AuthTokensModel.fromApiResponse(res.data as Map<String, dynamic>);
  }

  /// Đăng ký tài khoản mới
  /// Trả về accessToken, refreshToken và user info
  Future<AuthTokensModel> register(RegisterUserModel user) async {
    final res = await client.post(Endpoints.jwtRegister, data: user.toJson());

    if (!res.success || res.data == null) {
      throw Exception(res.message ?? 'Đăng ký thất bại');
    }

    return AuthTokensModel.fromApiResponse(res.data as Map<String, dynamic>);
  }

  /// Làm mới access token bằng refresh token
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    final res = await client.post(
      Endpoints.jwtRefreshToken,
      data: {'refreshToken': refreshToken},
    );

    if (!res.success || res.data == null) {
      throw Exception(res.message ?? 'Refresh token thất bại');
    }

    return AuthTokensModel.fromApiResponse(res.data as Map<String, dynamic>);
  }

  /// Đăng xuất - xóa refresh token phía server
  Future<void> logout(String accessToken) async {
    await client.post(
      Endpoints.jwtLogout,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
  }

  /// Đổi mật khẩu (yêu cầu JWT token)
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String accessToken,
  }) async {
    final res = await client.patch(
      Endpoints.jwtChangePassword,
      headers: {'Authorization': 'Bearer $accessToken'},
      data: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );

    if (!res.success) {
      throw Exception(res.message ?? 'Đổi mật khẩu thất bại');
    }
  }

  /// Quên mật khẩu - đặt lại mật khẩu mới
  Future<void> forgetPassword({
    required String newPassword,
    required String accessToken,
  }) async {
    final res = await client.patch(
      Endpoints.jwtForgetPassword,
      headers: {'Authorization': 'Bearer $accessToken'},
      data: {'newPassword': newPassword},
    );

    if (!res.success) {
      throw Exception(res.message ?? 'Đặt lại mật khẩu thất bại');
    }
  }

  /// Lấy thông tin user hiện tại từ access token
  /// Dùng khi app reload để lấy lại dữ liệu đăng nhập
  Future<AuthUserModel> getMe(String accessToken) async {
    final res = await client.get<Map<String, dynamic>>(
      Endpoints.jwtMe,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (!res.success || res.data == null) {
      throw Exception(res.message ?? 'Lấy thông tin người dùng thất bại');
    }

    final userData = res.data!['user'] as Map<String, dynamic>?;
    if (userData == null) {
      throw Exception('Không tìm thấy thông tin người dùng');
    }

    return AuthUserModel.fromJson(userData);
  }

  /// Lấy thông tin user theo ID (dùng cho cả admin/user xem profile)
  Future<ApiResponse<BaseUserModel>> getUserById({
    required String userId,
    required String accessToken,
  }) async {
    final res = await client.get<Map<String, dynamic>>(
      Endpoints.personnelId(userId),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (res.data == null) {
      return ApiResponse.error("Không tìm thấy dữ liệu người dùng");
    }

    final json = res.data!;
    final roleKey = json['roleKey'] as String?;

    late BaseUserModel model;

    switch (roleKey) {
      case 'Student':
        model = StudentModel.fromJson(json);
        break;
      case 'Teacher':
        model = TeacherModel.fromJson(json);
        break;
      case 'SchoolAdmin':
        model = SchoolAdminModel.fromJson(json);
        break;
      case 'Staff':
        model = StaffModel.fromJson(json);
        break;
      default:
        model = BaseUserModel.fromJson(
          json,
          roleKey: (roleKey == null || roleKey.isEmpty) ? 'BaseUser' : roleKey,
        );
        break;
    }

    return ApiResponse.success(model, message: res.message ?? "Thành công");
  }
}
