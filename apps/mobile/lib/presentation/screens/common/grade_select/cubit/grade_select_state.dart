import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_select_entity.dart';

abstract class GradeSelectState extends Equatable {
  const GradeSelectState();

  @override
  List<Object?> get props => [];
}

class GradeSelectInitial extends GradeSelectState {}

class GradeSelectLoading extends GradeSelectState {}

class GradeSelectSuccess extends GradeSelectState {
  final List<GradeSelectEntity> grades;

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
