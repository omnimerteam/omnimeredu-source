import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../domain/entities/attendance/attendance_record_view_entity.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../core/theme/app_colors.dart';

class StudentAttendanceTable extends StatelessWidget {
  final List<StudentAttendanceEntity> students;
  final Function(StudentAttendanceEntity student) onEditPressed;

  const StudentAttendanceTable({
    Key? key,
    required this.students,
    required this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Danh sách học sinh',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20.w,
              horizontalMargin: 16.w,
              columns: const [
                DataColumn(label: Text('Trạng thái')),
                DataColumn(label: Text('Tên')),
                DataColumn(label: Text('Ngày sinh')),
                DataColumn(label: Text('Phụ huynh')),
              ],
              rows: students.map((student) {
                return DataRow(
                  onSelectChanged: (_) => onEditPressed(student),
                  cells: [
                    DataCell(_buildStatusDot(student.status)),
                    DataCell(Text(student.name)),
                    DataCell(Text(_formatDate(student.birthday))),
                    DataCell(Text(student.guardianName)),
                  ],
                );
              }).toList(),
            ),
          ),
          if (students.isEmpty)
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Center(
                child: Text(
                  'Không có dữ liệu học sinh',
                  style: TextStyle(color: AppColors.grey500),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusDot(AttendanceStatusEnum status) {
    Color color;
    switch (status) {
      case AttendanceStatusEnum.Present:
        color = AppColors.success;
        break;
      case AttendanceStatusEnum.Absent:
        color = AppColors.red;
        break;
      case AttendanceStatusEnum.Late:
        color = Colors.orange;
        break;
      case AttendanceStatusEnum.AbsentWithLeave:
        color = AppColors.blue;
        break;
      default:
        color = AppColors.grey400;
    }
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }
}
