import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthService {
  Future<String> signInAndGetToken(String email, String password);
  Future<void> signOut();
  User? getCurrentUser();
}

class FirebaseAuthServiceImpl implements FirebaseAuthService {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthServiceImpl({required this.firebaseAuth});

  @override
  Future<String> signInAndGetToken(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final idToken = await credential.user?.getIdToken();
    if (idToken == null) {
      throw Exception("Không lấy được idToken từ Firebase");
    }
    return idToken;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }
}
