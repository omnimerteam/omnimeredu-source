import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'Xác nhận đăng xuất',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
      content: Text(
        'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng? Bạn sẽ cần đăng nhập lại để sử dụng các tính năng.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontSize: 16.sp),
      ),
      actionsPadding: EdgeInsets.all(16.w),
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
            SizedBox(width: 12.w),
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
