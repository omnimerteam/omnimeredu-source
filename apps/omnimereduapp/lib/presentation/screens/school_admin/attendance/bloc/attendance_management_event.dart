import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/query/default_query_entity.dart';

abstract class AttendanceManagementEvent extends Equatable {
  const AttendanceManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadAttendancesEvent extends AttendanceManagementEvent {
  final DefaultQueryEntity? query;
  const LoadAttendancesEvent({this.query});

  @override
  List<Object?> get props => [query];
}

class RefreshAttendancesEvent extends AttendanceManagementEvent {}

class LoadMoreAttendancesEvent extends AttendanceManagementEvent {}

class FilterAttendancesEvent extends AttendanceManagementEvent {
  final Map<String, dynamic> filter;
  const FilterAttendancesEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SortAttendancesEvent extends AttendanceManagementEvent {
  final List<Map<String, String>> sort;
  const SortAttendancesEvent(this.sort);

  @override
  List<Object?> get props => [sort];
}

class DeleteAttendanceEvent extends AttendanceManagementEvent {
  final String attendanceId;
  const DeleteAttendanceEvent(this.attendanceId);

  @override
  List<Object?> get props => [attendanceId];
}

/// 🔹 Event khởi tạo bảng điểm danh mới (theo mẫu TeacherClassesCubit)
class InitializeAttendanceEvent extends AttendanceManagementEvent {
  final String classId;
  final String schoolId;
  final DateTime date;

  const InitializeAttendanceEvent({
    required this.classId,
    required this.schoolId,
    required this.date,
  });

  @override
  List<Object?> get props => [classId, schoolId, date];
}
