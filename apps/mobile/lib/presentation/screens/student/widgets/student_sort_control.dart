import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/filter/student_filter_widgter.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/sort/multi_sort_bottom_sheet.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/search_text_field.dart';
import '../bloc/student_management_bloc.dart';
import '../bloc/student_management_event.dart';
import '../bloc/student_management_state.dart';

class StudentSortControls extends StatefulWidget {
  const StudentSortControls({super.key});

  @override
  State<StudentSortControls> createState() => _StudentSortControlsState();
}

class _StudentSortControlsState extends State<StudentSortControls> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) {
    context.read<StudentManagementBloc>().add(SearchStudentsEvent(value));
  }

  // Các tùy chọn sắp xếp cho học sinh
  static const Map<Map<String, String>, String> _studentSortOptions = {
    {'name': 'asc'}: 'Tên từ A-Z',
    {'name': 'desc'}: 'Tên từ Z-A',
    {'birthday': 'asc'}: 'Ngày sinh tăng dần',
    {'birthday': 'desc'}: 'Ngày sinh giảm dần',
    {'grade': 'asc'}: 'Khối lớp tăng dần',
    {'grade': 'desc'}: 'Khối lớp giảm dần',
    {'educationLevel': 'asc'}: 'Cấp học tăng dần',
    {'educationLevel': 'desc'}: 'Cấp học giảm dần',
    {'createdAt': 'desc'}: 'Mới tạo nhất',
    {'createdAt': 'asc'}: 'Cũ nhất',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<StudentManagementBloc, StudentManagementState>(
      builder: (context, state) {
        if (state is! StudentManagementLoaded) {
          return const SizedBox.shrink();
        }

        // Sort hiện tại từ state
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

              // Search bar
              SearchTextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hintText: 'Tìm kiếm theo tên học sinh...',
                isFocused: _searchFocusNode.hasFocus,
                onFieldSubmitted: _onSearchSubmitted,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchSubmitted('');
                        },
                      )
                    : null,
              ),

              const SizedBox(height: 16),

              // Sort + Filter
              Row(
                children: [
                  Expanded(
                    child: MultiSortBottomSheet(
                      currentSort: currentSort,
                      sortOptions: _studentSortOptions,
                      onApply: (selected) {
                        context.read<StudentManagementBloc>().add(
                          SortStudentsEvent(selected),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StudentFilterControls(
                      currentFilter: state.currentQuery.filter,
                      onFilterChanged: (filter) {
                        context.read<StudentManagementBloc>().add(
                          FilterStudentsEvent(filter),
                        );
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
