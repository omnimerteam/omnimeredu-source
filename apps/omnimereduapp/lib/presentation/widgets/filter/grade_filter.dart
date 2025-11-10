import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens/common/grade_select/cubit/grade_select_cubit.dart';
import '../../screens/common/grade_select/cubit/grade_select_state.dart';
import '../../screens/school_admin/class/bloc/class_management_bloc.dart';
import '../../screens/school_admin/class/bloc/class_management_event.dart';
import '../../screens/school_admin/class/bloc/class_management_state.dart';
import 'grade_filter_bottom_sheet.dart';

class GradeFilterWidget extends StatelessWidget {
  final double? width;
  final EdgeInsetsGeometry? padding;

  const GradeFilterWidget({
    super.key,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lọc theo khối',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        // Nội dung filter
        BlocBuilder<GradeSelectCubit, GradeSelectState>(
          builder: (context, gradeState) {
            return BlocBuilder<ClassManagementBloc, ClassManagementState>(
              builder: (context, classState) {
                if (classState is! ClassManagementLoaded) {
                  return const SizedBox.shrink();
                }

                if (gradeState is GradeSelectLoading) {
                  return _buildContainer(
                    theme,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Đang tải...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (gradeState is GradeSelectError) {
                  return _buildContainer(
                    theme,
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 16,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Lỗi tải khối lớp',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (gradeState is GradeSelectSuccess) {
                  final currentFilters =
                      (classState.currentQuery.filter['gradeId'] as List?)
                          ?.cast<String>() ??
                      [];

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final selected = await showModalBottomSheet<List<String>>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => GradeFilterBottomSheet(
                          grades: gradeState.grades,
                          currentSelected: currentFilters,
                        ),
                      );

                      if (selected != null) {
                        final newFilter = Map<String, dynamic>.from(
                          classState.currentQuery.filter,
                        );
                        if (selected.isEmpty) {
                          newFilter.remove('gradeId');
                        } else {
                          newFilter['gradeId'] = selected;
                        }

                        context.read<ClassManagementBloc>().add(
                          FilterClassesEvent(newFilter),
                        );
                      }
                    },
                    child: _buildContainer(
                      theme,
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_alt_rounded,
                            size: 18,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              currentFilters.isEmpty
                                  ? 'Chọn khối'
                                  : 'Đã chọn (${currentFilters.length})',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildContainer(ThemeData theme, {required Widget child}) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: child,
      ),
    );
  }
}
