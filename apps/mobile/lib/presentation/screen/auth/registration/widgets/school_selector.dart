import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/school/school_selector_entity.dart';
import '../../../../../core/theme/app_colors.dart';

import '../bloc/school/school_bloc.dart';
import '../bloc/school/school_event.dart';
import '../bloc/school/school_state.dart';

class SchoolSelector extends StatefulWidget {
  final EducationSystemLevelsEnum educationLevel; // để load school theo cấp học
  final void Function(SchoolSelectorEntity?) onSchoolSelected;
  final String? Function(SchoolSelectorEntity?)? validator;

  const SchoolSelector({
    super.key,
    required this.educationLevel,
    required this.onSchoolSelected,
    this.validator,
  });

  @override
  State<SchoolSelector> createState() => _SchoolSelectorState();
}

class _SchoolSelectorState extends State<SchoolSelector> {
  SchoolSelectorEntity? selectedSchool;

  @override
  void initState() {
    super.initState();
    context.read<SchoolBloc>().add(LoadSchoolsByLevel(widget.educationLevel));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn trường',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<SchoolBloc, SchoolState>(
          builder: (context, state) {
            if (state is SchoolLoading) {
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
            } else if (state is SchoolLoaded) {
              return DropdownSearch<SchoolSelectorEntity>(
                items: (String filter, LoadProps? props) async {
                  if (filter.isNotEmpty) {
                    return state.schools.where((school) {
                      final name = school.name.toLowerCase();
                      final code = school.code.toLowerCase();
                      return name.contains(filter.toLowerCase()) ||
                          code.contains(filter.toLowerCase());
                    }).toList();
                  }
                  return state.schools;
                },
                selectedItem: selectedSchool,
                itemAsString: (item) => "${item.code} - ${item.name}",
                compareFn: (a, b) => a.id == b.id,
                onChanged: (value) {
                  setState(() => selectedSchool = value);
                  widget.onSchoolSelected(value);
                },
                validator: widget.validator,
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    hintText: "Nhập tên hoặc mã trường để tìm",
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
            } else if (state is SchoolError) {
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
