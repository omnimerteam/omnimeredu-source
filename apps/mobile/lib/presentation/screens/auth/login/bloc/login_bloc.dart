import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/login_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/login_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_event.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({required this.loginUseCase, required this.authenticationBloc})
    : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final loginInfo = LoginEntity(
        email: event.email,
        password: event.password,
        rememberMe: event.rememberMe,
      );

      final user = await loginUseCase.call(loginInfo: loginInfo);

      // báo cho AuthenticationBloc biết user đã login
      authenticationBloc.add(AuthenticationLoggedIn(user));

      emit(state.copyWith(loading: false, user: user, error: null));
    } catch (e) {
      logger.e("LoginBloc error emit: $e");
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
