import 'package:flutter/material.dart';
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
      title: Text(title),
      content: Text(message),
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
            const SizedBox(width: 12),
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
