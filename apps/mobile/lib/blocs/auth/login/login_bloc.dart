import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
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
      emit(LoginSuccess(role: role));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
