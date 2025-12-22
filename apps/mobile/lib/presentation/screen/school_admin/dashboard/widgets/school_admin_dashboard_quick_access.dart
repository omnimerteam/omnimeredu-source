import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/routing/route_config.dart';
import '../../../../common/widgets/button/quick_access_button.dart';

class SchoolAdminDashboardQuickAccess extends StatelessWidget {
  final bool highlightSchool;

  const SchoolAdminDashboardQuickAccess({
    super.key,
    this.highlightSchool = false,
  });

  @override
  Widget build(BuildContext context) {
    // Note: AppColors usage assumes it works similar to old app. 
    // If AppColors is not exported or has different members, might need adjustment.
    // 'mobile/lib/core/theme/app_colors.dart' exists.
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Truy cập nhanh',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 16.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1.1,
          children: [
            DecoratedBox(
              decoration: highlightSchool
                  ? BoxDecoration(
                      border: Border.all(color: AppColors.error, width: 3.w),
                      borderRadius: BorderRadius.circular(16.r),
                    )
                  : const BoxDecoration(),
              child: QuickAccessButton(
                title: 'Trường',
                icon: Icons.school,
                color: AppColors.blue,
                onTap: () => Navigator.of(context)
                    .pushNamed(RouteConfig.schoolAdminSchool),
              ),
            ),
            QuickAccessButton(
              title: 'Khối',
              icon: Icons.roofing,
              color: Colors.cyan,
              onTap: () => Navigator.of(context)
                  .pushNamed(RouteConfig.schoolAdminGrades),
            ),
            QuickAccessButton(
              title: 'Lớp',
              icon: Icons.class_,
              color: AppColors.warning,
              onTap: () => Navigator.of(context)
                  .pushNamed(RouteConfig.schoolAdminClasses),
            ),
            QuickAccessButton(
              title: 'Yêu cầu',
              icon: Icons.person_add,
              color: AppColors.adminColor,
              onTap: () => Navigator.of(context)
                  .pushNamed(RouteConfig.schoolAdminMembershipRequests),
            ),
            QuickAccessButton(
              title: 'Học sinh',
              icon: Icons.people,
              color: AppColors.studentColor,
              onTap: () => Navigator.of(context)
                  .pushNamed(RouteConfig.schoolAdminStudents),
            ),
            QuickAccessButton(
              title: 'Nhân sự',
              icon: Icons.person,
              color: AppColors.success,
              onTap: () => Navigator.of(context)
                  .pushNamed(RouteConfig.schoolAdminPersonnel),
            ),
            QuickAccessButton(
              title: 'Điểm danh',
              icon: Icons.fact_check,
              color: Colors.teal,
              onTap: () => Navigator.of(context)
                  .pushNamed(RouteConfig.schoolAdminAttendance),
            ),
            QuickAccessButton(
              title: 'Học phí',
              icon: Icons.payment,
              color: AppColors.red,
              badge: '12',
              onTap: () => Navigator.of(context)
                  .pushNamed(RouteConfig.schoolAdminTuition),
            ),
          ],
        ),
      ],
    );
  }
}
