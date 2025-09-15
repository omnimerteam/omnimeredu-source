import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/dashboard_data_base_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/school_admin_dashboard_data_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/dashboard/school_admin_dashboard_repository.dart';
import 'package:flutter_ios_android_platforms/services/dashboard_cache_service.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final SchoolAdminDashboardRepository schoolAdminRepo;
  final DashboardCacheService cacheService;
  // TODO: thêm repository khác nếu có teacher/student

  DashboardCubit({required this.schoolAdminRepo, required this.cacheService})
    : super(DashboardInitial());

  /// Load dashboard (có dùng cache)
  Future<void> loadDashboard(String role) async {
    emit(DashboardLoading());
    try {
      // 1. Kiểm tra cache trước
      logger.i("Kiểm tra cache");
      final cached = await cacheService.load(role);
      if (cached != null) {
        emit(DashboardLoaded(data: cached));
        _refreshInBackground(role);
        return;
      }

      // 2. Nếu không có cache hoặc hết hạn, gọi API
      await _fetchAndCache(role);
    } catch (e) {
      emit(DashboardError("Không thể tải dữ liệu: $e"));
    }
  }

  /// Refresh dashboard, luôn gọi API
  Future<void> refreshDashboard(String role) async {
    await _fetchAndCache(role);
  }

  /// Fetch mới từ API và lưu cache
  Future<void> _fetchAndCache(String role) async {
    late final DashboardDataBaseEntity fresh;

    switch (role) {
      case "SchoolAdmin":
        final overview = await schoolAdminRepo.getSummary();
        final attendance = await schoolAdminRepo.getSchoolAttendanceStats();
        fresh = SchoolAdminDashboardDataEntity(
          overview: overview,
          attendanceStats: attendance,
          cachedAt: DateTime.now(),
        );
        break;

      // case "teacher":
      //   fresh = TeacherDashboardDataEntity(...);
      //   break;

      // case "student":
      //   fresh = StudentDashboardDataEntity(...);
      //   break;

      default:
        throw Exception("Role không hỗ trợ: $role");
    }

    // Lưu cache
    await cacheService.save(role, fresh);

    emit(DashboardLoaded(data: fresh));
  }

  /// Tải lại dữ liệu trong background nhưng không emit nếu user đang xem cache
  void _refreshInBackground(String role) async {
    try {
      final fresh = await _fetchAndCache(role);
    } catch (_) {}
  }
}
