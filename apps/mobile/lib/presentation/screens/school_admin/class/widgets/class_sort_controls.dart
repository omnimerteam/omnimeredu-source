// widgets/class_sort_controls.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/app_constants.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dropdown/sort_dropdown.dart';
import '../bloc/class_management_bloc.dart';
import '../bloc/class_management_event.dart';
import '../bloc/class_management_state.dart';

class ClassSortControls extends StatelessWidget {
  const ClassSortControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassManagementBloc, ClassManagementState>(
      builder: (context, state) {
        return Row(
          children: [
            // Sort Dropdown
            SortDropdownWidget(
              currentSort: state.sortString,
              sortOptions: AppConstants.classSortOptions,
              onSortChanged: (String sortString) {
                context.read<ClassManagementBloc>().add(
                  ChangeSortStringEvent(sortString),
                );
              },
              width: 200,
            ),

            const Spacer(), // đẩy nút sang phải
            // Create Button
            ElevatedButton.icon(
              onPressed: () {
                context.read<ClassManagementBloc>().add(ShowCreateFormEvent());
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
        );
      },
    );
  }
}
