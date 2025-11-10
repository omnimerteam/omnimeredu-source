import 'package:flutter/material.dart';
import '../../../../../domain/entities/view_model/attendance_record_view_entity.dart';
import '../../../../../core/constants/enum_constant.dart';

class StudentAttendanceTable extends StatelessWidget {
  final List<StudentAttendanceEntity> students;
  final Function(StudentAttendanceEntity student) onEditPressed;
  final VoidCallback onExportData;

  const StudentAttendanceTable({
    super.key,
    required this.students,
    required this.onEditPressed,
    required this.onExportData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: theme.cardTheme.elevation ?? 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sách học sinh',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onExportData,
                  icon: Icon(
                    Icons.download,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),

          /// Table with horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                /// Column headers
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(children: _buildHeaderCells(theme)),
                ),

                /// Student rows
                if (students.isNotEmpty)
                  Column(
                    children: students.map((student) {
                      return InkWell(
                        onTap: () => onEditPressed(student),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          child: Row(
                            children: _buildStudentCells(student, theme),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Không có học sinh',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHeaderCells(ThemeData theme) {
    final headers = [
      '',
      'Tên',
      'Ngày sinh',
      'Giới tính',
      'Điện thoại',
      'Người giám hộ',
      'Điện thoại GH',
    ];
    final widths = [60.0, 200.0, 120.0, 80.0, 140.0, 200.0, 140.0];

    return List.generate(headers.length, (index) {
      return SizedBox(
        width: widths[index],
        child: Text(
          headers[index],
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    });
  }

  List<Widget> _buildStudentCells(
    StudentAttendanceEntity student,
    ThemeData theme,
  ) {
    String formatDate(DateTime? date) {
      if (date == null) return '';
      return '${date.day}/${date.month}/${date.year}';
    }

    final values = [
      _statusDot(student.status, theme),
      student.name,
      formatDate(student.birthday),
      student.gender ?? '',
      student.phone ?? '',
      student.guardianName,
      student.guardianPhone,
    ];

    final widths = [60.0, 200.0, 120.0, 80.0, 140.0, 200.0, 140.0];

    return List.generate(values.length, (index) {
      final value = values[index];
      return SizedBox(
        width: widths[index],
        child: value is Widget ? value : _cellText(value.toString(), theme),
      );
    });
  }

  Widget _cellText(String text, ThemeData theme) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: theme.textTheme.bodyMedium,
    );
  }

  Widget _statusDot(AttendanceStatusEnum status, ThemeData theme) {
    Color color;
    switch (status) {
      case AttendanceStatusEnum.Present:
        color = theme.colorScheme.tertiary; // success
        break;
      case AttendanceStatusEnum.Absent:
        color = theme.colorScheme.error;
        break;
      case AttendanceStatusEnum.Late:
        color = Colors.orange;
        break;
      case AttendanceStatusEnum.AbsentWithLeave:
        color = theme.colorScheme.secondary;
        break;
      case AttendanceStatusEnum.LeftEarly:
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
