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
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthApi _apiClient = AuthApi();

  /// ✅ Stream để theo dõi trạng thái đăng nhập / đăng xuất
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  /// ✅ Lấy user hiện tại nếu cần (nullable)
  User? get currentUser => _firebaseAuth.currentUser;

  /// Đăng ký tài khoản mới:
  /// - Tạo user trên Firebase
  /// - Gửi info về backend để lưu thêm metadata
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

  /// Đăng nhập và lấy role từ backend
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

    final idToken = await user.getIdToken(true);
    final role = await _apiClient.getUserRole(idToken);

    return role;
  }

  Future<String> getUserRole(String? idToken) async {
    return await _apiClient.getUserRole(idToken);
  }

  /// Đăng xuất người dùng hiện tại
  Future<void> signOut() async => await _firebaseAuth.signOut();
}
