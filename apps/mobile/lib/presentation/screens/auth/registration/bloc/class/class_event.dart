import 'package:equatable/equatable.dart';

/// Base event cho ClassBloc
abstract class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object?> get props => [];
}

/// Event để load danh sách lớp theo schoolId
class LoadClassesBySchool extends ClassEvent {
  final String schoolId;

  const LoadClassesBySchool(this.schoolId);

  @override
  List<Object?> get props => [schoolId];
}
