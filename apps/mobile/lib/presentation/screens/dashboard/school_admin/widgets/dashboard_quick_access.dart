import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/quick_access_button.dart';

class DashboardQuickAccess extends StatelessWidget {
  final bool highlightSchool;
  const DashboardQuickAccess({Key? key, this.highlightSchool = false})
    : super(key: key);

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
                onTap: () {
                  Navigator.of(context).pushNamed('/school-admin/school');
                },
              ),
            ),
            QuickAccessButton(
              title: 'Lớp',
              icon: Icons.class_,
              color: Colors.orange,
              onTap: () {
                Navigator.of(context).pushNamed('/school-admin/classes');
              },
            ),
            QuickAccessButton(
              title: 'Yêu cầu',
              icon: Icons.person_add,
              color: Colors.purple,
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamed('/school-admin/membership-requests');
              },
            ),
            QuickAccessButton(
              title: 'Học sinh',
              icon: Icons.people,
              color: Colors.blue,
              onTap: () {},
            ),
            QuickAccessButton(
              title: 'Giáo viên',
              icon: Icons.person,
              color: Colors.green,
              onTap: () {},
            ),
            QuickAccessButton(
              title: 'Điểm danh',
              icon: Icons.fact_check,
              color: Colors.teal,
              onTap: () {},
            ),
            QuickAccessButton(
              title: 'Học phí',
              icon: Icons.payment,
              color: Colors.red,
              onTap: () {},
              badge: '12',
            ),
            // QuickAccessButton(
            //   title: 'Bài viết',
            //   icon: Icons.article,
            //   color: Colors.indigo,
            //   onTap: () {},
            // ),
            // QuickAccessButton(
            //   title: 'Thông báo',
            //   icon: Icons.notifications,
            //   color: Colors.amber,
            //   onTap: () {},
            // ),
            // QuickAccessButton(
            //   title: 'Báo cáo',
            //   icon: Icons.analytics,
            //   color: Colors.purple,
            //   onTap: () {},
            // ),
            // QuickAccessButton(
            //   title: 'Cài đặt',
            //   icon: Icons.settings,
            //   color: Colors.grey,
            //   onTap: () {},
            // ),
          ],
        ),
      ],
    );
  }
}
