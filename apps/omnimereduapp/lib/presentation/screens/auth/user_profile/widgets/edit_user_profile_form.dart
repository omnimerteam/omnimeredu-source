import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/user/base_user_entity.dart';
import '../../../../../domain/entities/user/school_admin_entity.dart';
import '../../../../../domain/entities/user/student_entity.dart';
import '../../../../../domain/entities/user/teacher_entity.dart';
import '../cubit/user_profile_cubit.dart';
import '../../../../utils/display_mapper.dart';
import '../../../../widgets/button/app_button.dart';
import '../../../../widgets/dropdown/register_dropdown.dart';
import '../../../../widgets/dropdown/register_multi_select_dropdwon.dart';
import '../../../../widgets/text_field/register_text_field.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class EditUserProfileDialog extends StatefulWidget {
  final BaseUserEntity user;
  const EditUserProfileDialog({super.key, required this.user});

  @override
  State<EditUserProfileDialog> createState() => _EditUserProfileDialogState();
}

class _EditUserProfileDialogState extends State<EditUserProfileDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController fullNameController;
  late TextEditingController addressController;
  late DateTime? birthday;
  late String gender;

  // student
  String? guardianName;
  String? guardianPhone;
  EducationSystemLevelsEnum? educationLevel;
  EducationGradesEnum? gradeGroup;

  // teacher
  TeacherQualificationEnum? qualification;
  List<SubjectEnum> subjects = [];

  // admin
  SchoolAdminPositionEnum? position;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    fullNameController = TextEditingController(text: user.fullName);
    addressController = TextEditingController(text: user.address ?? '');
    birthday = user.birthday;
    gender = user.gender ?? 'male';

    if (user is StudentEntity) {
      guardianName = user.guardianName;
      guardianPhone = user.guardianPhone;
      educationLevel = user.educationLevel;
      gradeGroup = user.gradeGroup;
    } else if (user is TeacherEntity) {
      qualification = user.qualification;
      subjects = user.subjects ?? [];
    } else if (user is SchoolAdminEntity) {
      position = user.position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cập nhật thông tin cá nhân'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              RegisterTextField(
                controller: fullNameController,
                label: "Họ và tên",
                requiredInput: true,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 10),

              RegisterDropdown<String>(
                label: "Giới tính",
                value: gender,
                requiredInput: true,
                items: DisplayMapper.gender.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (val) => setState(() => gender = val ?? 'male'),
              ),
              const SizedBox(height: 10),

              RegisterTextField(
                controller: addressController,
                label: "Địa chỉ",
                hintText: "Nhập địa chỉ hiện tại",
              ),
              const SizedBox(height: 10),

              RegisterTextField(
                controller: TextEditingController(
                  text: birthday != null
                      ? DateFormat('dd/MM/yyyy').format(birthday!)
                      : '',
                ),
                label: "Ngày sinh",
                readOnly: true,
                requiredInput: true,
                hintText: "Chọn ngày sinh",
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: birthday ?? DateTime(2000),
                    firstDate: DateTime(1970),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => birthday = picked);
                  }
                },
              ),
              const SizedBox(height: 15),

              _buildRoleSpecificFields(),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                onPressed: () => Navigator.pop(context),
                text: 'Hủy',
                type: AppButtonType.cancel,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: AppButton(
                onPressed: _submit,
                text: 'Lưu',
                type: AppButtonType.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleSpecificFields() {
    final user = widget.user;

    if (user is StudentEntity) {
      return Column(
        children: [
          RegisterDropdown<EducationSystemLevelsEnum>(
            label: "Cấp học",
            value: educationLevel,
            items: EducationSystemLevelsEnum.values
                .map(
                  (e) => DropdownMenuItem(value: e, child: Text(e.displayName)),
                )
                .toList(),
            onChanged: (val) => setState(() => educationLevel = val),
          ),
          const SizedBox(height: 10),
          RegisterDropdown<EducationGradesEnum>(
            label: "Khối lớp",
            value: gradeGroup,
            items: EducationGradesEnum.values
                .map(
                  (e) => DropdownMenuItem(value: e, child: Text(e.displayName)),
                )
                .toList(),
            onChanged: (val) => setState(() => gradeGroup = val),
          ),
          const SizedBox(height: 10),
          RegisterTextField(
            controller: TextEditingController(text: guardianName ?? ''),
            label: "Tên phụ huynh",
            onChanged: (v) => guardianName = v,
          ),
          const SizedBox(height: 10),
          RegisterTextField(
            controller: TextEditingController(text: guardianPhone ?? ''),
            label: "SĐT phụ huynh",
            keyboardType: TextInputType.phone,
            onChanged: (v) => guardianPhone = v,
          ),
        ],
      );
    } else if (user is TeacherEntity) {
      return Column(
        children: [
          RegisterDropdown<TeacherQualificationEnum>(
            label: "Trình độ",
            value: qualification,
            items: TeacherQualificationEnum.values
                .map(
                  (e) => DropdownMenuItem(value: e, child: Text(e.displayName)),
                )
                .toList(),
            onChanged: (val) => setState(() => qualification = val),
          ),
          const SizedBox(height: 10),
          RegisterDropdownMultiSelect<SubjectEnum>(
            label: "Môn giảng dạy",
            selectedValues: subjects,
            items: SubjectEnum.values
                .map((e) => MultiSelectItem(e, e.displayName))
                .toList(),
            onChanged: (val) => setState(() => subjects = val),
          ),
        ],
      );
    } else if (user is SchoolAdminEntity) {
      return RegisterDropdown<SchoolAdminPositionEnum>(
        label: "Chức vụ",
        value: position,
        items: SchoolAdminPositionEnum.values
            .map((e) => DropdownMenuItem(value: e, child: Text(e.displayName)))
            .toList(),
        onChanged: (val) => setState(() => position = val),
      );
    }
    return const SizedBox.shrink();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = widget.user;
    dynamic updatedUserData;

    if (user is StudentEntity) {
      updatedUserData = user.copyWith(
        fullName: fullNameController.text.trim(),
        gender: gender,
        birthday: birthday,
        address: addressController.text.trim(),
        educationLevel: educationLevel,
        gradeGroup: gradeGroup,
        guardianName: guardianName,
        guardianPhone: guardianPhone,
      );
    } else if (user is TeacherEntity) {
      updatedUserData = user.copyWith(
        fullName: fullNameController.text.trim(),
        gender: gender,
        birthday: birthday,
        address: addressController.text.trim(),
        qualification: qualification,
        subjects: subjects,
      );
    } else if (user is SchoolAdminEntity) {
      updatedUserData = user.copyWith(
        fullName: fullNameController.text.trim(),
        gender: gender,
        birthday: birthday,
        address: addressController.text.trim(),
        position: position,
      );
    } else {
      updatedUserData = user.copyWith(
        fullName: fullNameController.text.trim(),
        gender: gender,
        birthday: birthday,
        address: addressController.text.trim(),
      );
    }

    context.read<UserProfileCubit>().updateProfile(
      updatedUserData: updatedUserData,
    );

    Navigator.pop(context);
  }
}
