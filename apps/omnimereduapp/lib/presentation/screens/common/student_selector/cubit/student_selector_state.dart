import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/user/student_selector_entity.dart';

abstract class StudentSelectorState extends Equatable {
  const StudentSelectorState();

  @override
  List<Object?> get props => [];
}

class StudentSelectorInitial extends StudentSelectorState {}

class StudentSelectorLoading extends StudentSelectorState {}

class StudentSelectorSuccess extends StudentSelectorState {
  final List<StudentSelectorEntity> students;

  const StudentSelectorSuccess(this.students);

  @override
  List<Object?> get props => [students];
}

class StudentSelectorError extends StudentSelectorState {
  final String message;

  const StudentSelectorError(this.message);

  @override
  List<Object?> get props => [message];
}
