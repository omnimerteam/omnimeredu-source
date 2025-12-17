import 'package:flutter/material.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/attendance/attendance_record_view_entity.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceDialog extends StatefulWidget {
  final StudentAttendanceEntity student;
  final Function(AttendanceStatusEnum status, String? note) onUpdate;

  const AttendanceDialog({
    Key? key,
    required this.student,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<AttendanceDialog> createState() => _AttendanceDialogState();
}

class _AttendanceDialogState extends State<AttendanceDialog> {
  late AttendanceStatusEnum _status;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _status = widget.student.status;
    _noteController = TextEditingController(text: widget.student.note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Điểm danh: ${widget.student.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<AttendanceStatusEnum>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Trạng thái'),
              items: AttendanceStatusEnum.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _status = val);
              },
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Ghi chú'),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onUpdate(_status, _noteController.text);
            Navigator.pop(context);
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
