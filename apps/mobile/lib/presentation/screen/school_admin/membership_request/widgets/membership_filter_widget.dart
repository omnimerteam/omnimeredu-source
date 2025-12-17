import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/utils/display_mapper.dart';
import '../../../../common/widgets/button/app_button.dart';

class MembershipFilterWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilter;
  final Function(Map<String, dynamic>) onFilterChanged;

  const MembershipFilterWidget({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  State<MembershipFilterWidget> createState() => _MembershipFilterWidgetState();
}

class _MembershipFilterWidgetState extends State<MembershipFilterWidget> {
  late Map<String, dynamic> _filterData;

  @override
  void initState() {
    super.initState();
    _filterData = Map.from(widget.currentFilter);
  }

  @override
  void didUpdateWidget(MembershipFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentFilter != oldWidget.currentFilter) {
      _filterData = Map.from(widget.currentFilter);
    }
  }

  bool get _hasActiveFilters {
    return _filterData.isNotEmpty;
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return _FilterBottomSheetContent(
          currentFilter: _filterData,
          onApply: (newFilter) {
            setState(() {
              _filterData = Map.from(newFilter);
            });
            widget.onFilterChanged(_filterData);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Bộ lọc',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),

        // Button mở BottomSheet
        OutlinedButton(
          onPressed: _showFilterBottomSheet,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // shrink to fit
            children: [
              Icon(
                _hasActiveFilters
                    ? Icons.filter_alt_rounded
                    : Icons.filter_alt_outlined,
                color: _hasActiveFilters ? theme.colorScheme.primary : null,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                _hasActiveFilters
                    ? 'Đã lọc (${_filterData.length})'
                    : 'Chọn bộ lọc',
                style: TextStyle(
                  fontWeight: _hasActiveFilters ? FontWeight.w600 : null,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Content thật sự hiển thị trong bottom sheet
class _FilterBottomSheetContent extends StatefulWidget {
  final Map<String, dynamic> currentFilter;
  final ValueChanged<Map<String, dynamic>> onApply;

  const _FilterBottomSheetContent({
    required this.currentFilter,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheetContent> createState() =>
      _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<_FilterBottomSheetContent> {
  late Map<String, dynamic> _tempFilterData;

  static const Map<String, String> roleOptions = {
    'Student': 'Học sinh',
    'Teacher': 'Giáo viên',
    'Staff': 'Nhân viên',
    'SchoolAdmin': 'Quản trị viên',
  };

  @override
  void initState() {
    super.initState();
    _tempFilterData = Map<String, dynamic>.from(widget.currentFilter);
  }

  void _clearFilters() {
    setState(() {
      _tempFilterData.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 20.sp,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Chọn bộ lọc',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Filter sections
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterSection(
                      context,
                      'Vai trò',
                      'role',
                      roleOptions,
                    ),
                    SizedBox(height: 20.h),
                    _buildFilterSection(
                      context,
                      'Hành động',
                      'action',
                      DisplayMapper.membershipActions,
                    ),
                    SizedBox(height: 20.h),
                    _buildFilterSection(
                      context,
                      'Trạng thái',
                      'status',
                      DisplayMapper.membershipStatuses,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppButton(
                    onPressed: _clearFilters,
                    text: 'Xóa bộ lọc',
                    type: AppButtonType.danger,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 3,
                  child: AppButton(
                    onPressed: () {
                      widget.onApply(_tempFilterData);
                      Navigator.pop(context);
                    },
                    text: 'Xác nhận',
                    type: AppButtonType.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    String title,
    String filterKey,
    Map<String, String> options,
  ) {
    final theme = Theme.of(context);

    // Luôn đảm bảo là List<String>
    if (_tempFilterData[filterKey] is! List<String>) {
      _tempFilterData[filterKey] = <String>[];
    }

    final selectedValues = List<String>.from(_tempFilterData[filterKey]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 4.h,
          children: options.entries.map((entry) {
            final isSelected = selectedValues.contains(entry.key);

            return FilterChip(
              label: Text(
                entry.value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedValues.add(entry.key);
                  } else {
                    selectedValues.remove(entry.key);
                  }
                  _tempFilterData[filterKey] = selectedValues;
                });
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: theme.colorScheme.primary,
              checkmarkColor: theme.colorScheme.onPrimary,
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
