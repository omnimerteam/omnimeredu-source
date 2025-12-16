import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/grade/grade_entity.dart';

abstract class GradeSelectState extends Equatable {
  const GradeSelectState();

  @override
  List<Object?> get props => [];
}

class GradeSelectInitial extends GradeSelectState {}

class GradeSelectLoading extends GradeSelectState {}

class GradeSelectSuccess extends GradeSelectState {
  final List<GradeEntity> grades;

  const GradeSelectSuccess(this.grades);

  @override
  List<Object?> get props => [grades];
}

class GradeSelectError extends GradeSelectState {
  final String message;

  const GradeSelectError(this.message);

  @override
  List<Object?> get props => [message];
}
