import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/api/auth_api.dart';

/// [AuthRepository] đóng vai trò là tầng trung gian giữa Firebase Auth
/// và backend API.
///
/// Các phương thức bên trong class này chịu trách nhiệm:
/// - Quản lý xác thực Firebase (đăng ký, đăng nhập, đăng xuất).
/// - Đồng bộ dữ liệu người dùng với backend server qua [AuthApi].
///
/// Việc tách riêng logic này giúp code dễ kiểm thử và dễ mở rộng
/// (ví dụ: thay thế Firebase Auth hoặc thay đổi backend).
class AuthRepository {
  /// Instance Firebase Auth dùng để thao tác xác thực.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Client gọi các API backend liên quan đến thông tin người dùng.
  final AuthApi _apiClient = AuthApi();

  /// Đăng ký tài khoản mới.
  ///
  /// Bước 1: Tạo tài khoản trên Firebase Authentication.
  /// Bước 2: Gửi thông tin người dùng lên backend server để lưu trữ bổ sung.
  ///
  /// Các tham số bắt buộc:
  /// [email] - Địa chỉ email của người dùng.
  /// [password] - Mật khẩu đăng nhập.
  /// [fullName] - Họ tên đầy đủ.
  /// [gender] - Giới tính.
  /// [phone] - Số điện thoại.
  /// [role] - Vai trò (admin, student, teacher, ...).
  ///
  /// Nếu bất kỳ bước nào thất bại, exception sẽ được ném ra.
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String gender,
    required String phone,
    required String role,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = userCredential.user!.uid;

    await _apiClient.registerUser(
      uid: uid,
      email: email,
      fullName: fullName,
      gender: gender,
      phone: phone,
      role: role,
      password: password,
    );
  }

  /// Đăng nhập bằng email và mật khẩu.
  ///
  /// Trả về [String] là vai trò của người dùng để sử dụng cho phân quyền trong app.
  ///
  /// Nếu đăng nhập thất bại hoặc không tìm thấy role, sẽ ném ra exception.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) throw Exception('No user returned');

    final idToken = await user.getIdToken(true); // force refresh

    final role = await _apiClient.getUserRoleByUid(user.uid, idToken);
    return role;
  }

  /// Đăng xuất người dùng hiện tại khỏi Firebase Authentication.
  ///
  /// Việc đăng xuất này không ảnh hưởng đến backend server.
  /// Các state liên quan đến người dùng cần được xử lý bên ngoài
  /// (ví dụ: clear local storage, reset BLoC).
  Future<void> signOut() async => await _firebaseAuth.signOut();
}
