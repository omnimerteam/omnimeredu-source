import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/change_password_usecase.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordCubit({required this.changePasswordUseCase})
    : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());

    try {
      final response = await changePasswordUseCase(oldPassword, newPassword);

      if (response.success) {
        emit(
          ChangePasswordSuccess(
            message: response.message ?? "Cập nhật mật khẩu thành công",
          ),
        );
      } else {
        emit(ChangePasswordFailure(response.message ?? "Cập nhật thất bại"));
      }
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
    }
  }

  void resetState() {
    emit(ChangePasswordInitial());
  }
}
