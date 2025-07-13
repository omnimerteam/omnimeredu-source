import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// Bloc trung tâm theo dõi xác thực toàn app.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthenticationState.unknown()) {
    _userSubscription = _authRepository.user.listen(
      (user) => add(AuthenticationUserChanged(user)),
    );

    on<AuthenticationUserChanged>(_onUserChanged);
    on<AuthenticationLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onUserChanged(
    AuthenticationUserChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    final user = event.user;
    if (user != null) {
      try {
        final idToken = await user.getIdToken(true);
        final role = await _authRepository.getUserRole(idToken);
        emit(AuthenticationState.authenticated(user: user, role: role));
      } catch (_) {
        emit(AuthenticationState.authenticated(user: user, role: null));
      }
    } else {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authRepository.signOut();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
