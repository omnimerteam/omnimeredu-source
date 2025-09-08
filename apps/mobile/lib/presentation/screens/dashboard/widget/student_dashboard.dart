import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/widget/progress_item.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/widget/schedule_item.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text/section_title.dart';

class StudentDashboard extends StatelessWidget {
  final AuthUserEntity user;

  const StudentDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Học tập hôm nay'),
        const SizedBox(height: 12),
        _buildStudyProgressCard(context),
        const SizedBox(height: 20),
        SectionTitle(title: 'Lịch học hôm nay'),
        const SizedBox(height: 12),
        _buildScheduleCard(context),
      ],
    );
  }

  Widget _buildStudyProgressCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProgressItem(
              title: 'Bài tập Toán',
              progress: 0.8,
              color: AppColors.blue,
            ),
            ProgressItem(
              title: 'Bài tập Văn',
              progress: 0.6,
              color: Colors.green,
            ),
            ProgressItem(
              title: 'Bài tập Tiếng Anh',
              progress: 0.4,
              color: Colors.orange,
            ),
            ProgressItem(
              title: 'Bài tập Vật lý',
              progress: 0.9,
              color: Colors.purple,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ScheduleItem(time: '08:00', subject: 'Toán học', room: 'Phòng 101'),
            ScheduleItem(time: '09:00', subject: 'Ngữ văn', room: 'Phòng 102'),
            ScheduleItem(
              time: '10:00',
              subject: 'Tiếng Anh',
              room: 'Phòng 103',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}
