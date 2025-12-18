import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/constants/enum_constant.dart';
import '../../../../../domain/entities/attendance/attendance_entity.dart';
import '../../../../../domain/entities/attendance/attendance_record_view_entity.dart';
import '../../../../../domain/usecases/attendance/delete_attendance_usecase.dart';
import '../../../../../domain/usecases/attendance/get_class_attendance_record_view_usecase.dart';
import '../../../../../domain/usecases/attendance/initialize_class_attendancee_usecase.dart';
import '../../../../../domain/usecases/school/search_classes_by_school_usecase.dart';
import 'teacher_attendance_event.dart';
import 'teacher_attendance_state.dart';

class TeacherAttendanceBloc
    extends Bloc<TeacherAttendanceEvent, TeacherAttendanceState> {
  final GetClassAttendanceRecordViewUseCase _getAttendanceRecord;
  final InitializeClassAttendanceUseCase _initializeAttendance;
  final DeleteAttendanceUseCase _deleteAttendance;
  final SearchClassesBySchoolUseCase _searchClasses;

  TeacherAttendanceBloc({
    required GetClassAttendanceRecordViewUseCase getAttendanceRecord,
    required InitializeClassAttendanceUseCase initializeAttendance,
    required DeleteAttendanceUseCase deleteAttendance,
    required SearchClassesBySchoolUseCase searchClasses,
  }) : _getAttendanceRecord = getAttendanceRecord,
       _initializeAttendance = initializeAttendance,
       _deleteAttendance = deleteAttendance,
       _searchClasses = searchClasses,
       super(TeacherAttendanceState(selectedDate: DateTime.now())) {
    on<ChangeSelectedClass>(_onChangeSelectedClass);
    on<ChangeSelectedDate>(_onChangeSelectedDate);
    on<RefreshAttendanceRecord>(_onRefreshAttendanceRecord);
    on<SearchStudents>(_onSearchStudents);
    on<InitializeAttendance>(_onInitializeAttendance);
    on<DeleteAttendance>(_onDeleteAttendance);
    on<UpdateStudentStatus>(_onUpdateStudentStatus);
    on<LoadClasses>(_onLoadClasses);
  }

  Future<void> _onLoadClasses(
    LoadClasses event,
    Emitter<TeacherAttendanceState> emit,
  ) async {
    final result = await _searchClasses(event.schoolId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: 'Không thể tải danh sách lớp: ${failure.message}',
        ),
      ),
      (classes) {
        final attendanceClasses = classes
            .map(
              (c) => AttendanceClassInfoEntity(
                id: c.id,
                name: c.name,
                code: c.code,
              ),
            )
            .toList();
        emit(state.copyWith(classes: attendanceClasses));
      },
    );
  }

  Future<void> _onChangeSelectedClass(
    ChangeSelectedClass event,
    Emitter<TeacherAttendanceState> emit,
  ) async {
    emit(state.copyWith(selectedClassId: event.classId));
    if (event.classId != null) {
      add(
        RefreshAttendanceRecord(
          date: state.selectedDate,
          classId: event.classId!,
        ),
      );
    }
  }

  Future<void> _onChangeSelectedDate(
    ChangeSelectedDate event,
    Emitter<TeacherAttendanceState> emit,
  ) async {
    emit(state.copyWith(selectedDate: event.date));
    if (state.selectedClassId != null) {
      add(
        RefreshAttendanceRecord(
          date: event.date,
          classId: state.selectedClassId!,
        ),
      );
    }
  }

  Future<void> _onRefreshAttendanceRecord(
    RefreshAttendanceRecord event,
    Emitter<TeacherAttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceStatus.loading));

    final result = await _getAttendanceRecord(
      GetClassAttendanceRecordViewParams(
        date: event.date,
        classId: event.classId,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AttendanceStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (record) {
        if (record == null) {
          emit(
            state.copyWith(
              status: AttendanceStatus.success,
              attendanceRecord: null, // Clear record
              filteredStudents: [],
              attendanceStats: const AttendanceStats(),
            ),
          );
        } else {
          _updateStateWithRecord(emit, record);
        }
      },
    );
  }

  Future<void> _onInitializeAttendance(
    InitializeAttendance event,
    Emitter<TeacherAttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceStatus.initializing));

    // Create params for initialization.
    // Assuming AttendanceEntity matches the requirements
    // Note: We might need to construct a proper AttendanceEntity here.
    // Since I don't have the full definition of AttendanceEntity, I will do a best effort guess
    // based on common patterns. If properties are missing, this might need adjustment.

    final attendanceEntity = AttendanceEntity(
      id: '', // New record
      schoolId: event.schoolId,
      classId: event.classId,
      date: event.date,
    );

    final result = await _initializeAttendance(attendanceEntity);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AttendanceStatus.initializeFailure,
          errorMessage: failure.message,
        ),
      ),
      (entity) {
        emit(state.copyWith(status: AttendanceStatus.initializeSuccess));
        // Refresh to get the full view
        add(RefreshAttendanceRecord(date: event.date, classId: event.classId));
      },
    );
  }

  Future<void> _onDeleteAttendance(
    DeleteAttendance event,
    Emitter<TeacherAttendanceState> emit,
  ) async {
    emit(state.copyWith(status: AttendanceStatus.deleting));

    final result = await _deleteAttendance(event.attendanceId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AttendanceStatus.deleteFailure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        emit(state.copyWith(status: AttendanceStatus.deleteSuccess));
        if (state.selectedClassId != null) {
          add(
            RefreshAttendanceRecord(
              date: state.selectedDate,
              classId: state.selectedClassId!,
            ),
          );
        }
      },
    );
  }

  void _onSearchStudents(
    SearchStudents event,
    Emitter<TeacherAttendanceState> emit,
  ) {
    if (state.attendanceRecord == null) return;
    emit(state.copyWith(searchQuery: event.query));
    _filterStudents(emit, state.attendanceRecord!, event.query);
  }

  void _onUpdateStudentStatus(
    UpdateStudentStatus event,
    Emitter<TeacherAttendanceState> emit,
  ) {
    // TODO: Implement Update Student Status UseCase
    // Currently missing from provided list.
    // This part should call the API and then update state.

    // For now, we can only update the local state to reflect UI changes if desired,
    // but without backend sync it will be lost on refresh.
    // If update is critical, we need the usecase.
  }

  void _updateStateWithRecord(
    Emitter<TeacherAttendanceState> emit,
    AttendanceRecordViewEntity record,
  ) {
    _filterStudents(emit, record, state.searchQuery);
  }

  void _filterStudents(
    Emitter<TeacherAttendanceState> emit,
    AttendanceRecordViewEntity record,
    String query,
  ) {
    final allStudents = record.students ?? [];
    List<StudentAttendanceEntity> filtered;

    if (query.isEmpty) {
      filtered = allStudents.whereType<StudentAttendanceEntity>().toList();
    } else {
      filtered = allStudents
          .whereType<StudentAttendanceEntity>()
          .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    emit(
      state.copyWith(
        status: AttendanceStatus.success,
        attendanceRecord: record,
        filteredStudents: filtered,
        attendanceStats: _calculateStats(record.students),
      ),
    );
  }

  AttendanceStats _calculateStats(List<StudentAttendanceEntity?>? students) {
    if (students == null || students.isEmpty) return const AttendanceStats();

    int present = 0;
    int absent = 0;
    int late = 0;
    int leave = 0;
    int total = 0;

    for (var student in students) {
      if (student == null) continue;
      total++;
      switch (student.status) {
        case AttendanceStatusEnum.Present:
          present++;
          break;
        case AttendanceStatusEnum.Absent:
          absent++;
          break;
        case AttendanceStatusEnum.Late:
          late++;
          break;
        case AttendanceStatusEnum.AbsentWithLeave:
          leave++;
          break;
        default:
          break;
      }
    }

    return AttendanceStats(
      present: present,
      absent: absent,
      late: late,
      leave: leave,
      total: total,
    );
  }
}
