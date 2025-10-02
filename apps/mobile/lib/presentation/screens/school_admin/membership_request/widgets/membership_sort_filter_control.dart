import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_state.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/filter/membership_filter_widget.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/sort/multi_sort_bottom_sheet.dart';

class MembershipSortFilterControl extends StatelessWidget {
  final MembershipRequestManagementState state;
  final Map<Map<String, String>, String> sortOptions;

  const MembershipSortFilterControl({
    super.key,
    required this.state,
    required this.sortOptions,
  });

  void _onFilterChanged(BuildContext context, Map<String, dynamic> filter) {
    context.read<MembershipRequestManagementBloc>().add(
      FilterMembershipRequestsEvent(filter),
    );
  }

  void _onSortChanged(BuildContext context, Map<String, String> sort) {
    context.read<MembershipRequestManagementBloc>().add(
      SortMembershipRequestsEvent(sort),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Giá trị mặc định
    List<Map<String, String>> currentSort = [];
    Map<String, dynamic> currentFilter = {};

    // Chỉ lấy query khi state là MembershipRequestLoaded
    if (state is MembershipRequestLoaded) {
      final loadedState = state as MembershipRequestLoaded;
      currentSort = loadedState.currentQuery.sort;
      currentFilter = loadedState.currentQuery.filter;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
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
                child: MembershipFilterWidget(
                  currentFilter: currentFilter,
                  onFilterChanged: (f) => _onFilterChanged(context, f),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MultiSortBottomSheet(
                  currentSort: currentSort,
                  sortOptions: sortOptions,
                  onApply: (List<Map<String, String>> newSort) {
                    if (newSort.isNotEmpty) {
                      _onSortChanged(context, newSort.first);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
