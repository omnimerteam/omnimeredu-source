import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/attendance/attendance_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/attendance/delete_attendance_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/attendance/get_all_attendances_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/attendance/initialize_class_attendancee_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_state.dart';

class AttendanceManagementBloc
    extends Bloc<AttendanceManagementEvent, AttendanceManagementState> {
  final GetAllAttendancesUseCase getAllAttendancesUseCase;
  final DeleteAttendanceUseCase deleteAttendanceUseCase;
  final InitializeClassAttendanceUseCase initializeClassAttendanceUseCase;

  AttendanceManagementBloc({
    required this.getAllAttendancesUseCase,
    required this.deleteAttendanceUseCase,
    required this.initializeClassAttendanceUseCase,
  }) : super(const AttendanceManagementInitial()) {
    on<LoadAttendancesEvent>(_onLoadAttendances);
    on<RefreshAttendancesEvent>(_onRefreshAttendances);
    on<LoadMoreAttendancesEvent>(_onLoadMoreAttendances);
    on<FilterAttendancesEvent>(_onFilterAttendances);
    on<SortAttendancesEvent>(_onSortAttendances);
    on<DeleteAttendanceEvent>(_onDeleteAttendance);
    on<InitializeAttendanceEvent>(_onInitializeAttendance);
  }

  Future<void> _onLoadAttendances(
    LoadAttendancesEvent event,
    Emitter<AttendanceManagementState> emit,
  ) async {
    emit(const AttendanceManagementLoading());
    try {
      final query = DefaultQueryEntity(
        page: AppConstants.defaultPage,
        limit: AppConstants.defaultLimit,
        sort: [
          {"date": "desc"},
        ],
        filter: {},
      );

      final attendances = await getAllAttendancesUseCase.call(query);

      emit(
        AttendanceManagementLoaded(
          attendances: attendances.data,
          hasReachedMax: attendances.data!.length < query.limit,
          currentQuery: query,
        ),
      );
    } catch (error) {
      emit(AttendanceManagementError(error.toString()));
    }
  }

  Future<void> _onRefreshAttendances(
    RefreshAttendancesEvent event,
    Emitter<AttendanceManagementState> emit,
  ) async {
    if (state is AttendanceManagementLoaded) {
      final current = state as AttendanceManagementLoaded;
      final refreshedQuery = current.currentQuery.copyWith(page: 1);
      emit(const AttendanceManagementLoading());
      try {
        final response = await getAllAttendancesUseCase.call(refreshedQuery);
        if (response.data != null) {
          emit(
            current.copyWith(
              attendances: response.data!,
              hasReachedMax: response.data!.length < refreshedQuery.limit,
              currentQuery: refreshedQuery,
            ),
          );
        } else {
          emit(
            AttendanceManagementError(
              response.message ?? 'Không thể tải dữ liệu điểm danh',
            ),
          );
        }
      } catch (e) {
        emit(AttendanceManagementError(e.toString()));
      }
    }
  }

  Future<void> _onLoadMoreAttendances(
    LoadMoreAttendancesEvent event,
    Emitter<AttendanceManagementState> emit,
  ) async {
    if (state is AttendanceManagementLoaded) {
      final current = state as AttendanceManagementLoaded;
      if (current.hasReachedMax) return;

      emit(
        AttendanceManagementLoadingMore(
          attendances: current.attendances,
          currentQuery: current.currentQuery,
        ),
      );

      try {
        final nextQuery = current.currentQuery.copyWith(
          page: current.currentQuery.page + 1,
        );
        final response = await getAllAttendancesUseCase.call(nextQuery);
        if (response.data != null) {
          emit(
            current.copyWith(
              attendances: [...?current.attendances, ...response.data!],
              hasReachedMax: response.data!.length < nextQuery.limit,
              currentQuery: nextQuery,
            ),
          );
        } else {
          emit(
            AttendanceManagementError(
              response.message ?? 'Không thể tải thêm dữ liệu',
            ),
          );
        }
      } catch (e) {
        emit(AttendanceManagementError(e.toString()));
      }
    }
  }

  Future<void> _onFilterAttendances(
    FilterAttendancesEvent event,
    Emitter<AttendanceManagementState> emit,
  ) async {
    if (state is AttendanceManagementLoaded) {
      final current = state as AttendanceManagementLoaded;
      final newQuery = current.currentQuery.copyWith(
        page: 1,
        filter: event.filter,
      );
      emit(const AttendanceManagementLoading());
      try {
        final response = await getAllAttendancesUseCase.call(newQuery);
        if (response.data != null) {
          emit(
            current.copyWith(
              attendances: response.data!,
              hasReachedMax: response.data!.length < newQuery.limit,
              currentQuery: newQuery,
            ),
          );
        } else {
          emit(
            AttendanceManagementError(
              response.message ?? 'Không thể lọc dữ liệu',
            ),
          );
        }
      } catch (e) {
        emit(AttendanceManagementError(e.toString()));
      }
    }
  }

  Future<void> _onSortAttendances(
    SortAttendancesEvent event,
    Emitter<AttendanceManagementState> emit,
  ) async {
    if (state is AttendanceManagementLoaded) {
      final current = state as AttendanceManagementLoaded;
      final newQuery = current.currentQuery.copyWith(page: 1, sort: event.sort);
      emit(const AttendanceManagementLoading());
      try {
        final response = await getAllAttendancesUseCase.call(newQuery);
        if (response.data != null) {
          emit(
            current.copyWith(
              attendances: response.data!,
              hasReachedMax: response.data!.length < newQuery.limit,
              currentQuery: newQuery,
            ),
          );
        } else {
          emit(
            AttendanceManagementError(
              response.message ?? 'Không thể sắp xếp dữ liệu',
            ),
          );
        }
      } catch (e) {
        emit(AttendanceManagementError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteAttendance(
    DeleteAttendanceEvent event,
    Emitter<AttendanceManagementState> emit,
  ) async {
    if (state is AttendanceManagementLoaded) {
      final current = state as AttendanceManagementLoaded;
      try {
        final res = await deleteAttendanceUseCase.call(event.attendanceId);

        if (res.data != null && res.data == true) {
          final remaining = current.attendances
              ?.where((a) => a.id != event.attendanceId)
              .toList();
          emit(current.copyWith(attendances: remaining));
        } else {
          emit(AttendanceManagementError(res.message ?? 'Không thể xóa bảng'));
        }
      } catch (e) {
        emit(AttendanceManagementError(e.toString()));
      }
    }
  }

  Future<void> _onInitializeAttendance(
    InitializeAttendanceEvent event,
    Emitter<AttendanceManagementState> emit,
  ) async {
    try {
      final attendanceData = AttendanceEntity(
        classId: event.classId,
        schoolId: event.schoolId,
        date: event.date,
      );

      final response = await initializeClassAttendanceUseCase.call(
        attendanceData,
      );

      if (response.success) {
        // Reload danh sách sau khi tạo thành công
        add(LoadAttendancesEvent());

        emit(
          AttendanceManagementError(
            response.message ?? "Tạo bảng điểm danh thành công",
          ),
        );
      } else {
        emit(
          AttendanceManagementError(
            response.message ?? 'Không thể tạo bảng điểm danh',
          ),
        );
      }
    } catch (e) {
      emit(
        AttendanceManagementError("Đã xảy ra lỗi khi khởi tạo điểm danh: $e"),
      );
    }
  }
}
