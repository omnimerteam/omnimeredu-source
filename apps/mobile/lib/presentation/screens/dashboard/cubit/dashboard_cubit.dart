import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/dashboard_data_base_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/school_admin_dashboard_data_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/teacher/teacher_dashboard_data_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/dashboard/school_admin_dashboard_repository.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/get_class_teacher_assignments_usecase.dart';
import 'package:flutter_ios_android_platforms/services/dashboard_cache_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final SchoolAdminDashboardRepository schoolAdminRepo;
  final GetClassTeacherAssignmentsUseCase getClassTeacherAssignmentsUseCase;
  final DashboardCacheService cacheService;
  final AuthenticationBloc authBloc;

  DashboardCubit({
    required this.schoolAdminRepo,
    required this.getClassTeacherAssignmentsUseCase,
    required this.cacheService,
    required this.authBloc,
  }) : super(DashboardInitial());

  /// Load dashboard (sử dụng cache nếu còn hạn)
  Future<void> loadDashboard(String role) async {
    emit(DashboardLoading());

    try {
      // 1. Kiểm tra cache
      logger.i("[DashboardCubit] Kiểm tra cache cho role=$role");
      final cached = await cacheService.load(role);

      if (cached != null) {
        // Nếu cache còn hạn, emit luôn
        emit(DashboardLoaded(data: cached));

        // Refresh dữ liệu background để cập nhật cache
        _refreshCacheInBackground(role);
        return;
      }

      // 2. Nếu không có cache hoặc hết hạn -> fetch + emit
      final freshData = await _fetchFreshData(role);
      await cacheService.save(role, freshData);

      emit(DashboardLoaded(data: freshData));
    } catch (e) {
      emit(DashboardError("Không thể tải dữ liệu: $e"));
    }
  }

  /// Refresh dashboard bắt buộc từ API, emit luôn
  Future<void> refreshDashboard(String role) async {
    emit(DashboardLoading());
    try {
      final freshData = await _fetchFreshData(role);
      await cacheService.save(role, freshData);
      emit(DashboardLoaded(data: freshData));
    } catch (e) {
      emit(DashboardError("Không thể refresh dữ liệu: $e"));
    }
  }

  /// Core function: lấy dữ liệu mới từ API theo role
  Future<DashboardDataBaseEntity> _fetchFreshData(String role) async {
    switch (role) {
      case "SchoolAdmin":
        final overview = await schoolAdminRepo.getSummary();
        final attendance = await schoolAdminRepo.getSchoolAttendanceStats();
        return SchoolAdminDashboardDataEntity(
          overview: overview,
          attendanceStats: attendance,
          cachedAt: DateTime.now(),
        );

      case "Teacher":
        // 🔹 Lấy user từ AuthenticationBloc
        final authState = authBloc.state;
        if (authState is! AuthenticationAuthenticated) {
          throw Exception("Không xác thực được teacher");
        }
        final user = authState.user;

        final classes = await getClassTeacherAssignmentsUseCase.call(
          user.id, // teacherId
          user.schoolId!, // schoolId
        );

        return TeacherDashboardDataEntity(
          classAssignment: classes.data,
          cachedAt: DateTime.now(),
        );

      default:
        throw Exception("Role không hỗ trợ: $role");
    }
  }

  /// Refresh cache trong background mà không emit UI
  void _refreshCacheInBackground(String role) {
    _fetchFreshData(role)
        .then((freshData) async {
          await cacheService.save(role, freshData);
          logger.i(
            "[DashboardCubit] Cache updated in background for role=$role",
          );
        })
        .catchError((e, s) {
          logger.w(
            "[DashboardCubit] Refresh cache in background failed: $e\n$s",
          );
        });
  }
}
