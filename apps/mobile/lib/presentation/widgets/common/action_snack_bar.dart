import 'package:flutter/material.dart';

/// Helper hiển thị Snackbar dựa trên message và success flag
void showActionSnackBar({
  required BuildContext context,
  required String? message,
  required bool lastActionSuccess,
}) {
  if (message == null && lastActionSuccess) return; // không cần show
  final snackBar = SnackBar(
    content: Text(
      message ?? (lastActionSuccess ? 'Thành công' : 'Có lỗi xảy ra'),
    ),
    backgroundColor: lastActionSuccess ? Colors.green : Colors.red,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
