import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/class/widgets/grade_filter.dart';
import '../bloc/class_management_bloc.dart';
import '../bloc/class_management_event.dart';
import '../bloc/class_management_state.dart';

class ClassSortControls extends StatelessWidget {
  const ClassSortControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassManagementBloc, ClassManagementState>(
      builder: (context, state) {
        if (state is! ClassManagementLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row: Sort and Filter
            Row(
              children: [
                // Sort Dropdown
                _buildSortDropdown(context, state),

                const SizedBox(width: 12),

                // Grade Filter
                const GradeFilterWidget(),

                const Spacer(),

                // Create Button
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ClassManagementBloc>().add(
                      ShowCreateFormEvent(),
                    );
                  },
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Tạo lớp mới'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),

            // Show active filters
            if (state.currentFilter.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildActiveFilters(context, state),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSortDropdown(BuildContext context, ClassManagementLoaded state) {
    final currentSortString = _mapToSortString(state.currentSort);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentSortString,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sort,
                  size: 18,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  'Sắp xếp',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          items: [
            _buildSortMenuItem(
              context,
              'name:asc',
              'Tên A-Z',
              Icons.sort_by_alpha,
            ),
            _buildSortMenuItem(
              context,
              'name:desc',
              'Tên Z-A',
              Icons.sort_by_alpha,
            ),
            _buildSortMenuItem(
              context,
              'createdAt:desc',
              'Mới nhất',
              Icons.access_time,
            ),
            _buildSortMenuItem(
              context,
              'createdAt:asc',
              'Cũ nhất',
              Icons.access_time,
            ),
            _buildSortMenuItem(
              context,
              'studentCount:desc',
              'Nhiều học sinh nhất',
              Icons.group,
            ),
            _buildSortMenuItem(
              context,
              'studentCount:asc',
              'Ít học sinh nhất',
              Icons.group,
            ),
          ],
          onChanged: (String? value) {
            if (value != null) {
              final sortMap = _sortStringToMap(value);
              context.read<ClassManagementBloc>().add(
                SortClassesEvent(sortMap),
              );
            }
          },
          dropdownColor: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildSortMenuItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return DropdownMenuItem<String>(
      value: value,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  String _mapToSortString(Map<String, String> sortMap) {
    if (sortMap.isEmpty) return 'name:asc';
    final entry = sortMap.entries.first;
    return '${entry.key}:${entry.value}';
  }

  Map<String, String> _sortStringToMap(String sortString) {
    final parts = sortString.split(':');
    if (parts.length == 2) {
      return {parts[0]: parts[1]};
    }
    return {'name': 'asc'};
  }

  Widget _buildActiveFilters(
    BuildContext context,
    ClassManagementLoaded state,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: state.currentFilter.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.filter_alt,
                size: 14,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 4),
              Text(
                '${entry.key}: ${entry.value}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  final newFilter = Map<String, dynamic>.from(
                    state.currentFilter,
                  );
                  newFilter.remove(entry.key);
                  context.read<ClassManagementBloc>().add(
                    FilterClassesEvent(newFilter),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 12,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
