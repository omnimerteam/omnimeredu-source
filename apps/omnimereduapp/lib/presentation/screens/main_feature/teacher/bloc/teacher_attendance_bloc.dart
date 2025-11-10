import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnimereduapp/domain/usecases/attendance/delete_attendance_usecase.dart';
import '../../../../../domain/entities/view_model/attendance_record_view_entity.dart';
import '../../../../../domain/usecases/attendance/get_class_attendance_record_view_usecase.dart';
import '../../../../../domain/entities/detail_record/detail_record_entity.dart';
import '../../../../../domain/usecases/attendance/initialize_class_attendancee_usecase.dart';
import '../../../../../domain/usecases/detail_record/update_status_detail_record_usecase.dart';
import '../../../../../domain/entities/attendance/attendance_entity.dart';
import 'teacher_attendance_event.dart';
import 'teacher_attendance_state.dart';

class TeacherAttendanceBloc
    extends Bloc<TeacherAttendanceEvent, TeacherAttendanceState> {
  final GetClassAttendanceRecordViewUseCase getAttendanceRecordUseCase;
  final UpdateStatusDetailRecordUseCase updateStatusUseCase;
  final InitializeClassAttendanceUseCase initializeClassAttendanceUseCase;
  final DeleteAttendanceUseCase deleteAttendanceUseCase;

  TeacherAttendanceBloc({
    required this.getAttendanceRecordUseCase,
    required this.updateStatusUseCase,
    required this.initializeClassAttendanceUseCase,
    required this.deleteAttendanceUseCase,
  }) : super(TeacherAttendanceState(selectedDate: DateTime.now())) {
    on<LoadAttendanceRecord>(_onLoadAttendanceRecord);
    on<RefreshAttendanceRecord>(_onRefreshAttendanceRecord);
    on<UpdateStudentStatus>(_onUpdateStudentStatus);
    on<ChangeSelectedClass>(_onChangeSelectedClass);
    on<ChangeSelectedDate>(_onChangeSelectedDate);
    on<SearchStudents>(_onSearchStudents);
    on<InitializeAttendance>(_onInitializeAttendance);
    on<DeleteAttendance>(_onDeleteAttendance);
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
    final currentRecord = state.attendanceRecord;
    if (currentRecord == null) return;

    // Tạo bản copy students list
    final students = List<StudentAttendanceEntity>.from(
      currentRecord.students ?? [],
    );

    final index = students.indexWhere(
      (s) => s.detailRecordId == event.recordId,
    );
    if (index == -1) return;

    // Backup để rollback nếu API fail
    final oldStudent = students[index];

    // 🔹 1. Optimistic update - cập nhật local ngay lập tức
    students[index] = students[index].copyWith(
      status: event.status,
      note: event.note,
    );

    emit(
      state.copyWith(
        status: AttendanceStatus.updating,
        attendanceRecord: currentRecord.copyWith(students: students),
      ),
    );

    try {
      // 🔹 2. Gọi API update
      final detailRecord = DetailRecordEntity(
        id: event.recordId,
        status: event.status,
        note: event.note,
      );

      final response = await updateStatusUseCase.call(detailRecord);

      if (response.success == true) {
        // 🔹 3a. Giữ nguyên state đã update
        emit(state.copyWith(status: AttendanceStatus.success));
      } else {
        // 🔹 3b. Rollback nếu thất bại
        students[index] = oldStudent;
        emit(
          state.copyWith(
            status: AttendanceStatus.failure,
            attendanceRecord: currentRecord.copyWith(students: students),
          ),
        );
      }
    } catch (e) {
      // 🔹 3c. Rollback khi có exception
      students[index] = oldStudent;
      emit(
        state.copyWith(
          status: AttendanceStatus.failure,
          attendanceRecord: currentRecord.copyWith(students: students),
        ),
      );
    }
  }

  void _onChangeSelectedClass(
    ChangeSelectedClass event,
    Emitter<TeacherAttendanceState> emit,
  ) {
    emit(state.copyWith(selectedClassId: event.classId));

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
      emit(
        state.copyWith(
          status: AttendanceStatus.initializeFailure,
          errorMessage: 'Đã xảy ra lỗi: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteAttendance(
    DeleteAttendance event,
    Emitter<TeacherAttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceStatus.loading));

    try {
      final response = await deleteAttendanceUseCase.call(event.attendanceId);

      if (response.success == true) {
        emit(
          state.copyWith(
            status: AttendanceStatus.success,
            attendanceRecord: null,
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AttendanceStatus.failure,
            errorMessage: response.message ?? 'Không thể xóa bảng điểm danh',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AttendanceStatus.failure,
          errorMessage: 'Đã xảy ra lỗi khi xóa: ${e.toString()}',
        ),
      );
    }
  }
}
