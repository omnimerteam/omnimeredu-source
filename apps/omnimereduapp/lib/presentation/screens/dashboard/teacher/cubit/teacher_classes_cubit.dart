import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../domain/entities/attendance/attendance_entity.dart';
import '../../../../../domain/usecases/attendance/initialize_class_attendancee_usecase.dart';
import '../../cubit/dashboard_cubit.dart';
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
        // ✅ Cập nhật DashboardCubit TRƯỚC KHI emit success
        dashboardCubit.updateClassAttendanceStatus(classId, true);

        // Emit success state
        emit(
          AttendanceInitialized(
            classId: classId,
            message: 'Tạo bảng điểm danh thành công',
          ),
        );

        logger.i(
          '[TeacherClassesCubit] Successfully initialized attendance for classId=$classId',
        );
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

  /// 🔹 Xóa bảng điểm danh (nếu cần)
  Future<void> deleteAttendance({
    required String classId,
    required String attendanceId,
  }) async {
    emit(DeletingAttendance(classId));

    try {
      // Gọi API xóa ở đây...
      // final response = await deleteAttendanceUseCase.call(attendanceId);

      // Giả sử xóa thành công
      dashboardCubit.updateClassAttendanceStatus(classId, false);

      emit(
        AttendanceDeleted(
          classId: classId,
          message: 'Xóa bảng điểm danh thành công',
        ),
      );

      logger.i(
        '[TeacherClassesCubit] Successfully deleted attendance for classId=$classId',
      );
    } catch (e) {
      logger.e('[TeacherClassesCubit] Error deleting attendance: $e');
      emit(
        AttendanceDeletionError(classId: classId, message: 'Đã xảy ra lỗi: $e'),
      );
    }
  }
}
