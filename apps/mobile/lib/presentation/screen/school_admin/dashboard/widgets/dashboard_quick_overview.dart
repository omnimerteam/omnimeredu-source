import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../domain/entities/dashboard/school_admin/dashboard_overview_entity.dart';
import '../../../../common/widgets/card/stat_card.dart';

class DashboardQuickOverview extends StatelessWidget {
  final DashboardOverviewEntity overview;

  const DashboardQuickOverview({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng quan hệ thống',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Học sinh',
                    value: overview.totalStudents.toString(),
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.school,
                                  color: Colors.green,
                                  size: 28.w,
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  overview.totalTeachers.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 24.sp,
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.badge,
                                  color: Colors.green,
                                  size: 28.w,
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  overview.totalStaff.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 24.sp,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Nhân sự",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Lớp học',
                    value: overview.totalClasses.toString(),
                    icon: Icons.class_,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: StatCard(
                    title: 'Yêu cầu tham gia',
                    value: overview.membershipRequests.toString(),
                    icon: Icons.person_add,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
