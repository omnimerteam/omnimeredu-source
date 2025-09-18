// Updated ClassFormDialog for Map-based state
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/grade_select/grade_select_cubit.dart';
import 'package:flutter_ios_android_platforms/core/bloc/grade_select/grade_select_state.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/validator.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dropdown/grade_select_dropdown.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/primary_text_field.dart';
import '../bloc/class_management_bloc.dart';
import '../bloc/class_management_event.dart';
import '../bloc/class_management_state.dart';

class ClassFormDialog extends StatefulWidget {
  final ClassEntity? classToEdit;

  const ClassFormDialog({super.key, this.classToEdit});

  @override
  State<ClassFormDialog> createState() => _ClassFormDialogState();
}

class _ClassFormDialogState extends State<ClassFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _maxStudentsController;
  late TextEditingController _baseFeeController;

  final _nameFocusNode = FocusNode();
  final _maxStudentsFocusNode = FocusNode();
  final _baseFeeFocusNode = FocusNode();
  final _gradeFocusNode = FocusNode();

  String? _selectedGradeId;

  bool get isEditMode => widget.classToEdit != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _maxStudentsController = TextEditingController();
    _baseFeeController = TextEditingController();

    _nameFocusNode.addListener(() => setState(() {}));
    _maxStudentsFocusNode.addListener(() => setState(() {}));
    _baseFeeFocusNode.addListener(() => setState(() {}));
    _gradeFocusNode.addListener(() => setState(() {}));

    // Initialize form with proper data
    _initFormData();
  }

  @override
  void didUpdateWidget(covariant ClassFormDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-initialize when widget updates
    if (oldWidget.classToEdit != widget.classToEdit) {
      _initFormData();
    }
  }

  void _initFormData() {
    // Clear controllers first
    _nameController.clear();
    _maxStudentsController.clear();
    _baseFeeController.clear();
    _selectedGradeId = null;

    // Only populate if we have data to edit
    if (isEditMode && widget.classToEdit != null) {
      _nameController.text = widget.classToEdit?.name ?? '';
      _maxStudentsController.text =
          widget.classToEdit?.maxStudents?.toString() ?? '';
      _baseFeeController.text = widget.classToEdit?.baseFee?.toString() ?? '';
      _selectedGradeId = widget.classToEdit?.gradeId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _maxStudentsController.dispose();
    _baseFeeController.dispose();
    _nameFocusNode.dispose();
    _maxStudentsFocusNode.dispose();
    _baseFeeFocusNode.dispose();
    _gradeFocusNode.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final classEntity = ClassEntity(
        id: isEditMode ? widget.classToEdit?.id : null,
        name: _nameController.text.trim(),
        maxStudents: int.tryParse(_maxStudentsController.text.trim()),
        baseFee: int.tryParse(_baseFeeController.text.trim()),
        gradeId: _selectedGradeId,
      );

      if (isEditMode) {
        context.read<ClassManagementBloc>().add(UpdateClassEvent(classEntity));
      } else {
        context.read<ClassManagementBloc>().add(CreateClassEvent(classEntity));
      }

      Navigator.of(context).pop();
    }
  }

  void _closeDialog(BuildContext context) {
    context.read<ClassManagementBloc>().add(HideFormEvent());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassManagementBloc, ClassManagementState>(
      listenWhen: (previous, current) {
        if (previous is ClassManagementLoaded &&
            current is ClassManagementLoaded) {
          return previous.formStatus != current.formStatus;
        }
        return false;
      },
      listener: (context, state) {
        if (state is ClassManagementLoaded) {
          if (state.formStatus == ClassManagementFormStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isEditMode
                      ? 'Cập nhật lớp học thành công!'
                      : 'Tạo lớp học thành công!',
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
            // Reset form state in bloc and close dialog
            context.read<ClassManagementBloc>().add(ResetFormEvent());
          } else if (state.formStatus == ClassManagementFormStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.formErrorMessage ?? 'Có lỗi xảy ra!'),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        bool isFormLoading = false;

        if (state is ClassManagementFormLoading) {
          isFormLoading = true;
        } else if (state is ClassManagementLoaded) {
          isFormLoading = state.formStatus == ClassManagementFormStatus.loading;
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isEditMode ? 'Cập nhật lớp học' : 'Tạo lớp học mới',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _closeDialog(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      PrimaryTextField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        hintText: 'Tên lớp học',
                        prefixIcon: Icons.class_,
                        isFocused: _nameFocusNode.hasFocus,
                        validator: (value) => Validators.requiredField(
                          value,
                          name: 'Tên lớp học',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Focus(
                        focusNode: _gradeFocusNode,
                        child: BlocBuilder<GradeSelectCubit, GradeSelectState>(
                          builder: (context, gradeState) {
                            return GradeSelectDropdown(
                              selectedGradeId: _selectedGradeId,
                              hintText: 'Chọn khối lớp',
                              isFocused: _gradeFocusNode.hasFocus,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGradeId = value;
                                });
                              },
                              validator: (value) => Validators.requiredField(
                                value,
                                name: 'Khối lớp',
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      PrimaryTextField(
                        controller: _maxStudentsController,
                        focusNode: _maxStudentsFocusNode,
                        hintText: 'Số học sinh tối đa',
                        prefixIcon: Icons.group,
                        isFocused: _maxStudentsFocusNode.hasFocus,
                        keyboardType: TextInputType.number,
                        validator: Validators.maxStudents,
                      ),
                      const SizedBox(height: 16),
                      PrimaryTextField(
                        controller: _baseFeeController,
                        focusNode: _baseFeeFocusNode,
                        hintText: 'Học phí cơ bản (VNĐ)',
                        prefixIcon: Icons.attach_money,
                        isFocused: _baseFeeFocusNode.hasFocus,
                        keyboardType: TextInputType.number,
                        validator: Validators.baseFee,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: isFormLoading
                            ? null
                            : () => _closeDialog(context),
                        text: 'Hủy',
                        type: AppButtonType.danger,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppButton(
                        onPressed: isFormLoading
                            ? null
                            : () => _submitForm(context),
                        text: isEditMode ? 'Cập nhật' : 'Tạo mới',
                        loading: isFormLoading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
