import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/entities/detail_record/detail_record_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/detail_record/detail_record_student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/detail_record/get_attendance_record_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/detail_record/update_status_detail_record_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/attendance_record/bloc/attendance_detail_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/attendance_record/bloc/attendance_detail_state.dart';

class AttendanceDetailBloc
    extends Bloc<AttendanceDetailEvent, AttendanceDetailState> {
  final GetAttendanceRecordByIdUseCase getAttendanceRecordByIdUseCase;
  final UpdateStatusDetailRecordUseCase updateStatusUseCase;

  AttendanceDetailBloc({
    required this.getAttendanceRecordByIdUseCase,
    required this.updateStatusUseCase,
  }) : super(const AttendanceDetailInitial()) {
    on<LoadAttendanceDetailEvent>(_onLoadAttendanceDetail);
    on<RefreshAttendanceDetailEvent>(_onRefreshAttendanceDetail);
    on<UpdateStudentStatus>(_onUpdateStudentStatus);
  }

  Future<void> _onLoadAttendanceDetail(
    LoadAttendanceDetailEvent event,
    Emitter<AttendanceDetailState> emit,
  ) async {
    emit(const AttendanceDetailLoading());
    try {
      final response = await getAttendanceRecordByIdUseCase
          .getAttendanceRecordsById(event.attendanceId);

      if (response.data != null) {
        emit(
          AttendanceDetailLoaded(
            records: response.data!,
            attendanceId: event.attendanceId,
          ),
        );
      } else {
        emit(
          AttendanceDetailError(
            response.message ?? 'Không thể tải chi tiết điểm danh',
          ),
        );
      }
    } catch (e) {
      emit(AttendanceDetailError(e.toString()));
    }
  }

  Future<void> _onRefreshAttendanceDetail(
    RefreshAttendanceDetailEvent event,
    Emitter<AttendanceDetailState> emit,
  ) async {
    if (state is AttendanceDetailLoaded) {
      try {
        final response = await getAttendanceRecordByIdUseCase
            .getAttendanceRecordsById(event.attendanceId);

        if (response.data != null) {
          emit(
            AttendanceDetailLoaded(
              records: response.data!,
              attendanceId: event.attendanceId,
            ),
          );
        } else {
          emit(
            AttendanceDetailError(
              response.message ?? 'Không thể tải chi tiết điểm danh',
            ),
          );
        }
      } catch (e) {
        emit(AttendanceDetailError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateStudentStatus(
    UpdateStudentStatus event,
    Emitter<AttendanceDetailState> emit,
  ) async {
    // Lấy state hiện tại
    final currentState = state;
    if (currentState is! AttendanceDetailLoaded) return;

    try {
      final detailRecord = DetailRecordEntity(
        id: event.recordId,
        status: event.status,
        note: event.note,
      );

      // Gọi use case để cập nhật
      final response = await updateStatusUseCase.call(detailRecord);

      if (response.success) {
        // Tạo bản sao records mới
        final updatedRecords = currentState.records.map((record) {
          if (record.id == event.recordId) {
            return DetailRecordStudentEntity(
              id: record.id,
              studentId: record.studentId,
              attendanceId: record.attendanceId,
              status: event.status,
              note: event.note,
              createdAt: record.createdAt,
              updatedAt: DateTime.now(),
            );
          }
          return record;
        }).toList();

        emit(currentState.copyWith(records: updatedRecords));
      } else {
        emit(
          AttendanceDetailError(
            response.message ?? 'Không thể cập nhật trạng thái học sinh',
          ),
        );
        // Sau lỗi, có thể emit lại state cũ để UI không bị trắng
        emit(currentState);
      }
    } catch (e) {
      emit(AttendanceDetailError(e.toString()));
      emit(currentState);
    }
  }
}
