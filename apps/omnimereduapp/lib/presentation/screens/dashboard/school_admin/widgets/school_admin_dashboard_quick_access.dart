import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../common/under_development_screen.dart';
import '../../../../widgets/button/quick_access_button.dart';

class SchoolAdminDashboardQuickAccess extends StatelessWidget {
  final bool highlightSchool;

  const SchoolAdminDashboardQuickAccess({
    super.key,
    this.highlightSchool = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Truy cập nhanh',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            DecoratedBox(
              decoration: highlightSchool
                  ? BoxDecoration(
                      border: Border.all(color: Colors.redAccent, width: 3),
                      borderRadius: BorderRadius.circular(16),
                    )
                  : const BoxDecoration(),
              child: QuickAccessButton(
                title: 'Trường',
                icon: Icons.school,
                color: AppColors.primary,
                onTap: () =>
                    Navigator.of(context).pushNamed('/school-admin/school'),
              ),
            ),
            QuickAccessButton(
              title: 'Khối',
              icon: Icons.roofing,
              color: Colors.cyan,
              onTap: () =>
                  Navigator.of(context).pushNamed('/school-admin/grades'),
            ),
            QuickAccessButton(
              title: 'Lớp',
              icon: Icons.class_,
              color: Colors.orange,
              onTap: () =>
                  Navigator.of(context).pushNamed('/school-admin/classes'),
            ),
            QuickAccessButton(
              title: 'Yêu cầu',
              icon: Icons.person_add,
              color: Colors.purple,
              onTap: () => Navigator.of(
                context,
              ).pushNamed('/school-admin/membership-requests'),
            ),
            QuickAccessButton(
              title: 'Học sinh',
              icon: Icons.people,
              color: Colors.blue,
              onTap: () =>
                  Navigator.of(context).pushNamed('/school-admin/students'),
            ),
            QuickAccessButton(
              title: 'Nhân sự',
              icon: Icons.person,
              color: Colors.green,
              onTap: () =>
                  Navigator.of(context).pushNamed('/school-admin/personnel'),
            ),
            QuickAccessButton(
              title: 'Điểm danh',
              icon: Icons.fact_check,
              color: Colors.teal,
              onTap: () =>
                  Navigator.of(context).pushNamed('/school-admin/attendance'),
            ),
            QuickAccessButton(
              title: 'Học phí',
              icon: Icons.payment,
              color: Colors.red,
              badge: '12',
              onTap: () =>
                  Navigator.of(context).pushNamed('/school-admin/tuition'),
            ),
            QuickAccessButton(
              title: 'Bài viết',
              icon: Icons.article,
              color: Colors.indigo,
              onTap: () => _navigateToFeature(
                context,
                'Bài viết',
                DateTime(2026, 2, 15),
              ),
            ),
            QuickAccessButton(
              title: 'Thông báo',
              icon: Icons.notifications,
              color: Colors.amber,
              onTap: () => _navigateToFeature(
                context,
                'Thông báo',
                DateTime(2026, 3, 1),
              ),
            ),
            QuickAccessButton(
              title: 'Báo cáo',
              icon: Icons.analytics,
              color: Colors.purple,
              onTap: () =>
                  _navigateToFeature(context, 'Báo cáo', DateTime(2026, 3, 15)),
            ),
            QuickAccessButton(
              title: 'Cài đặt',
              icon: Icons.settings,
              color: Colors.grey,
              onTap: () =>
                  _navigateToFeature(context, 'Cài đặt', DateTime(2026, 4, 1)),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToFeature(
    BuildContext context,
    String featureName,
    DateTime expectedReleaseDate,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UnderDevelopmentScreen(
          featureName: featureName,
          expectedReleaseDate: expectedReleaseDate,
        ),
      ),
    );
  }
}
