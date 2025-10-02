import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/logout_user_usecase.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUserUseCase logoutUserUseCase;

  AuthenticationBloc({
    required this.getCurrentUserUseCase,
    required this.logoutUserUseCase,
  }) : super(AuthenticationUnknown()) {
    on<AuthenticationStarted>(_onStarted);
    on<AuthenticationLoggedIn>(_onLoggedIn);
    on<AuthenticationLoggedOut>(_onLoggedOut);
    on<AuthenticationSchoolUpdated>(_onSchoolUpdated);
  }

  Future<void> _onStarted(
    AuthenticationStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());

    try {
      final currentUser = await getCurrentUserUseCase.call();
      if (currentUser != null) {
        emit(AuthenticationAuthenticated(currentUser));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationFailure("Lỗi khởi tạo: $e"));
    }
  }

  void _onLoggedIn(
    AuthenticationLoggedIn event,
    Emitter<AuthenticationState> emit,
  ) {
    logger.i("Người đăng nhập: ${event.user}");
    emit(AuthenticationAuthenticated(event.user));
  }

  Future<void> _onLoggedOut(
    AuthenticationLoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());

    try {
      await logoutUserUseCase.call();

      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthenticationFailure("Đăng xuất thất bại: $e"));
    }
  }

  void _onSchoolUpdated(
    AuthenticationSchoolUpdated event,
    Emitter<AuthenticationState> emit,
  ) {
    final currentState = state;
    if (currentState is AuthenticationAuthenticated) {
      final updatedUser = currentState.user.copyWith(
        schoolName: event.schoolName,
      );

      emit(AuthenticationAuthenticated(updatedUser));
    }
  }
}
