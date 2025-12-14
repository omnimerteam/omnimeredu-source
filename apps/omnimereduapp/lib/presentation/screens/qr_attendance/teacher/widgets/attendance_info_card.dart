import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Widget hiển thị thông tin buổi học
class AttendanceInfoCard extends StatelessWidget {
  final String className;
  final String? subject;
  final DateTime date;

  const AttendanceInfoCard({
    Key? key,
    required this.className,
    this.subject,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.grey700 : AppColors.grey300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            context,
            icon: Icons.class_,
            label: 'Lớp',
            value: className,
          ),
          if (subject != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.book,
              label: 'Môn học',
              value: subject!,
            ),
          ],
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            icon: Icons.calendar_today,
            label: 'Ngày',
            value: _formatDate(date),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;

    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textColor.withOpacity(0.7),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

