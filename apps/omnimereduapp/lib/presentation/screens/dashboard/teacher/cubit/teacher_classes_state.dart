import 'package:equatable/equatable.dart';

abstract class TeacherClassesState extends Equatable {
  const TeacherClassesState();

  @override
  List<Object?> get props => [];
}

class TeacherClassesInitial extends TeacherClassesState {}

// State cho việc tạo bảng điểm danh
class InitializingAttendance extends TeacherClassesState {
  final String classId;

  const InitializingAttendance(this.classId);

  @override
  List<Object?> get props => [classId];
}

class AttendanceInitialized extends TeacherClassesState {
  final String classId;
  final String message;

  const AttendanceInitialized({required this.classId, required this.message});

  @override
  List<Object?> get props => [classId, message];
}

class AttendanceInitializationError extends TeacherClassesState {
  final String classId;
  final String message;

  const AttendanceInitializationError({
    required this.classId,
    required this.message,
  });

  @override
  List<Object?> get props => [classId, message];
}
