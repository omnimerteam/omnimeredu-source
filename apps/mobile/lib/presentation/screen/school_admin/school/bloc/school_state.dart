import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/school/school_data_entity.dart';

abstract class SchoolState extends Equatable {
  const SchoolState();

  @override
  List<Object?> get props => [];
}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolLoaded extends SchoolState {
  final SchoolDataEntity school;

  const SchoolLoaded(this.school);

  @override
  List<Object?> get props => [school];
}

class SchoolEmpty extends SchoolState {}

class SchoolError extends SchoolState {
  final String message;

  const SchoolError(this.message);

  @override
  List<Object?> get props => [message];
}
