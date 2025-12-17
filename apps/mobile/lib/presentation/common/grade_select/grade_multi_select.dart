import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/grade_select_cubit.dart';
import 'cubit/grade_select_state.dart';

class GradeMultiSelect extends StatelessWidget {
  final List<String> selectedGradeIds;
  final ValueChanged<List<String>> onChanged;
  final String hintText;
  final bool isFocused;

  const GradeMultiSelect({
    super.key,
    required this.selectedGradeIds,
    required this.onChanged,
    this.hintText = 'Chọn khối lớp',
    this.isFocused = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<GradeSelectCubit, GradeSelectState>(
      builder: (context, state) {
        final List<_GradeItem> grades = (state is GradeSelectSuccess)
            ? state.grades
                  .where((g) => g.id != null)
                  .map((g) => _GradeItem(id: g.id!, name: g.name))
                  .toList()
            : [];

        return GestureDetector(
          onTap: () {
            if (state is GradeSelectSuccess) {
              _showMultiSelectDialog(context, grades);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: isDark ? Colors.grey[400] : const Color(0xFF94A3B8),
                fontFamily: "Inter",
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: _getFillColor(context, isFocused, isDark),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isFocused
                      ? theme.colorScheme.primary
                      : (isDark ? Colors.grey[700] : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.school,
                  color: isFocused
                      ? theme.colorScheme.onPrimary
                      : (isDark ? Colors.grey[300] : const Color(0xFF64748B)),
                  size: 20,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[600]! : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: selectedGradeIds.isEmpty
                        ? [
                            Text(
                              hintText,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ]
                        : selectedGradeIds
                              .map(
                                (id) => _buildChip(
                                  context,
                                  grades
                                      .firstWhere(
                                        (g) => g.id == id,
                                        orElse: () =>
                                            _GradeItem(id: id, name: id),
                                      )
                                      .name,
                                  id,
                                ),
                              )
                              .toList(),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark ? Colors.grey[300] : const Color(0xFF64748B),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip(BuildContext context, String label, String id) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontFamily: "Inter", fontSize: 14),
      ),
      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
      onDeleted: () {
        final updated = List<String>.from(selectedGradeIds)..remove(id);
        onChanged(updated);
      },
    );
  }

  void _showMultiSelectDialog(
    BuildContext context,
    List<_GradeItem> gradeList,
  ) async {
    final selected = Set<String>.from(selectedGradeIds);
    final theme = Theme.of(context);

    final result = await showDialog<List<String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Chọn khối lớp"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: gradeList
                .map(
                  (g) => CheckboxListTile(
                    title: Text(
                      g.name,
                      style: const TextStyle(fontFamily: "Inter"),
                    ),
                    value: selected.contains(g.id),
                    activeColor: theme.colorScheme.primary,
                    onChanged: (bool? checked) {
                      if (checked == true) {
                        selected.add(g.id);
                      } else {
                        selected.remove(g.id);
                      }
                      (ctx as Element).markNeedsBuild(); // rebuild instantly
                    },
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, selected.toList()),
            child: const Text("Xong"),
          ),
        ],
      ),
    );

    if (result != null) {
      onChanged(result);
    }
  }

  Color _getFillColor(BuildContext context, bool isFocused, bool isDark) {
    final theme = Theme.of(context);
    if (isFocused) return theme.colorScheme.primary.withOpacity(0.05);
    return isDark ? Colors.grey[800]! : const Color(0xFFF8FAFC);
  }
}

class _GradeItem {
  final String id;
  final String name;
  const _GradeItem({required this.id, required this.name});
}
