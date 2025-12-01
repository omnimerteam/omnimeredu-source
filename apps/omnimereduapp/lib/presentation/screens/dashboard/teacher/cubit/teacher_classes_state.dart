import 'package:equatable/equatable.dart';

abstract class TeacherClassesState extends Equatable {
  const TeacherClassesState();

  @override
  List<Object?> get props => [];
}

class TeacherClassesInitial extends TeacherClassesState {}

// ========== Attendance Initialization States ==========

/// State khi đang tạo bảng điểm danh
class InitializingAttendance extends TeacherClassesState {
  final String classId;

  const InitializingAttendance(this.classId);

  @override
  List<Object?> get props => [classId];
}

/// State khi tạo bảng điểm danh thành công
class AttendanceInitialized extends TeacherClassesState {
  final String classId;
  final String message;

  const AttendanceInitialized({required this.classId, required this.message});

  @override
  List<Object?> get props => [classId, message];
}

/// State khi tạo bảng điểm danh thất bại
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

// ========== Attendance Deletion States (Optional) ==========

/// State khi đang xóa bảng điểm danh
class DeletingAttendance extends TeacherClassesState {
  final String classId;

  const DeletingAttendance(this.classId);

  @override
  List<Object?> get props => [classId];
}

/// State khi xóa bảng điểm danh thành công
class AttendanceDeleted extends TeacherClassesState {
  final String classId;
  final String message;

  const AttendanceDeleted({required this.classId, required this.message});

  @override
  List<Object?> get props => [classId, message];
}

/// State khi xóa bảng điểm danh thất bại
class AttendanceDeletionError extends TeacherClassesState {
  final String classId;
  final String message;

  const AttendanceDeletionError({required this.classId, required this.message});

  @override
  List<Object?> get props => [classId, message];
}
