import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';

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

  static const Map<String, String> roleOptions = {
    'Student': 'Học sinh',
    'Teacher': 'Giáo viên',
    'Staff': 'Nhân viên',
    'SchoolAdmin': 'Quản trị viên',
  };

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

  void _clearFilters() {
    setState(() {
      _filterData.clear();
    });
    widget.onFilterChanged({});
  }

  void _showFilterDialog() {
    final tempFilterData = Map<String, dynamic>.from(_filterData);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Bộ lọc',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    context,
                    'Vai trò',
                    'role',
                    roleOptions,
                    tempFilterData,
                    setDialogState,
                  ),
                  const SizedBox(height: 20),
                  _buildFilterSection(
                    context,
                    'Hành động',
                    'action',
                    DisplayMapper.membershipActions,
                    tempFilterData,
                    setDialogState,
                  ),
                  const SizedBox(height: 20),
                  _buildFilterSection(
                    context,
                    'Trạng thái',
                    'status',
                    DisplayMapper.membershipStatuses,
                    tempFilterData,
                    setDialogState,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setDialogState(() {
                    tempFilterData.clear();
                  });
                },
                child: Text(
                  'Xóa tất cả',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _filterData = Map.from(tempFilterData);
                  });
                  widget.onFilterChanged(_filterData);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Áp dụng'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    String title,
    String filterKey,
    Map<String, String> options,
    Map<String, dynamic> tempFilterData,
    StateSetter setDialogState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.entries.map((entry) {
            final isSelected = tempFilterData[filterKey] == entry.key;

            return FilterChip(
              label: Text(
                entry.value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setDialogState(() {
                  if (selected) {
                    tempFilterData[filterKey] = entry.key;
                  } else {
                    tempFilterData.remove(filterKey);
                  }
                });
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _hasActiveFilters
              ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: _showFilterDialog,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _hasActiveFilters
                      ? Icons.filter_alt_rounded
                      : Icons.filter_alt_outlined,
                  size: 18,
                  color: _hasActiveFilters
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  _hasActiveFilters
                      ? 'Đã lọc (${_filterData.length})'
                      : 'Bộ lọc',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _hasActiveFilters
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: _hasActiveFilters
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
                if (_hasActiveFilters) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _clearFilters,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
