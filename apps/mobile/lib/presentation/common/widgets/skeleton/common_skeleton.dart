import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';

class SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.grey700 : AppColors.grey300,
      highlightColor: isDark ? AppColors.grey500 : AppColors.grey100,
      child: Container(
        height: height.h,
        width: width == double.infinity ? width : width.w,
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }
}
