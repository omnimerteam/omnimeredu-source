// widgets/class_form_dialog.dart
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
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
  final _nameController = TextEditingController();
  final _maxStudentsController = TextEditingController();
  final _baseFeeController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _maxStudentsFocusNode = FocusNode();
  final _baseFeeFocusNode = FocusNode();

  bool get isEditMode => widget.classToEdit != null;

  @override
  void initState() {
    super.initState();

    // Focus style
    _nameFocusNode.addListener(() => setState(() {}));
    _maxStudentsFocusNode.addListener(() => setState(() {}));
    _baseFeeFocusNode.addListener(() => setState(() {}));

    // Nếu là edit thì load dữ liệu vào form
    if (isEditMode) {
      _nameController.text = widget.classToEdit?.name ?? '';
      _maxStudentsController.text =
          widget.classToEdit?.maxStudents?.toString() ?? '';
      _baseFeeController.text = widget.classToEdit?.baseFee?.toString() ?? '';
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
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final classEntity = ClassEntity(
        id: isEditMode ? widget.classToEdit?.id : null,
        name: _nameController.text.trim(),
        maxStudents: int.tryParse(_maxStudentsController.text.trim()),
        baseFee: int.tryParse(_baseFeeController.text.trim()),
      );

      if (isEditMode) {
        context.read<ClassManagementBloc>().add(UpdateClassEvent(classEntity));
      } else {
        context.read<ClassManagementBloc>().add(CreateClassEvent(classEntity));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassManagementBloc, ClassManagementState>(
      listenWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      listener: (context, state) {
        if (state.formStatus == ClassManagementStatus.formSuccess) {
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
          Navigator.of(context).pop();
        } else if (state.formStatus == ClassManagementStatus.formError) {
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
      },
      builder: (context, state) {
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
                      onPressed: () {
                        context.read<ClassManagementBloc>().add(
                          HideFormEvent(),
                        );
                        Navigator.of(context).pop();
                      },
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập tên lớp học';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      PrimaryTextField(
                        controller: _maxStudentsController,
                        focusNode: _maxStudentsFocusNode,
                        hintText: 'Số học sinh tối đa',
                        prefixIcon: Icons.group,
                        isFocused: _maxStudentsFocusNode.hasFocus,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập số học sinh tối đa';
                          }
                          final number = int.tryParse(value.trim());
                          if (number == null || number <= 0) {
                            return 'Số học sinh phải là số nguyên dương';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      PrimaryTextField(
                        controller: _baseFeeController,
                        focusNode: _baseFeeFocusNode,
                        hintText: 'Học phí cơ bản (VNĐ)',
                        prefixIcon: Icons.attach_money,
                        isFocused: _baseFeeFocusNode.hasFocus,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null; // Optional
                          }
                          final number = Decimal.tryParse(value.trim());
                          if (number == null || number < Decimal.zero) {
                            return 'Học phí phải là số không âm';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            state.formStatus ==
                                ClassManagementStatus.formLoading
                            ? null
                            : () {
                                context.read<ClassManagementBloc>().add(
                                  HideFormEvent(),
                                );
                                Navigator.of(context).pop();
                              },
                        child: const Text('Hủy'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            state.formStatus ==
                                ClassManagementStatus.formLoading
                            ? null
                            : () => _submitForm(context),
                        child:
                            state.formStatus ==
                                ClassManagementStatus.formLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(isEditMode ? 'Cập nhật' : 'Tạo mới'),
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
