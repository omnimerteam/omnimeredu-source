import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/sort_util.dart';
import '../../../../widgets/sort/multi_sort_bottom_sheet.dart';
import '../bloc/grade_management_bloc.dart';
import '../bloc/grade_management_event.dart';
import '../bloc/grade_management_state.dart';

class GradeSortControls extends StatelessWidget {
  const GradeSortControls({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<GradeManagementBloc, GradeManagementState>(
      builder: (context, state) {
        if (state is! GradeManagementLoaded) {
          return const SizedBox.shrink();
        }

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
                      sortOptions: SortUtils.gradeSortOptions,
                      onApply: (newSort) {
                        if (newSort.isNotEmpty) {
                          context.read<GradeManagementBloc>().add(
                            SortGradesEvent(newSort),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
