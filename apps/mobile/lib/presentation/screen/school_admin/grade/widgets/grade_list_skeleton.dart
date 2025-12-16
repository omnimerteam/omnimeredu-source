import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/presentation/common/widgets/skeleton/common_skeleton.dart';

class GradeListSkeleton extends StatelessWidget {
  const GradeListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        6,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonBox(height: 20, width: 180),
                    SkeletonBox(height: 20, width: 80),
                  ],
                ),
                SizedBox(height: 8.h),

                // Level
                Row(
                  children: [
                    SkeletonBox(height: 16, width: 16), // Icon
                    SizedBox(width: 8.w),
                    SkeletonBox(height: 16, width: 100),
                  ],
                ),
                SizedBox(height: 4.h),

                // Age
                Row(
                  children: [
                    SkeletonBox(height: 16, width: 16), // Icon
                    SizedBox(width: 8.w),
                    SkeletonBox(height: 16, width: 120),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
