import 'package:flutter/material.dart';
import '../../../../../domain/entities/attendance/attendance_record_view_entity.dart';
import '../bloc/attendance/teacher_attendance_state.dart';
import 'student_attendance_table.dart';

class AttendanceTableSection extends StatelessWidget {
  final TeacherAttendanceState state;
  final Function(StudentAttendanceEntity) onEditStudent;
  final VoidCallback onExportData;
  final VoidCallback onCreateAttendance;

  const AttendanceTableSection({
    Key? key,
    required this.state,
    required this.onEditStudent,
    required this.onExportData,
    required this.onCreateAttendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.attendanceRecord == null) {
      if (state.status == AttendanceStatus.loading ||
          state.status == AttendanceStatus.initializing) {
        return const Center(child: CircularProgressIndicator());
      }
      return Center(
        child: Column(
          children: [
            const Text('Chưa có bảng điểm danh cho ngày này'),
            ElevatedButton(
              onPressed: onCreateAttendance,
              child: const Text('Tạo bảng điểm danh'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        StudentAttendanceTable(
          students: state.filteredStudents,
          onEditPressed: onEditStudent,
        ),
      ],
    );
  }
}
