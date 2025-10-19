import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

abstract class AttendanceDetailEvent extends Equatable {
  const AttendanceDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadAttendanceDetailEvent extends AttendanceDetailEvent {
  final String attendanceId;
  const LoadAttendanceDetailEvent(this.attendanceId);

  @override
  List<Object?> get props => [attendanceId];
}

class RefreshAttendanceDetailEvent extends AttendanceDetailEvent {
  final String attendanceId;
  const RefreshAttendanceDetailEvent(this.attendanceId);

  @override
  List<Object?> get props => [attendanceId];
}

class UpdateStudentStatus extends AttendanceDetailEvent {
  final String recordId;
  final AttendanceStatusEnum status;
  final String note;

  const UpdateStudentStatus({
    required this.recordId,
    required this.status,
    required this.note,
  });

  @override
  List<Object?> get props => [recordId, status, note];
}
