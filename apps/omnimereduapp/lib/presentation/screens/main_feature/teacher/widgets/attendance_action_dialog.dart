import 'package:flutter/material.dart';
import 'package:omnimereduapp/presentation/widgets/button/app_button.dart';

/// 🔹 Dialog xác nhận tạo bảng điểm danh
class CreateAttendanceDialog extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onConfirm;

  const CreateAttendanceDialog({
    super.key,
    required this.selectedDate,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tạo bảng điểm danh'),
      content: Text(
        'Bạn có chắc muốn tạo bảng điểm danh cho ngày '
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}?',
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                onPressed: () => Navigator.of(context).pop(),
                text: 'Hủy',
                type: AppButtonType.cancel,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: AppButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                text: 'Tạo mới',
                type: AppButtonType.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 🔹 Dialog xác nhận xóa bảng điểm danh
class DeleteAttendanceDialog extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onConfirm;

  const DeleteAttendanceDialog({
    super.key,
    required this.selectedDate,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xóa bảng điểm danh'),
      content: Text(
        'Bảng điểm danh cho ngày '
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} '
        'đã tồn tại.\n\nBạn có chắc muốn xóa bảng điểm danh này không?',
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                onPressed: () => Navigator.of(context).pop(),
                text: 'Hủy',
                type: AppButtonType.cancel,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: AppButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                text: 'Xóa',
                type: AppButtonType.danger,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 🔹 Helper function để hiển thị dialog tạo/xóa
class AttendanceDialogHelper {
  static void showCreateOrDeleteDialog({
    required BuildContext context,
    required bool hasAttendance,
    required DateTime selectedDate,
    required VoidCallback onCreateConfirm,
    required VoidCallback onDeleteConfirm,
  }) {
    if (hasAttendance) {
      showDialog(
        context: context,
        builder: (context) => DeleteAttendanceDialog(
          selectedDate: selectedDate,
          onConfirm: onDeleteConfirm,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => CreateAttendanceDialog(
          selectedDate: selectedDate,
          onConfirm: onCreateConfirm,
        ),
      );
    }
  }
}
