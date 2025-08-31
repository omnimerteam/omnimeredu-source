import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/login_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(const LoginState()) {
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

      emit(state.copyWith(loading: false, user: user));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
