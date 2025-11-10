import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../domain/entities/attendance/attendance_entity.dart';
import '../../../../../domain/usecases/attendance/initialize_class_attendancee_usecase.dart';
import '../../../../../domain/entities/dashboard/teacher/teacher_dashboard_data_entity.dart';
import '../../cubit/dashboard_cubit.dart';
import '../../cubit/dashboard_state.dart';
import 'teacher_classes_state.dart';

class TeacherClassesCubit extends Cubit<TeacherClassesState> {
  final InitializeClassAttendanceUseCase initializeClassAttendanceUseCase;
  final DashboardCubit dashboardCubit;

  TeacherClassesCubit({
    required this.initializeClassAttendanceUseCase,
    required this.dashboardCubit,
  }) : super(TeacherClassesInitial());

  /// Tạo bảng điểm danh cho lớp
  Future<void> initializeAttendance({
    required String classId,
    required String schoolId,
  }) async {
    emit(InitializingAttendance(classId));

    try {
      final attendanceData = AttendanceEntity(
        classId: classId,
        schoolId: schoolId,
      );

      final response = await initializeClassAttendanceUseCase.call(
        attendanceData,
      );

      if (response.success) {
        emit(
          AttendanceInitialized(
            classId: classId,
            message: 'Tạo bảng điểm danh thành công',
          ),
        );

        // ✅ Cập nhật ngay trong DashboardCubit
        _updateDashboardClassAttendanceFlag(classId);
      } else {
        emit(
          AttendanceInitializationError(
            classId: classId,
            message: response.message ?? 'Không thể tạo bảng điểm danh',
          ),
        );
      }
    } catch (e) {
      logger.e('[TeacherClassesCubit] Error initializing attendance: $e');
      emit(
        AttendanceInitializationError(
          classId: classId,
          message: 'Đã xảy ra lỗi: $e',
        ),
      );
    }
  }

  /// ✅ Hàm cập nhật DashboardCubit khi lớp vừa tạo điểm danh
  void _updateDashboardClassAttendanceFlag(String classId) {
    final current = dashboardCubit.state;
    if (current is DashboardLoaded &&
        current.data is TeacherDashboardDataEntity) {
      final teacherData = current.data as TeacherDashboardDataEntity;

      final updatedClasses = teacherData.classAssignment?.map((cls) {
        if (cls.id == classId) {
          return cls.copyWith(isHaveAttendance: true);
        }
        return cls;
      }).toList();

      final updatedData = teacherData.copyWith(
        classAssignment: updatedClasses,
        cachedAt: DateTime.now(),
      );

      // Ghi đè state trong dashboardCubit
      dashboardCubit.emit(DashboardLoaded(data: updatedData));

      logger.i(
        "[TeacherClassesCubit] Đã cập nhật isHaveAttendance=true cho classId=$classId trong DashboardCubit",
      );
    }
  }
}
