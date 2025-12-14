import 'package:equatable/equatable.dart';

/// Base event cho ClassBloc
abstract class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object?> get props => [];
}

/// Event để load danh sách lớp theo trường
class LoadClassesBySchool extends ClassEvent {
  final String schoolId;
  final String? grade;

  const LoadClassesBySchool({
    required this.schoolId,
    this.grade,
  });

  @override
  List<Object?> get props => [schoolId, grade];
}