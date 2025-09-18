import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_select_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';

class GradeFilterBottomSheet extends StatefulWidget {
  final List<GradeSelectEntity> grades;
  final List<String> currentSelected;

  const GradeFilterBottomSheet({
    super.key,
    required this.grades,
    required this.currentSelected,
  });

  @override
  State<GradeFilterBottomSheet> createState() => _GradeFilterBottomSheetState();
}

class _GradeFilterBottomSheetState extends State<GradeFilterBottomSheet> {
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List<String>.from(widget.currentSelected);
  }

  void _toggle(String id, bool? checked) {
    setState(() {
      if (checked == true) {
        _tempSelected.add(id);
      } else {
        _tempSelected.remove(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  'Chọn khối',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Danh sách khối
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.grades.length,
                itemBuilder: (context, index) {
                  final grade = widget.grades[index];
                  final selected = _tempSelected.contains(grade.id);

                  return InkWell(
                    onTap: () => _toggle(grade.id, !selected),
                    child: Row(
                      children: [
                        Checkbox(
                          value: selected,
                          activeColor: theme.colorScheme.primary,
                          onChanged: (checked) => _toggle(grade.id, checked),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            grade.name,
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
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: 'Xác nhận',
                    type: AppButtonType.primary,
                    onPressed: () {
                      Navigator.pop(context, _tempSelected);
                    },
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
