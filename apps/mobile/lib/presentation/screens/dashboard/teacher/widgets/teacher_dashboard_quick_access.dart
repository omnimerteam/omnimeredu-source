import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/under_development_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/quick_access_button.dart';

class TeacherDashboardQuickAccess extends StatelessWidget {
  const TeacherDashboardQuickAccess({super.key});

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
            QuickAccessButton(
              title: 'Lớp',
              icon: Icons.class_,
              color: Colors.orange,
              onTap: () =>
                  Navigator.of(context).pushNamed('/school-admin/classes'),
            ),
            QuickAccessButton(
              title: 'Học sinh',
              icon: Icons.people,
              color: Colors.blue,
              onTap: () =>
                  Navigator.of(context).pushNamed('/school-admin/students'),
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
