import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'personnel_filter_controls.dart';
import '../../../../widgets/sort/multi_sort_bottom_sheet.dart';
import '../../../../widgets/text_field/search_text_field.dart';
import '../bloc/personnel_management_bloc.dart';
import '../bloc/personnel_management_event.dart';
import '../bloc/personnel_management_state.dart';

class PersonnelSortControls extends StatefulWidget {
  const PersonnelSortControls({super.key});

  @override
  State<PersonnelSortControls> createState() => _PersonnelSortControlsState();
}

class _PersonnelSortControlsState extends State<PersonnelSortControls> {
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
    context.read<PersonnelManagementBloc>().add(SearchPersonnelEvent(value));
  }

  // Các tùy chọn sắp xếp cho nhân sự
  static const Map<Map<String, String>, String> _personnelSortOptions = {
    {'fullName': 'asc'}: 'Tên từ A-Z',
    {'fullName': 'desc'}: 'Tên từ Z-A',
    {'birthday': 'asc'}: 'Ngày sinh tăng dần',
    {'birthday': 'desc'}: 'Ngày sinh giảm dần',
    {'createdAt': 'desc'}: 'Mới tạo nhất',
    {'createdAt': 'asc'}: 'Cũ nhất',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PersonnelManagementBloc, PersonnelManagementState>(
      builder: (context, state) {
        if (state is! PersonnelManagementLoaded) {
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
                hintText: 'Tìm kiếm theo tên nhân sự...',
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
                      sortOptions: _personnelSortOptions,
                      onApply: (selected) {
                        context.read<PersonnelManagementBloc>().add(
                          SortPersonnelEvent(selected),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PersonnelFilterControls(
                      currentFilter: state.currentQuery.filter,
                      onFilterChanged: (filter) {
                        context.read<PersonnelManagementBloc>().add(
                          FilterPersonnelEvent(filter),
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
