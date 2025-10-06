import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_state.dart';

import 'package:flutter_ios_android_platforms/presentation/widgets/sort/multi_sort_bottom_sheet.dart';
//import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/search_text_field.dart';
import 'package:intl/intl.dart';

class AttendanceFilterControl extends StatefulWidget {
  const AttendanceFilterControl({super.key});

  @override
  State<AttendanceFilterControl> createState() =>
      _AttendanceFilterControlState();
}

class _AttendanceFilterControlState extends State<AttendanceFilterControl> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  DateTime? _selectedDate;

  // Các tùy chọn sắp xếp cho điểm danh
  static const Map<Map<String, String>, String> _attendanceSortOptions = {
    {'date': 'desc'}: 'Ngày mới nhất',
    {'date': 'asc'}: 'Ngày cũ nhất',
  };

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

  // void _onSearchSubmitted(String value) {
  //   context.read<AttendanceManagementBloc>().add(SearchAttendancesEvent(value));
  // }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _applyFilter();
    }
  }

  void _clearDate() {
    setState(() {
      _selectedDate = null;
    });
    _applyFilter();
  }

  void _applyFilter() {
    final filter = <String, dynamic>{};
    if (_selectedDate != null) {
      filter['date'] = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
    context.read<AttendanceManagementBloc>().add(
      FilterAttendancesEvent(filter),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AttendanceManagementBloc, AttendanceManagementState>(
      builder: (context, state) {
        if (state is! AttendanceManagementLoaded) {
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

              // Search bar
              // SearchTextField(
              //   controller: _searchController,
              //   focusNode: _searchFocusNode,
              //   hintText: 'Tìm kiếm theo tên lớp...',
              //   isFocused: _searchFocusNode.hasFocus,
              //   onFieldSubmitted: _onSearchSubmitted,
              //   suffixIcon: _searchController.text.isNotEmpty
              //       ? IconButton(
              //           icon: const Icon(Icons.clear),
              //           onPressed: () {
              //             _searchController.clear();
              //             _onSearchSubmitted('');
              //           },
              //         )
              //       : null,
              // ),
              const SizedBox(height: 16),

              // Date Filter
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedDate != null
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withOpacity(0.3),
                      width: _selectedDate != null ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_outlined,
                        size: 20,
                        color: _selectedDate != null
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? 'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'
                              : 'Chọn ngày để lọc',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _selectedDate != null
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: _selectedDate != null
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (_selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: _clearDate,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Sort Button
              MultiSortBottomSheet(
                currentSort: currentSort,
                sortOptions: _attendanceSortOptions,
                onApply: (selected) {
                  context.read<AttendanceManagementBloc>().add(
                    SortAttendancesEvent(selected),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
