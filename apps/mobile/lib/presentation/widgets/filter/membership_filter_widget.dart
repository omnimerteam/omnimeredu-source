import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';

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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
        const SizedBox(height: 6),

        // Button mở BottomSheet
        OutlinedButton(
          onPressed: _showFilterBottomSheet,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                _hasActiveFilters
                    ? Icons.filter_alt_rounded
                    : Icons.filter_alt_outlined,
                color: _hasActiveFilters ? theme.colorScheme.primary : null,
              ),
              const SizedBox(width: 8),
              Text(
                _hasActiveFilters
                    ? 'Đã lọc (${_filterData.length})'
                    : 'Chọn bộ lọc',
                style: TextStyle(
                  fontWeight: _hasActiveFilters ? FontWeight.w600 : null,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Chọn bộ lọc',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

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
                    const SizedBox(height: 20),
                    _buildFilterSection(
                      context,
                      'Hành động',
                      'action',
                      DisplayMapper.membershipActions,
                    ),
                    const SizedBox(height: 20),
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

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                AppButton(
                  onPressed: _clearFilters,
                  text: 'Xóa bộ lọc',
                  type: AppButtonType.danger,
                  fullWidth: false,
                  width: 150,
                ),
                const SizedBox(width: 12),
                AppButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Hủy',
                  type: AppButtonType.cancel,
                  fullWidth: false,
                  width: 80,
                ),
                const SizedBox(width: 12),
                Expanded(
                  // 👈 chỉ để cái này full width
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
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
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
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
