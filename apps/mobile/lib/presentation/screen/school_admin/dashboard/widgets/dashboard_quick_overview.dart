import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../domain/entities/dashboard/school_admin/dashboard_overview_entity.dart';
import '../../../../common/widgets/card/stat_card.dart';

class DashboardQuickOverview extends StatelessWidget {
  final DashboardOverviewEntity overview;

  const DashboardQuickOverview({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tổng quan hệ thống',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
        ),
        SizedBox(height: 16.h),
        // Row 1: Students & Teachers
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
              child: StatCard(
                title: 'Giáo viên',
                value: overview.totalTeachers.toString(),
                icon: Icons.school,
                color: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Row 2: Staff & Classes
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Nhân viên',
                value: overview.totalStaff.toString(),
                icon: Icons.badge,
                color: Colors.teal,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                title: 'Lớp học',
                value: overview.totalClasses.toString(),
                icon: Icons.class_,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Row 3: Requests
        StatCard(
          title: 'Yêu cầu tham gia',
          value: overview.membershipRequests.toString(),
          icon: Icons.person_add,
          color: Colors.purple,
        ),
      ],
    );
  }
}
