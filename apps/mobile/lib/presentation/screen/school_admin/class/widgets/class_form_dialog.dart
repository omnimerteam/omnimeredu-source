import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/presentation/common/widgets/button/app_button.dart';
import 'package:mobile/presentation/common/widgets/input/primary_text_field.dart';
import '../../../../../../core/utils/validator.dart';
import '../../../../../domain/entities/class/class_entity.dart';
import '../../../../../../core/constants/enum_constant.dart';
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
  late TextEditingController _codeController;
  late TextEditingController _maxStudentsController;

  final _nameFocusNode = FocusNode();
  final _codeFocusNode = FocusNode();
  final _maxStudentsFocusNode = FocusNode();

  EducationGradesEnum? _selectedGradeEnum;

  bool get isEditMode => widget.classToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _codeController = TextEditingController();
    _maxStudentsController = TextEditingController();

    _nameFocusNode.addListener(_onFocusChange);
    _codeFocusNode.addListener(_onFocusChange);
    _maxStudentsFocusNode.addListener(_onFocusChange);

    _initFormData();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _initFormData() {
    if (isEditMode && widget.classToEdit != null) {
      _nameController.text = widget.classToEdit!.name;
      _codeController.text = widget.classToEdit!.code;
      _maxStudentsController.text =
          widget.classToEdit!.maxStudents?.toString() ?? '';
      _selectedGradeEnum = widget.classToEdit!.grade;
    }
  }

  List<DropdownMenuItem<EducationGradesEnum>> _getGradeItems() {
    return EducationGradesEnum.values
        .where((e) => e != EducationGradesEnum.None)
        .map((e) {
          return DropdownMenuItem(value: e, child: Text(e.displayName));
        })
        .toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _maxStudentsController.dispose();
    _nameFocusNode.dispose();
    _codeFocusNode.dispose();
    _maxStudentsFocusNode.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedGradeEnum == null) {
        // Should be handled by dropdown validator usually, but double check
        return;
      }

      final classEntity = ClassEntity(
        id: isEditMode ? widget.classToEdit!.id : '',
        name: _nameController.text.trim(),
        code: _codeController.text.trim(),
        schoolId: '', // Will be handled by Bloc/Repo/Backend
        grade: _selectedGradeEnum!,
        level: EducationSystemLevelsEnum
            .Primary, // Defaulting to Primary for now as per constant check
        // Ideally should select Level too, but often Grade implies Level or backend validation.
        maxStudents: int.tryParse(_maxStudentsController.text.trim()),
        currentStudents: widget.classToEdit?.currentStudents ?? 0,
      );

      if (isEditMode) {
        context.read<ClassManagementBloc>().add(UpdateClassEvent(classEntity));
      } else {
        context.read<ClassManagementBloc>().add(CreateClassEvent(classEntity));
      }

      context.read<ClassManagementBloc>().add(HideFormEvent());
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
      listener: (context, state) {
        if (state is ClassManagementLoaded) {
          if (state.formStatus == ClassManagementFormStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Thành công!"),
                backgroundColor: Colors.green,
              ),
            );
            context.read<ClassManagementBloc>().add(ResetFormEvent());
          } else if (state.formStatus == ClassManagementFormStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.formErrorMessage ?? "Lỗi"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        bool isFormLoading = false;
        if (state is ClassManagementLoaded) {
          isFormLoading = state.formStatus == ClassManagementFormStatus.loading;
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditMode ? 'Cập nhật' : 'Tạo mới',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        PrimaryTextField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          isFocused: _nameFocusNode.hasFocus,
                          prefixIcon: Icons.label_outline,
                          hintText: 'Tên lớp',
                          validator: (v) => Validators.required(v),
                        ),
                        const SizedBox(height: 16),
                        PrimaryTextField(
                          controller: _codeController,
                          focusNode: _codeFocusNode,
                          isFocused: _codeFocusNode.hasFocus,
                          prefixIcon: Icons.tag,
                          hintText: 'Mã lớp',
                          validator: (v) => Validators.required(v),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<EducationGradesEnum>(
                          value: _selectedGradeEnum,
                          decoration: const InputDecoration(
                            labelText: 'Khối',
                            border: OutlineInputBorder(),
                          ),
                          items: _getGradeItems(),
                          onChanged: (v) =>
                              setState(() => _selectedGradeEnum = v),
                          validator: (v) => v == null ? 'Bắt buộc' : null,
                        ),
                        const SizedBox(height: 16),
                        PrimaryTextField(
                          controller: _maxStudentsController,
                          focusNode: _maxStudentsFocusNode,
                          isFocused: _maxStudentsFocusNode.hasFocus,
                          prefixIcon: Icons.people_outline,
                          hintText: 'Sĩ số tối đa',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Hủy',
                          type: AppButtonType.cancel,
                          onPressed: () => _closeDialog(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          text: 'Lưu',
                          onPressed: () => _submitForm(context),
                          loading: isFormLoading,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
