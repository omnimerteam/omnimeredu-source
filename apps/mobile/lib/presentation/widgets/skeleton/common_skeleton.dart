import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

class SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const SkeletonBox({
    Key? key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade500 : Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
