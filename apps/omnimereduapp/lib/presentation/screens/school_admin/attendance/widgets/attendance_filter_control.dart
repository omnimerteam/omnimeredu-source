import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/bloc/authentication/authentication_bloc.dart';
import '../../../../../core/bloc/authentication/authentication_state.dart';
import 'package:intl/intl.dart';

import '../bloc/attendance_management_bloc.dart';
import '../bloc/attendance_management_event.dart';
import '../bloc/attendance_management_state.dart';

import '../../../common/class_selector/class_selector.dart';
import '../../../../../domain/entities/class/class_search_entity.dart';

import '../../../../widgets/sort/multi_sort_bottom_sheet.dart';

class AttendanceFilterControl extends StatefulWidget {
  const AttendanceFilterControl({super.key});

  @override
  State<AttendanceFilterControl> createState() =>
      _AttendanceFilterControlState();
}

class _AttendanceFilterControlState extends State<AttendanceFilterControl> {
  DateTime? _selectedDate;
  ClassSearchEntity? _selectedClass;

  static const Map<Map<String, String>, String> _attendanceSortOptions = {
    {'date': 'desc'}: 'Ngày mới nhất',
    {'date': 'asc'}: 'Ngày cũ nhất',
  };

  void _applyFilter() {
    final filter = <String, dynamic>{};

    if (_selectedDate != null) {
      filter['date'] = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
    if (_selectedClass != null) {
      filter['classId'] = _selectedClass!.id;
    }

    context.read<AttendanceManagementBloc>().add(
      FilterAttendancesEvent(filter),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _applyFilter();
    }
  }

  void _clearDate() {
    setState(() => _selectedDate = null);
    _applyFilter();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final schoolId = context.select<AuthenticationBloc, String?>((bloc) {
      final state = bloc.state;
      if (state is AuthenticationAuthenticated) {
        return state.user.schoolId;
      }
      return null;
    });

    if (schoolId == null) {
      return const SizedBox.shrink();
    }

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
            borderRadius: BorderRadius.circular(16),
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
              // Header
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

              Text(
                'Lọc theo',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  Expanded(
                    child: ClassSelector(
                      schoolId: schoolId,
                      onClassSelected: (selected) {
                        setState(() => _selectedClass = selected);
                        _applyFilter();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: // --- Date Picker (thiết kế đồng nhất với ClassSelector) ---
                      Container(
                        height: 64,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey[800]
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _selectedDate != null
                                ? theme.colorScheme.primary
                                : (theme.brightness == Brightness.dark
                                      ? Colors.grey[600]!
                                      : const Color(0xFFE2E8F0)),
                            width: _selectedDate != null ? 2 : 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _selectDate(context),
                          child: Row(
                            children: [
                              Icon(
                                Icons.event_outlined,
                                color: _selectedDate != null
                                    ? theme.colorScheme.primary
                                    : (theme.brightness == Brightness.dark
                                          ? Colors.grey[400]
                                          : Colors.grey[600]),
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedDate != null
                                      ? "Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}"
                                      : "Chọn ngày điểm danh",
                                  style: TextStyle(
                                    color: _selectedDate != null
                                        ? theme.colorScheme.onSurface
                                        : (theme.brightness == Brightness.dark
                                              ? Colors.grey[400]
                                              : Colors.grey[600]),
                                    fontSize: 14,
                                    fontWeight: _selectedDate != null
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (_selectedDate != null)
                                IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: _clearDate,
                                  color: theme.colorScheme.primary,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- Sort Bottom Sheet ---
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
