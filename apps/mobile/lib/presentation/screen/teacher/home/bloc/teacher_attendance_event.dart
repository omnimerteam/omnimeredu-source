import 'package:equatable/equatable.dart';
import '../../../../../core/constants/enum_constant.dart';

abstract class TeacherAttendanceEvent extends Equatable {
  const TeacherAttendanceEvent();

  @override
  List<Object?> get props => [];
}

class ChangeSelectedClass extends TeacherAttendanceEvent {
  final String? classId;

  const ChangeSelectedClass(this.classId);

  @override
  List<Object?> get props => [classId];
}

class ChangeSelectedDate extends TeacherAttendanceEvent {
  final DateTime date;

  const ChangeSelectedDate(this.date);

  @override
  List<Object?> get props => [date];
}

class SearchStudents extends TeacherAttendanceEvent {
  final String query;

  const SearchStudents(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshAttendanceRecord extends TeacherAttendanceEvent {
  final DateTime date;
  final String classId;

  const RefreshAttendanceRecord({required this.date, required this.classId});

  @override
  List<Object?> get props => [date, classId];
}

class InitializeAttendance extends TeacherAttendanceEvent {
  final String classId;
  final String schoolId;
  final DateTime date;

  const InitializeAttendance({
    required this.classId,
    required this.schoolId,
    required this.date,
  });

  @override
  List<Object?> get props => [classId, schoolId, date];
}

class DeleteAttendance extends TeacherAttendanceEvent {
  final String attendanceId;

  const DeleteAttendance(this.attendanceId);

  @override
  List<Object?> get props => [attendanceId];
}

class UpdateStudentStatus extends TeacherAttendanceEvent {
  final String recordId;
  final AttendanceStatusEnum status;
  final String? note;

  const UpdateStudentStatus({
    required this.recordId,
    required this.status,
    this.note,
  });

  @override
  List<Object?> get props => [recordId, status, note];
}

class LoadClasses extends TeacherAttendanceEvent {
  final String schoolId;

  const LoadClasses(this.schoolId);

  @override
  List<Object?> get props => [schoolId];
}
