import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../button/app_button.dart';

class MultiSortBottomSheet extends StatelessWidget {
  final List<Map<String, String>> currentSort;
  final Map<Map<String, String>, String> sortOptions;
  final ValueChanged<List<Map<String, String>>> onApply;

  const MultiSortBottomSheet({
    super.key,
    required this.currentSort,
    required this.sortOptions,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Sắp xếp theo',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),

        // Button mở BottomSheet
        OutlinedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              builder: (_) {
                return _BottomSheetContent(
                  currentSort: currentSort,
                  sortOptions: sortOptions,
                  onApply: onApply,
                );
              },
            );
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.sort_rounded, size: 24.sp),
              SizedBox(width: 8.w),
              const Text('Chọn sắp xếp'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Content thật sự hiển thị trong bottom sheet
class _BottomSheetContent extends StatefulWidget {
  final List<Map<String, String>> currentSort;
  final Map<Map<String, String>, String> sortOptions;
  final ValueChanged<List<Map<String, String>>> onApply;

  const _BottomSheetContent({
    required this.currentSort,
    required this.sortOptions,
    required this.onApply,
  });

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  late List<Map<String, String>> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List<Map<String, String>>.from(widget.currentSort);
  }

  void _toggle(Map<String, String> option, bool? checked) {
    setState(() {
      if (checked == true) {
        if (!_tempSelected.any((m) => mapEquals(m, option))) {
          _tempSelected.add(option);
        }
      } else {
        _tempSelected.removeWhere((m) => mapEquals(m, option));
      }
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
                  Icons.sort_rounded,
                  size: 20.sp,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Chọn tiêu chí sắp xếp',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Danh sách checkbox
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.sortOptions.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  thickness: 0.5,
                  color: theme.dividerColor.withOpacity(0.4),
                ),
                itemBuilder: (context, index) {
                  final entry = widget.sortOptions.entries.elementAt(index);
                  final selected = _tempSelected.any(
                    (m) => mapEquals(m, entry.key),
                  );

                  return InkWell(
                    onTap: () => _toggle(entry.key, !selected),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 4.w,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: selected,
                            activeColor: theme.colorScheme.primary,
                            onChanged: (checked) => _toggle(entry.key, checked),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: selected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            // Nút hành động
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'Hủy',
                    type: AppButtonType.cancel,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      widget.onApply(_tempSelected);
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
}
