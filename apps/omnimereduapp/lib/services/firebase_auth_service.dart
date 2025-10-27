import 'package:firebase_auth/firebase_auth.dart';
import '../core/error/firebase_auth_failure.dart';
import '../core/utils/logger.dart';

abstract class FirebaseAuthService {
  Future<String> signInAndGetToken(String email, String password);
  Future<void> signOut();
  User? getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
}

class FirebaseAuthServiceImpl implements FirebaseAuthService {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthServiceImpl({required this.firebaseAuth});

  @override
  Future<String> signInAndGetToken(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final idToken = await credential.user?.getIdToken();
      if (idToken == null) {
        throw const FirebaseAuthFailure("Không lấy được idToken từ Firebase");
      }
      return idToken;
    } on FirebaseAuthException catch (e) {
      logger.e("Firebase exception: ${e.code}");
      throw FirebaseAuthFailure.fromCode(e.code);
    } catch (_) {
      throw const FirebaseAuthFailure("Đăng nhập thất bại, vui lòng thử lại.");
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthFailure.fromCode(e.code);
    } catch (_) {
      throw const FirebaseAuthFailure("Đăng xuất thất bại.");
    }
  }

  @override
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      logger.i("📨 Email khôi phục mật khẩu đã được gửi đến $email");
    } on FirebaseAuthException catch (e) {
      logger.e("Firebase send reset email error: ${e.code}");
      throw FirebaseAuthFailure.fromCode(e.code);
    } catch (e) {
      logger.e("Unexpected error in sendPasswordResetEmail: $e");
      throw const FirebaseAuthFailure("Gửi email đặt lại mật khẩu thất bại.");
    }
  }
}
