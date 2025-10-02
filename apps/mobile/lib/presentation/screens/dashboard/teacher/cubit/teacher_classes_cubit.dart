import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/domain/entities/attendance/attendance_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/attendance/initialize_class_attendancee_usecase.dart';
import 'teacher_classes_state.dart';

class TeacherClassesCubit extends Cubit<TeacherClassesState> {
  final InitializeClassAttendanceUseCase initializeClassAttendanceUseCase;

  TeacherClassesCubit({required this.initializeClassAttendanceUseCase})
    : super(TeacherClassesInitial());

  /// Load danh sách lớp của giáo viên
  // Future<void> loadTeacherClasses({
  //   required String teacherId,
  //   required String schoolId,
  // }) async {
  //   emit(TeacherClassesLoading());

  //   try {
  //     final response = await getClassTeacherAssignmentsUseCase.call(
  //       teacherId,
  //       schoolId,
  //     );

  //     if (response.success && response.data != null) {
  //       emit(TeacherClassesLoaded(classes: response.data!));
  //     } else {
  //       emit(
  //         TeacherClassesError(
  //           response.message ?? 'Không thể tải danh sách lớp học',
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     logger.e('[TeacherClassesCubit] Error loading classes: $e');
  //     emit(TeacherClassesError('Đã xảy ra lỗi: $e'));
  //   }
  // }

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

        // Reload lại danh sách để cập nhật isHaveAttendance
        // Cần truyền lại teacherId và schoolId từ nơi gọi
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

  /// Refresh danh sách lớp
  //   Future<void> refreshClasses({
  //     required String teacherId,
  //     required String schoolId,
  //   }) async {
  //     await loadTeacherClasses(teacherId: teacherId, schoolId: schoolId);
  //   }
}
