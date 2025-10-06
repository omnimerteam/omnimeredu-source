import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/detail_record/get_attendance_record_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/attendance_record/bloc/attendance_detail_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/attendance_record/bloc/attendance_detail_state.dart';

class AttendanceDetailBloc
    extends Bloc<AttendanceDetailEvent, AttendanceDetailState> {
  final GetAttendanceRecordByIdUseCase getAttendanceRecordByIdUseCase;

  AttendanceDetailBloc({required this.getAttendanceRecordByIdUseCase})
    : super(const AttendanceDetailInitial()) {
    on<LoadAttendanceDetailEvent>(_onLoadAttendanceDetail);
    on<RefreshAttendanceDetailEvent>(_onRefreshAttendanceDetail);
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
}
