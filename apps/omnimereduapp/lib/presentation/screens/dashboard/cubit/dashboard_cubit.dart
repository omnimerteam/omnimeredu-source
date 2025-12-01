import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/authentication/authentication_bloc.dart';
import '../../../../core/bloc/authentication/authentication_state.dart';
import '../../../../core/utils/logger.dart';
import '../../../../domain/entities/dashboard/dashboard_data_base_entity.dart';
import '../../../../domain/entities/dashboard/school_admin/school_admin_dashboard_data_entity.dart';
import '../../../../domain/entities/dashboard/teacher/teacher_dashboard_data_entity.dart';
import '../../../../domain/repositories/dashboard/school_admin_dashboard_repository.dart';
import '../../../../domain/usecases/teaching_assignment/get_class_teacher_assignments_usecase.dart';
import '../../../../services/dashboard_cache_service.dart';
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

  /// 🔹 HÀM MỚI: Cập nhật isHaveAttendance cho class
  void updateClassAttendanceStatus(String classId, bool hasAttendance) {
    final current = state;

    // Chỉ xử lý nếu đang ở trạng thái loaded và là teacher data
    if (current is! DashboardLoaded) return;
    if (current.data is! TeacherDashboardDataEntity) return;

    final teacherData = current.data as TeacherDashboardDataEntity;

    // Cập nhật class có classId tương ứng
    final updatedClasses = teacherData.classAssignment?.map((cls) {
      if (cls.id == classId) {
        return cls.copyWith(isHaveAttendance: hasAttendance);
      }
      return cls;
    }).toList();

    // Tạo data mới với cachedAt cũ (để không làm mất cache)
    final updatedData = teacherData.copyWith(
      classAssignment: updatedClasses,
      // Giữ nguyên cachedAt để cache không bị invalidate
      cachedAt: teacherData.cachedAt,
    );

    // 🔹 Emit state mới để trigger rebuild
    emit(DashboardLoaded(data: updatedData));

    // 🔹 Cập nhật cache với data mới
    _updateCacheInBackground(updatedData);

    logger.i(
      "[DashboardCubit] Updated isHaveAttendance=$hasAttendance for classId=$classId",
    );
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

  /// 🔹 Cập nhật cache trong background
  void _updateCacheInBackground(DashboardDataBaseEntity data) {
    if (data is TeacherDashboardDataEntity) {
      cacheService
          .save('Teacher', data)
          .then((_) {
            logger.i("[DashboardCubit] Cache updated after attendance change");
          })
          .catchError((e) {
            logger.w("[DashboardCubit] Failed to update cache: $e");
          });
    }
  }
}
