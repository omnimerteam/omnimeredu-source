import 'package:equatable/equatable.dart';

/// Base event cho ClassSelectorBloc
abstract class ClassSelectorEvent extends Equatable {
  const ClassSelectorEvent();

  @override
  List<Object?> get props => [];
}

/// Event để load danh sách lớp theo schoolId
class LoadClassesBySchool extends ClassSelectorEvent {
  final String schoolId;

  const LoadClassesBySchool(this.schoolId);

  @override
  List<Object?> get props => [schoolId];
}

/// Event để load danh sách lớp theo teacherId
class LoadClassesByTeacher extends ClassSelectorEvent {
  final String teacherId;

  const LoadClassesByTeacher(this.teacherId);

  @override
  List<Object?> get props => [teacherId];
}
