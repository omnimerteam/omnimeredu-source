import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/attendance/get_all_attendances_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_state.dart';

class AttendanceManagementBloc
    extends Bloc<AttendanceManagementEvent, AttendanceManagementState> {
  final GetAllAttendancesUseCase getAllAttendancesUseCase;
  // final DeleteAttendanceUseCase deleteAttendanceUseCase; // Sẽ thêm sau

  AttendanceManagementBloc({
    required this.getAllAttendancesUseCase,
    // required this.deleteAttendanceUseCase,
  }) : super(const AttendanceManagementInitial()) {
    on<LoadAttendancesEvent>(_onLoadAttendances);
    on<RefreshAttendancesEvent>(_onRefreshAttendances);
    on<LoadMoreAttendancesEvent>(_onLoadMoreAttendances);
    on<FilterAttendancesEvent>(_onFilterAttendances);
    on<SortAttendancesEvent>(_onSortAttendances);
    on<SearchAttendancesEvent>(_onSearchAttendances);
    on<DeleteAttendanceEvent>(_onDeleteAttendance);
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

  Future<void> _onSearchAttendances(
    SearchAttendancesEvent event,
    Emitter<AttendanceManagementState> emit,
  ) async {
    if (state is AttendanceManagementLoaded) {
      final current = state as AttendanceManagementLoaded;
      final newQuery = current.currentQuery.copyWith(
        page: 1,
        search: event.search.trim().isEmpty ? null : event.search.trim(),
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
              response.message ?? 'Không thể tìm kiếm dữ liệu',
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
        // TODO: Gọi deleteAttendanceUseCase khi đã implement
        // await deleteAttendanceUseCase.call(event.attendanceId);

        final remaining = current.attendances
            ?.where((a) => a.id != event.attendanceId)
            .toList();
        emit(current.copyWith(attendances: remaining));
      } catch (e) {
        emit(AttendanceManagementError(e.toString()));
      }
    }
  }
}
