import 'package:flutter/material.dart';
import '../../../../domain/entities/view_model/class_detail_view_entity.dart';

class StudentListWidget extends StatelessWidget {
  final List<StudentClassDetailEntity> students;

  const StudentListWidget({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (students.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_off_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Không tìm thấy học sinh',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final student = students[index];
        return _StudentCard(student: student);
      },
    );
  }
}

class _StudentCard extends StatelessWidget {
  final StudentClassDetailEntity student;

  const _StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showStudentDetails(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      _getInitials(student.fullName),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.fullName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (student.gender != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getGenderColor(
                                student.gender!,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              student.gender!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _getGenderColor(student.gender!),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'detail',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 20),
                            SizedBox(width: 8),
                            Text('Chi tiết'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'contact',
                        child: Row(
                          children: [
                            Icon(Icons.phone, size: 20),
                            SizedBox(width: 8),
                            Text('Liên hệ'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'detail') {
                        _showStudentDetails(context);
                      }
                    },
                  ),
                ],
              ),
              if (student.phone != null || student.address != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
              ],
              if (student.phone != null)
                _buildInfoRow(
                  Icons.phone_outlined,
                  'Số điện thoại',
                  student.phone!,
                  theme,
                ),
              if (student.address != null) ...[
                if (student.phone != null) const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.location_on_outlined,
                  'Địa chỉ',
                  student.address!,
                  theme,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  void _showStudentDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return _StudentDetailSheet(
            student: student,
            scrollController: scrollController,
          );
        },
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  Color _getGenderColor(String gender) {
    switch (gender.toLowerCase()) {
      case 'nam':
      case 'male':
        return Colors.blue;
      case 'nữ':
      case 'female':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}

class _StudentDetailSheet extends StatelessWidget {
  final StudentClassDetailEntity student;
  final ScrollController scrollController;

  const _StudentDetailSheet({
    required this.student,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    _getInitials(student.fullName),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                student.fullName,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailItem(
                Icons.person_outline,
                'Giới tính',
                student.gender ?? 'Không xác định',
                theme,
              ),
              if (student.phone != null)
                _buildDetailItem(
                  Icons.phone_outlined,
                  'Số điện thoại',
                  student.phone!,
                  theme,
                ),
              if (student.address != null)
                _buildDetailItem(
                  Icons.location_on_outlined,
                  'Địa chỉ',
                  student.address!,
                  theme,
                ),
              if (student.guardianName != null ||
                  student.guardianPhone != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Thông tin phụ huynh',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (student.guardianName != null)
                  _buildDetailItem(
                    Icons.person_outline,
                    'Tên phụ huynh',
                    student.guardianName!,
                    theme,
                  ),
                if (student.guardianPhone != null)
                  _buildDetailItem(
                    Icons.phone_outlined,
                    'Số điện thoại',
                    student.guardianPhone!,
                    theme,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }
}
