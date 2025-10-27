import 'package:equatable/equatable.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/view_model/attendance_record_view_entity.dart';

enum AttendanceStatus {
  initial,
  loading,
  success,
  failure,
  updating,
  initializing,
  initializeSuccess,
  initializeFailure,
}

class TeacherAttendanceState extends Equatable {
  final AttendanceStatus status;
  final AttendanceRecordViewEntity? attendanceRecord;
  final String? selectedClassId;
  final DateTime selectedDate;
  final String searchQuery;
  final String? errorMessage;
  final List<String> availableClasses;

  const TeacherAttendanceState({
    this.status = AttendanceStatus.initial,
    this.attendanceRecord,
    this.selectedClassId,
    required this.selectedDate,
    this.searchQuery = '',
    this.errorMessage,
    this.availableClasses = const [],
  });

  /// 🔹 Lọc danh sách học sinh, bỏ qua null
  List<StudentAttendanceEntity> get filteredStudents {
    final students =
        attendanceRecord?.students
            ?.where((s) => s != null) // bỏ null
            .cast<StudentAttendanceEntity>()
            .toList() ??
        [];

    if (searchQuery.isEmpty) return students;

    return students.where((student) {
      final name = student.name.toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();
  }

  /// 🔹 Thống kê trạng thái điểm danh
  Map<String, int> get attendanceStats {
    final students =
        attendanceRecord?.students
            ?.where((s) => s != null)
            .cast<StudentAttendanceEntity>()
            .toList() ??
        [];

    return {
      'total': students.length,
      'present': students
          .where((s) => s.status == AttendanceStatusEnum.Present)
          .length,
      'absent': students
          .where((s) => s.status == AttendanceStatusEnum.Absent)
          .length,
      'late': students
          .where((s) => s.status == AttendanceStatusEnum.Late)
          .length,
      'absentWithLeave': students
          .where((s) => s.status == AttendanceStatusEnum.AbsentWithLeave)
          .length,
      'leftEarly': students
          .where((s) => s.status == AttendanceStatusEnum.LeftEarly)
          .length,
    };
  }

  TeacherAttendanceState copyWith({
    AttendanceStatus? status,
    AttendanceRecordViewEntity? attendanceRecord,
    bool attendanceRecordSet = false,
    String? selectedClassId,
    DateTime? selectedDate,
    String? searchQuery,
    String? errorMessage,
    List<String>? availableClasses,
  }) {
    return TeacherAttendanceState(
      status: status ?? this.status,
      attendanceRecord: attendanceRecordSet
          ? attendanceRecord
          : (attendanceRecord ?? this.attendanceRecord),
      selectedClassId: selectedClassId ?? this.selectedClassId,
      selectedDate: selectedDate ?? this.selectedDate,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
      availableClasses: availableClasses ?? this.availableClasses,
    );
  }

  @override
  List<Object?> get props => [
    status,
    attendanceRecord,
    selectedClassId,
    selectedDate,
    searchQuery,
    errorMessage,
    availableClasses,
  ];
}
