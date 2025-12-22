import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/entities/auth/login_entity.dart';
import '../../../../../presentation/common/blocs/auth_bloc/auth_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authenticationBloc;
  StreamSubscription<AuthState>? _authSubscription;

  LoginBloc({required this.authenticationBloc}) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<ClearLoginErrorEvent>((event, emit) {
      emit(state.copyWith(error: null, clearError: true));
    });
    on<_AuthStateChanged>(_onAuthStateChanged);

    // Listen to AuthBloc state changes
    _authSubscription = authenticationBloc.stream.listen((authState) {
      add(_AuthStateChanged(authState));
    });
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null, clearError: true));

    final loginInfo = LoginEntity(
      email: event.email,
      password: event.password,
      rememberMe: event.rememberMe,
    );

    // Delegate login to AuthBloc - it will handle the actual login
    authenticationBloc.add(AuthLoginRequested(loginInfo));
  }

  Future<void> _onAuthStateChanged(
    _AuthStateChanged event,
    Emitter<LoginState> emit,
  ) async {
    final authState = event.authState;

    if (authState is AuthAuthenticated) {
      // Login successful
      emit(
        state.copyWith(
          loading: false,
          isLogin: true,
          error: null,
          clearError: true,
        ),
      );
    } else if (authState is AuthFailure) {
      // Login failed
      emit(
        state.copyWith(
          loading: false,
          error: authState.message,
          isLogin: false,
        ),
      );
    } else if (authState is AuthLoading) {
      // Keep loading state
      emit(state.copyWith(loading: true));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}

// Private event for internal state sync
class _AuthStateChanged extends LoginEvent {
  final AuthState authState;

  _AuthStateChanged(this.authState);

  @override
  List<Object?> get props => [authState];
}
