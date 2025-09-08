import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text/section_title.dart';

class TeacherDashboard extends StatelessWidget {
  final AuthUserEntity user;

  const TeacherDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Lớp học của bạn'),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildClassItem(
                  context,
                  icon: Icons.class_,
                  title: 'Lớp 10A1',
                  subtitle: '32 học sinh',
                  color: AppColors.blue,
                  onTap: () {
                    // Navigate to class details
                  },
                ),
                _buildClassItem(
                  context,
                  icon: Icons.assignment,
                  title: 'Bài tập chưa chấm',
                  subtitle: '15 bài',
                  color: Colors.green,
                  onTap: () {
                    // Navigate to assignments
                  },
                ),
                _buildClassItem(
                  context,
                  icon: Icons.schedule,
                  title: 'Lịch dạy hôm nay',
                  subtitle: '5 tiết',
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to schedule
                  },
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
