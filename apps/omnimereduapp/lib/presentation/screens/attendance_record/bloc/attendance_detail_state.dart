import 'package:equatable/equatable.dart';
import '../../../../domain/entities/detail_record/detail_record_student_entity.dart';

abstract class AttendanceDetailState extends Equatable {
  const AttendanceDetailState();

  @override
  List<Object?> get props => [];
}

class AttendanceDetailInitial extends AttendanceDetailState {
  const AttendanceDetailInitial();
}

class AttendanceDetailLoading extends AttendanceDetailState {
  const AttendanceDetailLoading();
}

class AttendanceDetailLoaded extends AttendanceDetailState {
  final List<DetailRecordStudentEntity> records;
  final String attendanceId;

  const AttendanceDetailLoaded({
    required this.records,
    required this.attendanceId,
  });

  AttendanceDetailLoaded copyWith({
    List<DetailRecordStudentEntity>? records,
    String? attendanceId,
  }) {
    return AttendanceDetailLoaded(
      records: records ?? this.records,
      attendanceId: attendanceId ?? this.attendanceId,
    );
  }

  @override
  List<Object?> get props => [records, attendanceId];
}

class AttendanceDetailError extends AttendanceDetailState {
  final String message;
  const AttendanceDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
