import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_state.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dropdown/primary_dropdown.dart';

class ClassSelector extends StatefulWidget {
  final String schoolId;
  final EducationGradesEnum? gradeGroup;
  final String? initialClassId;
  final ValueChanged<ClassSearchEntity?> onClassSelected;
  final String? Function(ClassSearchEntity?)? validator;
  final bool autoLoad;
  final String queryString;

  const ClassSelector({
    super.key,
    required this.schoolId,
    this.gradeGroup,
    this.initialClassId,
    required this.onClassSelected,
    this.validator,
    this.autoLoad = true,
    this.queryString = "",
  });

  @override
  State<ClassSelector> createState() => _ClassSelectorState();
}

class _ClassSelectorState extends State<ClassSelector> {
  ClassSearchEntity? selectedClass;
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
  void didUpdateWidget(ClassSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    final schoolChanged = oldWidget.schoolId != widget.schoolId;
    final gradeChanged = oldWidget.gradeGroup != widget.gradeGroup;

    // 👉 Chỉ reload nếu schoolId đổi
    if (schoolChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => selectedClass = null);
          widget.onClassSelected(null);
        }
      });

      if (widget.schoolId.isNotEmpty) {
        context.read<ClassSelectorBloc>().add(
          LoadClassesBySchool(widget.schoolId),
        );
      }
    }
    // 👉 Nếu chỉ đổi gradeGroup => reset selected nhưng không reload
    else if (gradeChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => selectedClass = null);
          widget.onClassSelected(null);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassSelectorBloc, ClassSelectorState>(
      builder: (context, state) {
        if (state is ClassSelectorLoading) {
          return _loadingDropdown(context);
        } else if (state is ClassSelectorLoaded) {
          // lọc theo gradeGroup
          var filtered = state.classes.where((c) {
            if (widget.gradeGroup != null &&
                c.gradeGroup != widget.gradeGroup) {
              return false;
            }
            return true;
          }).toList();

          // lọc theo queryString (name hoặc code)
          if (widget.queryString.isNotEmpty) {
            filtered = filtered.where((c) {
              final q = widget.queryString.toLowerCase();
              return c.name.toLowerCase().contains(q) ||
                  c.code.toLowerCase().contains(q);
            }).toList();
          }

          if (filtered.isEmpty) {
            return _emptyDropdown(context);
          }

          if (selectedClass == null && widget.initialClassId != null) {
            final found = filtered.firstWhere(
              (c) => c.id == widget.initialClassId,
              orElse: () => filtered.first,
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  selectedClass = found;
                });
                widget.onClassSelected(found);
              }
            });
          }

          return Focus(
            onFocusChange: (focus) {
              setState(() => isFocused = focus);
            },
            child: PrimaryDropdown<ClassSearchEntity>(
              value: selectedClass,
              items: filtered
                  .map(
                    (clazz) => DropdownMenuItem<ClassSearchEntity>(
                      value: clazz,
                      child: Text(
                        "${clazz.name} - ${clazz.code}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  )
                  .toList(),
              hintText: "Vui lòng chọn lớp",
              prefixIcon: Icons.class_outlined,
              isFocused: isFocused,
              validator: widget.validator,
              onChanged: (value) {
                setState(() => selectedClass = value);
                widget.onClassSelected(value);
              },
            ),
          );
        } else if (state is ClassSelectorError) {
          logger.e("Load Error: ${state.message}");
          return _errorDropdown(context, state.message);
        }

        return _disabledDropdown(context);
      },
    );
  }

  Widget _emptyDropdown(BuildContext context) {
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
            Icons.info_outline,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Không có lớp trong trường này",
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

  Widget _loadingDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[600]! : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

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

  Widget _disabledDropdown(BuildContext context) {
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
            Icons.school_outlined,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Vui lòng chọn trường trước",
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
