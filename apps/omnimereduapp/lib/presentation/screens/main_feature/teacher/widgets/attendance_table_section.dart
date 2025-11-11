import 'package:flutter/material.dart';
import 'package:omnimereduapp/domain/entities/view_model/attendance_record_view_entity.dart';
import 'package:omnimereduapp/presentation/screens/main_feature/teacher/bloc/teacher_attendance_state.dart';
import 'package:omnimereduapp/presentation/screens/main_feature/teacher/widgets/attendance_loading_state.dart';
import 'package:omnimereduapp/presentation/screens/main_feature/teacher/widgets/student_attendance_table.dart';

/// 🔹 Widget xử lý hiển thị phần bảng học sinh
class AttendanceTableSection extends StatelessWidget {
  final TeacherAttendanceState state;
  final Function(StudentAttendanceEntity) onEditStudent;
  final VoidCallback onExportData;
  final VoidCallback onCreateAttendance;

  const AttendanceTableSection({
    super.key,
    required this.state,
    required this.onEditStudent,
    required this.onExportData,
    required this.onCreateAttendance,
  });

  @override
  Widget build(BuildContext context) {
    // 🔹 Xử lý trạng thái initializing (đang tạo)
    if (state.status == AttendanceStatus.initializing) {
      return const AttendanceInitializingState();
    }

    // 🔹 Xử lý trạng thái deleting (đang xóa)
    if (state.status == AttendanceStatus.deleting) {
      return const AttendanceDeletingState();
    }

    // 🔹 Xử lý trạng thái loading
    if (state.status == AttendanceStatus.loading) {
      return const AttendanceTableLoading();
    }

    // 🔹 Chưa chọn lớp
    if (state.status == AttendanceStatus.initial &&
        state.selectedClassId == null) {
      return const AttendanceEmptyState(
        message: 'Vui lòng chọn lớp và ngày để xem điểm danh',
        icon: Icons.class_outlined,
      );
    }

    // 🔹 Hiển thị message khi chưa có attendance record
    if (state.attendanceRecord == null && state.selectedClassId != null) {
      return AttendanceNoDataState(
        selectedDate: state.selectedDate,
        onCreatePressed: onCreateAttendance,
      );
    }

    // 🔹 Không có dữ liệu học sinh
    if (state.attendanceRecord?.students == null ||
        state.attendanceRecord!.students!.isEmpty) {
      return const AttendanceEmptyState(
        message: 'Không có dữ liệu học sinh',
        icon: Icons.group_outlined,
      );
    }

    // 🔹 Hiển thị bảng học sinh
    return StudentAttendanceTable(
      students: state.filteredStudents,
      onEditPressed: onEditStudent,
      onExportData: onExportData,
    );
  }
}
