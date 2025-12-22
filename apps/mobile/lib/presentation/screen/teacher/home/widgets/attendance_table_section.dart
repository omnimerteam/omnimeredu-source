import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../domain/entities/attendance/attendance_record_view_entity.dart';
import '../bloc/teacher_attendance_state.dart';
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
    // Chỉ hiện loading spinner khi thực sự đang loading
    if (state.status == AttendanceStatus.loading ||
        state.status == AttendanceStatus.initializing) {
      return SizedBox(
        height: 200.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Hiện lỗi nếu có - kèm nút tạo mới
    if (state.status == AttendanceStatus.failure) {
      return SizedBox(
        height: 200.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48.sp, color: Colors.orange),
              SizedBox(height: 12.h),
              Text(
                state.errorMessage ?? 'Không tìm thấy bảng điểm danh',
                style: TextStyle(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              ElevatedButton.icon(
                onPressed: onCreateAttendance,
                icon: const Icon(Icons.add),
                label: const Text('Tạo bảng điểm danh mới'),
              ),
            ],
          ),
        ),
      );
    }

    // Chưa chọn lớp
    if (state.selectedClassId == null) {
      return SizedBox(
        height: 200.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.class_outlined, size: 48.sp, color: Colors.grey),
              SizedBox(height: 12.h),
              Text(
                'Vui lòng chọn lớp để xem điểm danh',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Không có bảng điểm danh cho ngày này
    if (state.attendanceRecord == null) {
      return SizedBox(
        height: 200.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_note_outlined, size: 48.sp, color: Colors.grey),
              SizedBox(height: 12.h),
              const Text('Chưa có bảng điểm danh cho ngày này'),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: onCreateAttendance,
                child: const Text('Tạo bảng điểm danh'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StudentAttendanceTable(
          students: state.filteredStudents,
          onEditPressed: onEditStudent,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
