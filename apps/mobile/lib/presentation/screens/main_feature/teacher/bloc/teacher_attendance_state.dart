import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/view_model/attendance_record_view_entity.dart';

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

  // Computed properties
  List<StudentAttendanceEntity> get filteredStudents {
    if (attendanceRecord?.students == null) return [];
    if (searchQuery.isEmpty) return attendanceRecord!.students;

    return attendanceRecord!.students.where((student) {
      final name = student.name.toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();
  }

  Map<String, int> get attendanceStats {
    if (attendanceRecord?.students == null) {
      return {
        'total': 0,
        'present': 0,
        'absent': 0,
        'late': 0,
        'absentWithLeave': 0,
        'leftEarly': 0,
      };
    }

    final students = attendanceRecord!.students;
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
    bool attendanceRecordSet = false, // <-- thêm cờ
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
