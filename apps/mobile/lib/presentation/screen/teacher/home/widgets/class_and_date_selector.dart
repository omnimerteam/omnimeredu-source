import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/presentation/common/widgets/input/primary_dropdown.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../domain/entities/attendance/attendance_record_view_entity.dart';

class ClassAndDateSelector extends StatelessWidget {
  final String schoolId;
  final String? initialClassId;
  final DateTime initialDate;
  final bool isLoading;
  final bool hasAttendance;
  final Function(String classId) onClassChanged;
  final Function(DateTime date) onDateChanged;
  final VoidCallback onRefresh;
  final VoidCallback onNewOrDelete;
  final VoidCallback onQRAttendance;
  // TODO: Parent should provide list of classes.
  // For now using empty list or we can fetch if we had the bloc.
  final List<AttendanceClassInfoEntity> classes;

  const ClassAndDateSelector({
    Key? key,
    required this.schoolId,
    this.initialClassId,
    required this.initialDate,
    this.isLoading = false,
    this.hasAttendance = false,
    required this.onClassChanged,
    required this.onDateChanged,
    required this.onRefresh,
    required this.onNewOrDelete,
    required this.onQRAttendance,
    this.classes = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PrimaryDropdown<String>(
                // label parameter doesn't exist in PrimaryDropdown
                hintText: 'Chọn lớp',
                prefixIcon: Icons.class_,
                value: initialClassId,
                items: classes
                    .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) onClassChanged(val);
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: InkWell(
                onTap: () => _pickDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Ngày',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${initialDate.day}/${initialDate.month}/${initialDate.year}',
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: isLoading ? null : onRefresh,
              icon: const Icon(Icons.refresh),
              tooltip: 'Làm mới',
            ),
            SizedBox(width: 8.w),
            ElevatedButton.icon(
              onPressed: onQRAttendance,
              icon: const Icon(Icons.qr_code, size: 20),
              label: const Text('Mã QR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(width: 8.w),
            // Button to Create or Delete based on state
            if (hasAttendance)
              OutlinedButton.icon(
                onPressed: isLoading ? null : onNewOrDelete,
                icon: const Icon(Icons.delete, size: 20),
                label: const Text('Xóa'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.red),
              )
            else
              ElevatedButton.icon(
                onPressed: isLoading ? null : onNewOrDelete,
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Tạo'),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      onDateChanged(newDate);
    }
  }
}
