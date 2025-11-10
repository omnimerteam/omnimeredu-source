import 'package:flutter/material.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/view_model/attendance_record_view_entity.dart';
import '../../../../widgets/button/app_button.dart';
import '../../../../widgets/dropdown/primary_dropdown.dart';
import '../../../../widgets/text_field/primary_multiline_text_field.dart';

class AttendanceDialog extends StatefulWidget {
  final StudentAttendanceEntity student;
  final Function(AttendanceStatusEnum status, String note) onUpdate;

  const AttendanceDialog({
    super.key,
    required this.student,
    required this.onUpdate,
  });

  @override
  State<AttendanceDialog> createState() => _AttendanceDialogState();
}

class _AttendanceDialogState extends State<AttendanceDialog> {
  late AttendanceStatusEnum selectedStatus;
  late TextEditingController noteController;
  late FocusNode noteFocusNode;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.student.status;
    noteController = TextEditingController(text: widget.student.note ?? '');
    noteFocusNode = FocusNode();
  }

  @override
  void dispose() {
    noteController.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.student.name),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trạng thái điểm danh',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            PrimaryDropdown<AttendanceStatusEnum>(
              hintText: "Điểm danh",
              prefixIcon: Icons.how_to_reg,
              value: selectedStatus,
              items: AttendanceStatusEnum.values.map((s) {
                return DropdownMenuItem<AttendanceStatusEnum>(
                  value: s,
                  child: Text(s.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Ghi chú',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            PrimaryMultilineTextField(
              controller: noteController,
              focusNode: noteFocusNode,
              hintText: "Nhập ghi chú (nếu có)",
              prefixIcon: Icons.note_alt_outlined,
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                onPressed: () => Navigator.pop(context),
                text: 'Đóng',
                type: AppButtonType.cancel,
              ),
            ),

            SizedBox(width: 15),

            Expanded(
              child: AppButton(
                onPressed: () {
                  widget.onUpdate(selectedStatus, noteController.text.trim());
                  Navigator.pop(context);
                },
                text: 'Cập nhật',
                type: AppButtonType.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
