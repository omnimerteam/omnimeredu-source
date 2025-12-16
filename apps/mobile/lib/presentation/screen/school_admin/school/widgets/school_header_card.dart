import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../domain/entities/school/school_data_entity.dart';
import '../../../../../core/theme/app_colors.dart';

class SchoolHeaderCard extends StatelessWidget {
  final SchoolDataEntity school;

  const SchoolHeaderCard({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 20.r,
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2.w,
              ),
            ),
            child: school.logoUrl != null && school.logoUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: Image.network(
                      school.logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 50.sp,
                      ),
                    ),
                  )
                : Icon(Icons.school, color: Colors.white, size: 50.sp),
          ),
          SizedBox(height: 20.h),

          // Tên trường
          Text(
            school.name ?? 'Chưa có tên',
            style: TextStyle(
              fontSize: 24.sp,
              fontFamily: "PlayfairDisplay",
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),

          // Mã trường
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              school.code ?? 'N/A',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
