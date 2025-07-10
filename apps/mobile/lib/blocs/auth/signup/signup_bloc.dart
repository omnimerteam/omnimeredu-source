import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/repositories/auth_repository.dart';
import '../../../blocs/auth/signup/signup_event.dart';
import '../../../blocs/auth/signup/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;

  SignupBloc({required this.authRepository}) : super(SignupInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());

    if (event.password != event.rePassword) {
      emit(SignupFailure(error: 'Passwords do not match'));
      return;
    }

    try {
      await authRepository.register(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        gender: event.gender,
        phone: event.phone,
        role: event.role,
      );
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(error: e.toString()));
    }
  }
}
