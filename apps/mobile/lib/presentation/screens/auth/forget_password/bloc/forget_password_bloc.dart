// forget_password_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';
import 'package:flutter_ios_android_platforms/services/firebase_auth_service.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final FirebaseAuthService firebaseAuthService;

  ForgetPasswordBloc({required this.firebaseAuthService})
    : super(const ForgetPasswordState()) {
    on<SendResetEmailEvent>(_onSendResetEmail);
  }

  Future<void> _onSendResetEmail(
    SendResetEmailEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    emit(state.copyWith(loading: true, success: false, error: null));

    try {
      await firebaseAuthService.sendPasswordResetEmail(event.email);
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
