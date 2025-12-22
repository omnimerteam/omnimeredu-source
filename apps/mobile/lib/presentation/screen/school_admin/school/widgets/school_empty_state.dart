import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class SchoolEmptyState extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const SchoolEmptyState({super.key, required this.onCreatePressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              color: AppColors.extraLightBlue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Icon(
              Icons.school_outlined,
              size: 80.sp,
              color: AppColors.primary.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            'Chưa có thông tin trường',
            style: TextStyle(
              fontSize: 24.sp,
              fontFamily: "PlayfairDisplay",
              fontWeight: FontWeight.bold,
              color: AppColors.getTextColor(isDark),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Tạo thông tin trường để bắt đầu quản lý',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: "Inter",
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  offset: const Offset(0, 8),
                  blurRadius: 20.r,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onCreatePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Tạo trường mới',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
