import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../common/widgets/skeleton/common_skeleton.dart';

class SchoolSkeletonLoader extends StatelessWidget {
  const SchoolSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header skeleton
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.getCardBackground(isDark),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                offset: const Offset(0, 4),
                blurRadius: 20.r,
              ),
            ],
          ),
          child: Column(
            children: [
              // Logo skeleton
              SkeletonBox(
                width: 100,
                height: 100,
                borderRadius: 20,
              ),
              SizedBox(height: 20.h),
              // Title skeleton
              SkeletonBox(
                width: 200,
                height: 24,
                borderRadius: 12,
              ),
              SizedBox(height: 8.h),
              SkeletonBox(
                width: 120,
                height: 16,
                borderRadius: 8,
              ),
            ],
          ),
        ),

        SizedBox(height: 24.h),

        // Info cards skeleton
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1.2,
          children: List.generate(6, (index) => _SkeletonCard()),
        ),

        SizedBox(height: 24.h),

        // Action buttons skeleton
        Row(
          children: [
            Expanded(
              child: SkeletonBox(
                height: 56,
                borderRadius: 16,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SkeletonBox(
                height: 56,
                borderRadius: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(isDark),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 2),
            blurRadius: 10.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(
            width: 40,
            height: 40,
            borderRadius: 12,
          ),
          SizedBox(height: 12.h),
          SkeletonBox(
            width: double.infinity,
            height: 16,
            borderRadius: 8,
          ),
          SizedBox(height: 8.h),
          SkeletonBox(
            width: 80,
            height: 14,
            borderRadius: 7,
          ),
        ],
      ),
    );
  }
}
