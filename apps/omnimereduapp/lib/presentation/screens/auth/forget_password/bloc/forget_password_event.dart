// forget_password_event.dart
import 'package:equatable/equatable.dart';

abstract class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SendResetEmailEvent extends ForgetPasswordEvent {
  final String email;
  const SendResetEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}
