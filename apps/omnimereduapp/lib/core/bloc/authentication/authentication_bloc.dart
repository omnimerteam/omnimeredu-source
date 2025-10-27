import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/logger.dart';
import '../../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../../domain/usecases/auth/logout_user_usecase.dart';
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
    on<UpdateUserAvatarEvent>(_onAvatarUpdate);
    on<UpdateUserProfileEvent>(_onProfileUpdated);
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

  void _onAvatarUpdate(
    UpdateUserAvatarEvent event,
    Emitter<AuthenticationState> emit,
  ) {
    if (state is AuthenticationAuthenticated) {
      final currentUser = (state as AuthenticationAuthenticated).user;
      emit(
        AuthenticationAuthenticated(
          currentUser.copyWith(avatarUrl: event.avatarUrl),
        ),
      );
    }
  }

  void _onProfileUpdated(
    UpdateUserProfileEvent event,
    Emitter<AuthenticationState> emit,
  ) {
    if (state is! AuthenticationAuthenticated) return;

    final currentUser = (state as AuthenticationAuthenticated).user;
    final updated = event.updatedUser;

    // Hàm nội bộ giúp chỉ cập nhật field nào có dữ liệu
    T? pick<T>(T? newValue, T? oldValue) => newValue ?? oldValue;

    final updatedUser = currentUser.copyWith(
      fullName: pick(updated.fullName, currentUser.fullName),
      avatarUrl: pick(updated.avatarUrl, currentUser.avatarUrl),
      position: pick(updated.position, currentUser.position),
      qualification: pick(updated.qualification, currentUser.qualification),
      educationLevel: pick(updated.educationLevel, currentUser.educationLevel),
      gradeGroup: pick(updated.gradeGroup, currentUser.gradeGroup),
    );

    emit(AuthenticationAuthenticated(updatedUser));

    logger.i(
      "🔁 Hồ sơ người dùng (${updated.roleName}) được cập nhật an toàn trong AuthenticationBloc: ${updatedUser.fullName}",
    );
  }
}
