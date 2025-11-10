import 'package:flutter/material.dart';
import '../../../../domain/entities/view_model/class_detail_view_entity.dart';

class ClassInfoCard extends StatelessWidget {
  final ClassDetailViewEntity classDetail;

  const ClassInfoCard({super.key, required this.classDetail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // School Info
            if (classDetail.school != null) ...[
              _buildSectionTitle(
                'Trường',
                Icons.school,
                theme: theme,
                level: classDetail.school?.level.displayName,
              ),
              const SizedBox(height: 8),
              Text(
                '${classDetail.school!.name} - ${classDetail.school!.code}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Grade Info
            if (classDetail.grade != null) ...[
              Row(
                children: [
                  _buildSectionTitle(
                    'Khối',
                    Icons.grade,
                    theme: theme,
                    level: classDetail.grade?.gradeGroup.displayName,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    classDetail.grade!.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Base Fee
            if (classDetail.baseFee != null) ...[
              Row(
                children: [
                  _buildSectionTitle('Học phí cơ bản', Icons.attach_money),

                  const SizedBox(width: 10),
                  Text(
                    '${_formatCurrency(classDetail.baseFee!)} VNĐ',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Teachers
            if (classDetail.teachers != null &&
                classDetail.teachers!.isNotEmpty) ...[
              _buildSectionTitle('Giáo viên', Icons.person),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: classDetail.teachers!.map((teacher) {
                  return _buildTeacherChip(teacher, theme);
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    IconData icon, {
    ThemeData? theme,
    String? level,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),

        if (level != null && theme != null) ...[
          SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              level,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        const SizedBox(width: 4),
        Text(
          ":",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTeacherChip(TeacherClassDetailEntity teacher, ThemeData theme) {
    final bool isMain = teacher.isMain;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isMain ? Colors.green.withOpacity(0.15) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          Text(
            teacher.fullName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isMain ? Colors.green.shade700 : Colors.grey.shade800,
            ),
          ),
          if (teacher.subject != null)
            Text(
              '- ${teacher.subject?.displayName}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isMain ? Colors.green.shade600 : Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
