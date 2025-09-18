import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/utils/sort_util.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/filter/grade_filter.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/sort/multi_sort_bottom_sheet.dart';
import '../bloc/class_management_bloc.dart';
import '../bloc/class_management_event.dart';
import '../bloc/class_management_state.dart';

class ClassSortControls extends StatelessWidget {
  const ClassSortControls({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ClassManagementBloc, ClassManagementState>(
      builder: (context, state) {
        if (state is! ClassManagementLoaded) {
          return const SizedBox.shrink();
        }

        // Lấy sort hiện tại từ state
        final currentSort = state.currentQuery.sort;
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bộ lọc & Sắp xếp',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MultiSortBottomSheet(
                      currentSort: currentSort,
                      sortOptions: SortUtils.classSortOptions,
                      onApply: (selected) {
                        context.read<ClassManagementBloc>().add(
                          SortClassesEvent(selected),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: GradeFilterWidget()),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
