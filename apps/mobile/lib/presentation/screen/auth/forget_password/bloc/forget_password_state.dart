// forget_password_state.dart
import 'package:equatable/equatable.dart';

class ForgetPasswordState extends Equatable {
  final bool loading;
  final bool success;
  final String? error;

  const ForgetPasswordState({
    this.loading = false,
    this.success = false,
    this.error,
  });

  ForgetPasswordState copyWith({bool? loading, bool? success, String? error}) {
    return ForgetPasswordState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, success, error];
}
