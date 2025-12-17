import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class AttendanceActionDialog {
  static Future<void> showCreateOrDeleteDialog({
    required BuildContext context,
    required bool hasAttendance,
    required DateTime selectedDate,
    required VoidCallback onCreateConfirm,
    required VoidCallback onDeleteConfirm,
  }) {
    final isDelete = hasAttendance;
    final title = isDelete ? 'Xóa bảng điểm danh' : 'Tạo bảng điểm danh';
    final content = isDelete
        ? 'Bạn có chắc chắn muốn xóa bảng điểm danh ngày ${selectedDate.day}/${selectedDate.month}?'
        : 'Tạo bảng điểm danh mới cho ngày ${selectedDate.day}/${selectedDate.month}?';

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDelete ? AppColors.red : AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              if (isDelete) {
                onDeleteConfirm();
              } else {
                onCreateConfirm();
              }
            },
            child: Text(isDelete ? 'Xóa' : 'Tạo'),
          ),
        ],
      ),
    );
  }
}
