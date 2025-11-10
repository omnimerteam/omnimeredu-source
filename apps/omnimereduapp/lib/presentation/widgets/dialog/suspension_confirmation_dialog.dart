import 'package:flutter/material.dart';
import '../button/app_button.dart';

class SuspensionConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final String confirmTitle;

  const SuspensionConfirmationDialog({
    Key? key,
    required this.title,
    required this.confirmTitle,
    required this.message,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                onPressed: () => Navigator.pop(context),
                text: "Hủy",
                type: AppButtonType.cancel,
              ),
            ),
            const SizedBox(width: 12), // chỉnh khoảng cách ngang
            Expanded(
              child: AppButton(
                text: confirmTitle,
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm(); // ✅ gọi thực sự
                },
                type: AppButtonType.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
