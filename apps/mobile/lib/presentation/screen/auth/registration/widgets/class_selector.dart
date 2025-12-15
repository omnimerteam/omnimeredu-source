import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/school/class_selector_entity.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../bloc/class/class_bloc.dart';
import '../bloc/class/class_event.dart';
import '../bloc/class/class_state.dart';

class ClassSelector extends StatefulWidget {
  final String schoolId;
  final EducationGradesEnum? gradeGroup;
  final void Function(ClassSelectorEntity?) onClassSelected;
  final String? Function(ClassSelectorEntity?)? validator;

  const ClassSelector({
    super.key,
    required this.schoolId,
    this.gradeGroup,
    required this.onClassSelected,
    this.validator,
  });

  @override
  State<ClassSelector> createState() => _ClassSelectorState();
}

class _ClassSelectorState extends State<ClassSelector> {
  ClassSelectorEntity? selectedClass;

  @override
  void initState() {
    super.initState();
    if (widget.schoolId.isNotEmpty && widget.gradeGroup != null) {
      context.read<ClassBloc>().add(
        LoadClassesBySchool(
          schoolId: widget.schoolId,
          grade: widget.gradeGroup!.name,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(ClassSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.schoolId != widget.schoolId ||
        oldWidget.gradeGroup != widget.gradeGroup) {
      if (widget.schoolId.isNotEmpty && widget.gradeGroup != null) {
        context.read<ClassBloc>().add(
          LoadClassesBySchool(
            schoolId: widget.schoolId,
            grade: widget.gradeGroup!.name,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn lớp',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<ClassBloc, ClassState>(
          builder: (context, state) {
            if (state is ClassLoading) {
              return Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            } else if (state is ClassLoaded) {
              return DropdownSearch<ClassSelectorEntity>(
                items: (String filter, LoadProps? props) async {
                  if (filter.isNotEmpty) {
                    return state.classes.where((cls) {
                      final name = cls.name.toLowerCase();
                      final code = cls.code.toLowerCase();
                      return name.contains(filter.toLowerCase()) ||
                          code.contains(filter.toLowerCase());
                    }).toList();
                  }
                  return state.classes;
                },
                selectedItem: selectedClass,
                itemAsString: (item) => "${item.code} - ${item.name}",
                compareFn: (a, b) => a.id == b.id,
                onChanged: (value) {
                  setState(() => selectedClass = value);
                  widget.onClassSelected(value);
                },
                validator: widget.validator,
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    hintText: "Nhập tên hoặc mã lớp để tìm",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.red,
                        width: 2,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.red,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Tìm theo tên hoặc mã...",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              );
            } else if (state is ClassError) {
              return Container(
                height: 56,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.red, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          color: AppColors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
