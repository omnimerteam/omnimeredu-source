import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class SchoolDescriptionCard extends StatelessWidget {
  final String description;

  const SchoolDescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(isDark),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 4),
            blurRadius: 15.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.description,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Mô tả',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextColor(isDark),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: "Inter",
              height: 1.5,
              color: AppColors.getTextColor(isDark).withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
