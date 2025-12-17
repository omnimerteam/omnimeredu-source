import 'package:equatable/equatable.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/attendance/attendance_record_view_entity.dart';

enum AttendanceStatus {
  initial,
  loading,
  success,
  failure,
  initializing,
  initializeSuccess,
  initializeFailure,
  deleting,
  deleteSuccess,
  deleteFailure,
}

class AttendanceStats {
  final int present;
  final int absent;
  final int late;
  final int leave;
  final int total;

  const AttendanceStats({
    this.present = 0,
    this.absent = 0,
    this.late = 0,
    this.leave = 0,
    this.total = 0,
  });
}

class TeacherAttendanceState extends Equatable {
  final AttendanceStatus status;
  final String? errorMessage;
  final String? selectedClassId;
  final DateTime selectedDate;
  final AttendanceRecordViewEntity? attendanceRecord;
  final List<StudentAttendanceEntity> filteredStudents;
  final AttendanceStats attendanceStats;
  final String searchQuery;

  const TeacherAttendanceState({
    this.status = AttendanceStatus.initial,
    this.errorMessage,
    this.selectedClassId,
    required this.selectedDate,
    this.attendanceRecord,
    this.filteredStudents = const [],
    this.attendanceStats = const AttendanceStats(),
    this.searchQuery = '',
  });

  TeacherAttendanceState copyWith({
    AttendanceStatus? status,
    String? errorMessage,
    String? selectedClassId,
    DateTime? selectedDate,
    AttendanceRecordViewEntity? attendanceRecord,
    List<StudentAttendanceEntity>? filteredStudents,
    AttendanceStats? attendanceStats,
    String? searchQuery,
  }) {
    return TeacherAttendanceState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedClassId: selectedClassId ?? this.selectedClassId,
      selectedDate: selectedDate ?? this.selectedDate,
      attendanceRecord: attendanceRecord ?? this.attendanceRecord,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      attendanceStats: attendanceStats ?? this.attendanceStats,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    selectedClassId,
    selectedDate,
    attendanceRecord,
    filteredStudents,
    attendanceStats,
    searchQuery,
  ];
}
