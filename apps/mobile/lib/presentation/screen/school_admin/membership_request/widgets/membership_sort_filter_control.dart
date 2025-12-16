import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/membership_request_bloc.dart';
import '../bloc/membership_request_event.dart';
import '../bloc/membership_request_state.dart';
import 'membership_filter_widget.dart';
import '../../../../common/widgets/sort/multi_sort_bottom_sheet.dart';

class MembershipSortFilterControl extends StatelessWidget {
  final MembershipRequestState state;
  final Map<Map<String, String>, String> sortOptions;

  const MembershipSortFilterControl({
    super.key,
    required this.state,
    required this.sortOptions,
  });

  void _onFilterChanged(BuildContext context, Map<String, dynamic> filter) {
    context.read<MembershipRequestBloc>().add(
      FilterMembershipRequestsEvent(filter),
    );
  }

  void _onSortChanged(BuildContext context, Map<String, String> sort) {
    context.read<MembershipRequestBloc>().add(
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
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
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
                size: 20.sp,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Bộ lọc & Sắp xếp',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: MembershipFilterWidget(
                  currentFilter: currentFilter,
                  onFilterChanged: (f) => _onFilterChanged(context, f),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sắp xếp',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    MultiSortBottomSheet(
                      currentSort: currentSort,
                      sortOptions: sortOptions,
                      onApply: (List<Map<String, String>> newSort) {
                        if (newSort.isNotEmpty) {
                          _onSortChanged(context, newSort.first);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
