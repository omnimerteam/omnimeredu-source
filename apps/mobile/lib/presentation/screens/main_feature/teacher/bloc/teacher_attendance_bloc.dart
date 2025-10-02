import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/attendance/get_class_attendance_record_view_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/entities/detail_record/detail_record_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/attendance/initialize_class_attendancee_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/detail_record/update_status_detail_record_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/entities/attendance/attendance_entity.dart';
import 'teacher_attendance_event.dart';
import 'teacher_attendance_state.dart';

class TeacherAttendanceBloc
    extends Bloc<TeacherAttendanceEvent, TeacherAttendanceState> {
  final GetClassAttendanceRecordViewUseCase getAttendanceRecordUseCase;
  final UpdateStatusDetailRecordUseCase updateStatusUseCase;
  final InitializeClassAttendanceUseCase initializeClassAttendanceUseCase;

  TeacherAttendanceBloc({
    required this.getAttendanceRecordUseCase,
    required this.updateStatusUseCase,
    required this.initializeClassAttendanceUseCase,
  }) : super(TeacherAttendanceState(selectedDate: DateTime.now())) {
    on<LoadAttendanceRecord>(_onLoadAttendanceRecord);
    on<RefreshAttendanceRecord>(_onRefreshAttendanceRecord);
    on<UpdateStudentStatus>(_onUpdateStudentStatus);
    on<ChangeSelectedClass>(_onChangeSelectedClass);
    on<ChangeSelectedDate>(_onChangeSelectedDate);
    on<SearchStudents>(_onSearchStudents);
    on<InitializeAttendance>(_onInitializeAttendance); // 🔹 Handler mới
  }

  Future<void> _onLoadAttendanceRecord(
    LoadAttendanceRecord event,
    Emitter<TeacherAttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceStatus.loading));

    try {
      final response = await getAttendanceRecordUseCase.call(
        event.date,
        event.classId,
      );

      logger.i("Response: ${response.data}");

      if (response.success == true && response.data != null) {
        emit(
          state.copyWith(
            status: AttendanceStatus.success,
            attendanceRecord: response.data,
            attendanceRecordSet: true,
            selectedClassId: event.classId,
            selectedDate: event.date,
          ),
        );
      } else if (response.success == true && response.data == null) {
        // 🔹 Trường hợp chưa có attendance record
        emit(
          state.copyWith(
            status: AttendanceStatus.initial,
            attendanceRecord: null,
            attendanceRecordSet: true,
            selectedClassId: event.classId,
            selectedDate: event.date,
            errorMessage: 'Chưa có bảng điểm danh cho ngày này',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AttendanceStatus.failure,
            errorMessage: response.message ?? 'Không thể tải dữ liệu điểm danh',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AttendanceStatus.failure,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRefreshAttendanceRecord(
    RefreshAttendanceRecord event,
    Emitter<TeacherAttendanceState> emit,
  ) async {
    // Không hiển thị loading khi refresh
    try {
      final response = await getAttendanceRecordUseCase.call(
        event.date,
        event.classId,
      );

      if (response.success == true && response.data != null) {
        emit(
          state.copyWith(
            status: AttendanceStatus.success,
            attendanceRecord: response.data,
          ),
        );
      }
    } catch (e) {
      // Silent fail cho refresh
    }
  }

  Future<void> _onUpdateStudentStatus(
    UpdateStudentStatus event,
    Emitter<TeacherAttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceStatus.updating));

    try {
      final detailRecord = DetailRecordEntity(
        id: event.recordId,
        status: event.status,
        note: event.note,
      );

      final response = await updateStatusUseCase.call(detailRecord);

      if (response.success == true) {
        // Reload attendance record after update
        add(
          LoadAttendanceRecord(
            date: state.selectedDate,
            classId: state.selectedClassId!,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AttendanceStatus.failure,
            errorMessage: response.message ?? 'Không thể cập nhật trạng thái',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AttendanceStatus.failure,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }

  void _onChangeSelectedClass(
    ChangeSelectedClass event,
    Emitter<TeacherAttendanceState> emit,
  ) {
    emit(state.copyWith(selectedClassId: event.classId));

    // Auto load attendance when class is selected
    add(LoadAttendanceRecord(date: state.selectedDate, classId: event.classId));
  }

  void _onChangeSelectedDate(
    ChangeSelectedDate event,
    Emitter<TeacherAttendanceState> emit,
  ) {
    emit(state.copyWith(selectedDate: event.date));

    // Auto load attendance when date is changed
    if (state.selectedClassId != null) {
      add(
        LoadAttendanceRecord(date: event.date, classId: state.selectedClassId!),
      );
    }
  }

  void _onSearchStudents(
    SearchStudents event,
    Emitter<TeacherAttendanceState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  // 🔹 Handler mới: Khởi tạo bảng điểm danh
  Future<void> _onInitializeAttendance(
    InitializeAttendance event,
    Emitter<TeacherAttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceStatus.initializing));

    try {
      final attendanceData = AttendanceEntity(
        classId: event.classId,
        schoolId: event.schoolId,
        date: event.date,
      );

      final response = await initializeClassAttendanceUseCase.call(
        attendanceData,
      );

      if (response.success == true) {
        logger.i("Initialize attendance success: ${response.data}");

        emit(state.copyWith(status: AttendanceStatus.initializeSuccess));

        // 🔹 Sau khi tạo thành công, tự động load lại dữ liệu
        add(LoadAttendanceRecord(date: event.date, classId: event.classId));
      } else {
        emit(
          state.copyWith(
            status: AttendanceStatus.initializeFailure,
            errorMessage: response.message ?? 'Không thể tạo bảng điểm danh',
          ),
        );
      }
    } catch (e) {
      logger.e('[TeacherAttendanceBloc] Error initializing attendance: $e');
      emit(
        state.copyWith(
          status: AttendanceStatus.initializeFailure,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }
}
