import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../domain/entities/user/student_selector_entity.dart';
import '../bloc/class_member_bloc.dart';
import '../bloc/class_member_event.dart';
import '../../../../utils/display_mapper.dart';

class ClassMemberStudentTable extends StatelessWidget {
  final List<StudentSelectorEntity> students;
  final Set<String> selectedIds;

  const ClassMemberStudentTable({
    super.key,
    required this.students,
    required this.selectedIds,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: theme.cardTheme.elevation ?? 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sách học sinh',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Checkbox(
                  value: _isAllSelected(),
                  onChanged: (_) {
                    context.read<ClassMemberBloc>().add(
                      const ToggleSelectAll(),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text('Chọn tất cả', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),

          /// Table
          if (students.isEmpty)
            _buildEmptyState(theme)
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  _buildHeaderRow(theme),
                  Column(
                    children: students
                        .map((s) => _buildStudentRow(context, s, theme))
                        .toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// ==== Helpers ====

  bool _isAllSelected() {
    final selectable = students
        .where((s) => !s.isVerified || s.classId == null)
        .toList();
    return selectable.isNotEmpty && selectedIds.length == selectable.length;
  }

  Widget _buildHeaderRow(ThemeData theme) {
    final headers = [
      '',
      'Tên học sinh',
      'Giới tính',
      'Lớp hiện tại',
      'Trạng thái',
    ];
    final widths = [50.0, 220.0, 100.0, 160.0, 140.0];

    return Container(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: List.generate(headers.length, (i) {
          return SizedBox(
            width: widths[i],
            child: Text(
              headers[i],
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStudentRow(
    BuildContext context,
    StudentSelectorEntity student,
    ThemeData theme,
  ) {
    final isSelected = selectedIds.contains(student.id);
    final canSelect = !student.isVerified || student.classId == null;

    final cells = [
      Checkbox(
        value: isSelected,
        onChanged: canSelect
            ? (_) => context.read<ClassMemberBloc>().add(
                ToggleStudentSelection(student.id),
              )
            : null,
      ),
      _buildNameCell(student, theme),
      _cellText(DisplayMapper.genderName(student.gender), theme),
      _buildClassCell(student, theme),
      _buildStatusBadge(student.isVerified, theme),
    ];

    final widths = [50.0, 220.0, 100.0, 160.0, 140.0];

    return Container(
      color: students.indexOf(student).isEven
          ? theme.colorScheme.surface.withOpacity(0.3)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: List.generate(cells.length, (i) {
          return SizedBox(width: widths[i], child: cells[i]);
        }),
      ),
    );
  }

  Widget _buildNameCell(StudentSelectorEntity student, ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            student.fullName.isNotEmpty
                ? student.fullName[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            student.fullName,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassCell(StudentSelectorEntity student, ThemeData theme) {
    if (student.className != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          student.className!,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      return Text(
        'Chưa có lớp',
        style: theme.textTheme.bodySmall?.copyWith(
          fontStyle: FontStyle.italic,
          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
        ),
      );
    }
  }

  Widget _buildStatusBadge(bool isVerified, ThemeData theme) {
    final color = isVerified ? AppColors.success : Colors.orange;
    final label = isVerified ? 'Đã xác thực' : 'Chưa xác thực';
    final icon = isVerified ? Icons.check_circle : Icons.pending;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cellText(String text, ThemeData theme) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyMedium,
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: theme.hintColor.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'Không có học sinh nào',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.hintColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Vui lòng chọn lớp để xem danh sách học sinh',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
