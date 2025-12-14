import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/entities/auth/login_entity.dart';
import '../../../../../domain/usecases/auth/login_usecase.dart';
import '../../../../../presentation/common/blocs/auth_bloc/auth_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final AuthBloc authenticationBloc;

  LoginBloc({required this.loginUseCase, required this.authenticationBloc})
    : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<ClearLoginErrorEvent>((event, emit) {
      emit(state.copyWith(error: null));
    });
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

      final user = await loginUseCase.call(loginInfo);

      // báo cho AuthBloc biết user đã login
      authenticationBloc.add(AuthLoginRequested(loginInfo));

      emit(state.copyWith(loading: false, isLogin: true, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
