import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_state.dart';

class ClassSelectorMulti extends StatefulWidget {
  final String schoolId;
  final EducationGradesEnum? gradeGroup;
  final List<String>? initialClassIds;
  final ValueChanged<List<ClassSearchEntity>> onClassesSelected;
  final String? Function(List<ClassSearchEntity>)? validator;
  final bool autoLoad;
  final String queryString;

  const ClassSelectorMulti({
    super.key,
    required this.schoolId,
    this.gradeGroup,
    this.initialClassIds,
    required this.onClassesSelected,
    this.validator,
    this.autoLoad = true,
    this.queryString = "",
  });

  @override
  State<ClassSelectorMulti> createState() => _ClassSelectorMultiState();
}

class _ClassSelectorMultiState extends State<ClassSelectorMulti> {
  List<ClassSearchEntity> selectedClasses = [];
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoLoad && widget.schoolId.isNotEmpty) {
      context.read<ClassSelectorBloc>().add(
        LoadClassesBySchool(widget.schoolId),
      );
    }
  }

  @override
  void didUpdateWidget(ClassSelectorMulti oldWidget) {
    super.didUpdateWidget(oldWidget);
    final schoolChanged = oldWidget.schoolId != widget.schoolId;
    if (schoolChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => selectedClasses.clear());
          widget.onClassesSelected([]);
        }
      });

      if (widget.schoolId.isNotEmpty) {
        context.read<ClassSelectorBloc>().add(
          LoadClassesBySchool(widget.schoolId),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassSelectorBloc, ClassSelectorState>(
      builder: (context, state) {
        if (state is ClassSelectorLoading) return _loadingDropdown(context);
        if (state is ClassSelectorError)
          return _errorDropdown(context, state.message);
        if (state is! ClassSelectorLoaded) return _disabledDropdown(context);

        // Lọc dữ liệu
        var filtered = state.classes.where((c) {
          if (widget.gradeGroup != null && c.gradeGroup != widget.gradeGroup) {
            return false;
          }
          return true;
        }).toList();

        if (widget.queryString.isNotEmpty) {
          filtered = filtered.where((c) {
            final q = widget.queryString.toLowerCase();
            return c.name.toLowerCase().contains(q) ||
                c.code.toLowerCase().contains(q);
          }).toList();
        }

        if (filtered.isEmpty) return _emptyDropdown(context);

        // Nếu có initial
        if (selectedClasses.isEmpty && widget.initialClassIds != null) {
          final init = filtered
              .where((c) => widget.initialClassIds!.contains(c.id))
              .toList();
          if (init.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() => selectedClasses = init);
                widget.onClassesSelected(init);
              }
            });
          }
        }

        return Focus(
          onFocusChange: (focus) => setState(() => isFocused = focus),
          child: GestureDetector(
            onTap: () async {
              final chosen = await showDialog<List<ClassSearchEntity>>(
                context: context,
                builder: (_) => _MultiSelectDialog(
                  items: filtered,
                  selected: selectedClasses,
                ),
              );
              if (chosen != null) {
                setState(() => selectedClasses = chosen);
                widget.onClassesSelected(chosen);
              }
            },
            child: _buildMultiSelectBox(context),
          ),
        );
      },
    );
  }

  Widget _buildMultiSelectBox(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused
              ? AppColors.primary
              : (isDark ? Colors.grey[600]! : const Color(0xFFE2E8F0)),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.class_outlined, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: selectedClasses.isEmpty
                ? Text(
                    "Chọn nhiều lớp...",
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Wrap(
                    spacing: 6,
                    runSpacing: -6,
                    children: selectedClasses
                        .map(
                          (c) => Chip(
                            label: Text(c.name),
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            labelStyle: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() {
                                selectedClasses.remove(c);
                                widget.onClassesSelected(selectedClasses);
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _loadingDropdown(BuildContext context) => const Center(
    child: SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.primary,
      ),
    ),
  );

  Widget _errorDropdown(BuildContext context, String message) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.red, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.red, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyDropdown(BuildContext context) =>
      _infoBox(context, "Không có lớp trong trường này", Icons.info_outline);

  Widget _disabledDropdown(BuildContext context) =>
      _infoBox(context, "Vui lòng chọn trường trước", Icons.school_outlined);

  Widget _infoBox(BuildContext context, String text, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[600]! : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MultiSelectDialog extends StatefulWidget {
  final List<ClassSearchEntity> items;
  final List<ClassSearchEntity> selected;

  const _MultiSelectDialog({required this.items, required this.selected});

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late List<ClassSearchEntity> selected;

  @override
  void initState() {
    super.initState();
    selected = List.of(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Chọn nhiều lớp"),
      content: SizedBox(
        width: 400,
        height: 400,
        child: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (_, i) {
            final item = widget.items[i];
            final checked = selected.contains(item);
            return CheckboxListTile(
              value: checked,
              title: Text("${item.name} - ${item.code}"),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    selected.add(item);
                  } else {
                    selected.remove(item);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, widget.selected),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, selected),
          child: const Text("Xong"),
        ),
      ],
    );
  }
}
