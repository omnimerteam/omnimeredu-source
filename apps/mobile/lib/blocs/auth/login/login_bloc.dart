import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({required this.authRepository, required this.authenticationBloc})
    : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final role = await authRepository.login(
        email: event.email,
        password: event.password,
      );

      // Lấy user từ Firebase
      final user = FirebaseAuth.instance.currentUser;

      // Gửi sự kiện cho AuthenticationBloc để trigger AuthRouter
      authenticationBloc.add(AuthenticationUserChanged(user));

      emit(LoginSuccess(role: role));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
