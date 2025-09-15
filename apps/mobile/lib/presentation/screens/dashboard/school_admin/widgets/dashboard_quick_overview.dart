import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/dashboard_overview_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/card/stat_card.dart';

class DashboardQuickOverview extends StatelessWidget {
  final DashboardOverviewEntity overview;

  const DashboardQuickOverview({Key? key, required this.overview})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng quan hệ thống',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Học sinh',
                    value: overview.totalStudents.toString(),
                    icon: Icons.people,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Giáo viên',
                    value: overview.totalTeachers.toString(),
                    icon: Icons.person,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                const SizedBox(width: 12),
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
