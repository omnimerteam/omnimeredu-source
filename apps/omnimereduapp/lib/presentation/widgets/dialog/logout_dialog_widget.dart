import 'package:flutter/material.dart';
import '../button/app_button.dart';

class LogoutDialogWidget extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const LogoutDialogWidget({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.logout, color: Colors.red, size: 24),
          ),
          const SizedBox(width: 12),
          const Text(
            'Xác nhận đăng xuất',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Text(
        'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng? Bạn sẽ cần đăng nhập lại để sử dụng các tính năng.',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Hủy',
                onPressed: onCancel,
                type: AppButtonType.cancel,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                text: "Đăng xuất",
                onPressed: onConfirm,
                type: AppButtonType.danger,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
