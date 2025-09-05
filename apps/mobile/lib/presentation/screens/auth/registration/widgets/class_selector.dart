import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_state.dart';

class ClassSelector extends StatefulWidget {
  final String schoolId;
  final ValueChanged<ClassSearchEntity?> onClassSelected;
  final String? Function(ClassSearchEntity?)? validator;

  const ClassSelector({
    super.key,
    required this.schoolId,
    required this.onClassSelected,
    this.validator,
  });

  @override
  State<ClassSelector> createState() => _ClassSelectorState();
}

class _ClassSelectorState extends State<ClassSelector> {
  ClassSearchEntity? selectedClass;

  @override
  void initState() {
    super.initState();
    if (widget.schoolId.isNotEmpty) {
      context.read<ClassBloc>().add(LoadClassesBySchool(widget.schoolId));
    }
  }

  @override
  void didUpdateWidget(ClassSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset selected class khi schoolId thay đổi
    if (oldWidget.schoolId != widget.schoolId) {
      setState(() => selectedClass = null);
      widget.onClassSelected(null);

      if (widget.schoolId.isNotEmpty) {
        context.read<ClassBloc>().add(LoadClassesBySchool(widget.schoolId));
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
              return DropdownButtonFormField<ClassSearchEntity>(
                value: selectedClass,
                validator: widget.validator,
                decoration: InputDecoration(
                  hintText: "Vui lòng chọn lớp",
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
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                ),
                items: state.classes.map((clazz) {
                  return DropdownMenuItem<ClassSearchEntity>(
                    value: clazz,
                    child: Text("${clazz.code} - ${clazz.name}"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedClass = value);
                  widget.onClassSelected(value);
                },
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
            return Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.class_outlined, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Vui lòng chọn trường trước",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
