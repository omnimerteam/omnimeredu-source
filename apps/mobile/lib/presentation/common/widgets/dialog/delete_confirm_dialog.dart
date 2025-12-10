import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../button/app_button.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    this.title = 'Xác nhận xóa',
    required this.message,
    this.confirmText = 'Xóa',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      actionsPadding: EdgeInsets.all(16.w),
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
            SizedBox(width: 12.w),
            Expanded(
              child: AppButton(
                onPressed: () {
                  Navigator.of(context).pop(); // đóng dialog
                  onConfirm();
                },
                text: confirmText,
                type: AppButtonType.danger,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
