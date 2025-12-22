import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class SchoolErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetryPressed;

  const SchoolErrorState({
    super.key,
    required this.message,
    required this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60.r),
            ),
            child: Icon(Icons.error_outline, size: 60.sp, color: AppColors.error),
          ),
          SizedBox(height: 24.h),
          Text(
            'Có lỗi xảy ra',
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: "Nunito",
              fontWeight: FontWeight.bold,
              color: AppColors.getTextColor(isDark),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: "Inter",
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton.icon(
            onPressed: onRetryPressed,
            icon: Icon(
              Icons.refresh,
              color: AppColors.backgroundLight,
              size: 20.sp,
            ),
            label: Text(
              'Thử lại',
              style: TextStyle(
                color: AppColors.backgroundLight,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
