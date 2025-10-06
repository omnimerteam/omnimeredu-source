import 'package:equatable/equatable.dart';

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
