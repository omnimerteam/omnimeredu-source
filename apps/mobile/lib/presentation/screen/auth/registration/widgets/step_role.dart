import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../utils/display_mapper.dart';
import '../../../../utils/validator.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_event.dart';
import '../bloc/registration_state.dart';
import 'school_selector.dart';
import '../../../../widgets/dropdown/register_dropdown.dart';
import '../../../../widgets/dropdown/register_multi_select_dropdwon.dart';
import '../../../../widgets/text_field/register_text_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'class_selector.dart';

class StepRole extends StatefulWidget {
  final RegistrationState state;

  const StepRole({super.key, required this.state});

  @override
  State<StepRole> createState() => _StepRoleState();
}

class _StepRoleState extends State<StepRole> {
  // Controllers for Student
  late final TextEditingController _guardianNameController;
  late final TextEditingController _guardianPhoneController;

  late final TextEditingController _newSchoolNameController;
  late final TextEditingController _newSchoolAddressController;
  late final TextEditingController _newSchoolPhoneController;
  late final TextEditingController _newSchoolDescriptionController;

  @override
  void initState() {
    super.initState();
    _guardianNameController = TextEditingController(
      text: widget.state.guardianName,
    );
    _guardianPhoneController = TextEditingController(
      text: widget.state.guardianPhone,
    );

    _newSchoolNameController = TextEditingController(
      text: widget.state.schoolName,
    );
    _newSchoolAddressController = TextEditingController(
      text: widget.state.schoolAddress,
    );
    _newSchoolPhoneController = TextEditingController(
      text: widget.state.schoolPhone,
    );
    _newSchoolDescriptionController = TextEditingController(
      text: widget.state.schoolDescription,
    );
  }

  @override
  void dispose() {
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    _newSchoolNameController.dispose();
    _newSchoolAddressController.dispose();
    _newSchoolPhoneController.dispose();
    _newSchoolDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          _buildRoleSelector(context, widget.state),
          SizedBox(height: 20.h),
          if (widget.state.selectedRole != null)
            _buildRoleForm(context, widget.state),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  /// Selector vai trò
  Widget _buildRoleSelector(BuildContext context, RegistrationState state) {
    return RegisterDropdown<RoleKeyEnum>(
      label: "Bạn là",
      requiredInput: true,
      value: state.selectedRole,
      items: RoleKeyEnum.values
          .where((role) => role != RoleKeyEnum.None)
          .map(
            (role) => DropdownMenuItem(
              value: role,
              child: Text(role.displayName),
            ),
          )
          .toList(),
      onChanged: (role) {
        if (role == null) return;

        // Reset state theo role mới
        context.read<RegistrationBloc>().add(
          UpdateRoleEvent(role),
        );

        context.read<RegistrationBloc>().add(
          UpdateSchoolIdEvent(schoolId: null, assignSchoolName: null),
        );

        context.read<RegistrationBloc>().add(
          UpdateClassIdEvent(classId: null, assignClassName: null),
        );

        context.read<RegistrationBloc>().add(
          UpdateStudentInfoEvent(
            educationLevel: null,
            classId: null,
            guardianName: null,
            guardianPhone: null,
            gradeGroup: null,
          ),
        );

        context.read<RegistrationBloc>().add(
          UpdateTeacherInfoEvent(subjects: null, qualification: null),
        );

        context.read<RegistrationBloc>().add(
          UpdateSchoolAdminInfoEvent(
            isCreateNewSchool: false,
            schoolLevel: null,
            position: null,
            schoolName: null,
            schoolAddress: null,
            schoolPhone: null,
            schoolDescription: null,
            schoolLogoFile: null,
          ),
        );
      },
    );
  }

  /// Render form theo role
  Widget _buildRoleForm(BuildContext context, RegistrationState state) {
    switch (state.selectedRole) {
      case RoleKeyEnum.Student:
        return _buildStudentForm(context, state);
      case RoleKeyEnum.Teacher:
        return _buildTeacherForm(context, state);
      case RoleKeyEnum.SchoolAdmin:
        return _buildSchoolAdminForm(context, state);
      case RoleKeyEnum.Staff:
        return _buildOtherRoleForm(context, state);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Form cho học sinh
  Widget _buildStudentForm(BuildContext context, RegistrationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLevelSelector(context, state),
        const SizedBox(height: 16.h),

        SchoolSelector(
          key: ValueKey(state.selectedEducationLevel),
          educationLevel:
              state.selectedEducationLevel ??
              EducationSystemLevelsEnum.Preschool,
          onSchoolSelected: (school) {
            context.read<RegistrationBloc>().add(
              UpdateSchoolIdEvent(
                schoolId: school?.id,
                assignSchoolName: school?.name,
              ),
            );
          },
        ),
        const SizedBox(height: 16.h),

        if (state.schoolId != null)
          ClassSelector(
            key: ValueKey(state.schoolId),
            schoolId: state.schoolId ?? "",
            gradeGroup: state.gradeGroup,
            onClassSelected: (clazz) {
              context.read<RegistrationBloc>().add(
                UpdateClassIdEvent(
                  classId: clazz?.id ?? "",
                  assignClassName: clazz?.name,
                ),
              );
            },
          ),
        const SizedBox(height: 16.h),

        /// Grade
        /// Grade (Dropdown theo cấp học)
        if (state.selectedEducationLevel != null)
          RegisterDropdown<EducationGradesEnum>(
            label: "Lớp",
            requiredInput: true,
            value: state
                .gradeGroup, // <-- state cần có field selectedGrade: EducationGradesEnum?
            items: state.selectedEducationLevel!.grades
                .map(
                  (g) => DropdownMenuItem(value: g, child: Text(g.displayName)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<RegistrationBloc>().add(
                  UpdateStudentInfoEvent(
                    gradeGroup: value,
                  ), // gửi tên enum (hoặc value)
                );
              }
            },
            validator: (v) => Validators.requiredField(v, name: "Lớp"),
          ),
        const SizedBox(height: 16.h),

        /// Guardian Name
        RegisterTextField(
          controller: _guardianNameController,
          label: 'Họ tên phụ huynh',
          hintText: 'Nhập họ tên phụ huynh',
          requiredInput: true,
          validator: (v) =>
              Validators.requiredField(v, name: "Họ tên phụ huynh") ??
              Validators.name(v),
          onChanged: (v) => context.read<RegistrationBloc>().add(
            UpdateStudentInfoEvent(guardianName: v),
          ),
        ),
        const SizedBox(height: 16.h),

        /// Guardian Phone
        RegisterTextField(
          controller: _guardianPhoneController,
          label: 'Số điện thoại phụ huynh',
          hintText: 'Nhập số điện thoại phụ huynh',
          keyboardType: TextInputType.phone,
          requiredInput: true,
          validator: (v) =>
              Validators.requiredField(v, name: "Số điện thoại phụ huynh") ??
              Validators.phone(v),
          onChanged: (v) => context.read<RegistrationBloc>().add(
            UpdateStudentInfoEvent(guardianPhone: v),
          ),
        ),
      ],
    );
  }

  /// Form đăng ký cho giáo viên
  Widget _buildTeacherForm(BuildContext context, RegistrationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLevelSelector(context, state),
        const SizedBox(height: 16.h),

        if (state.selectedEducationLevel != null)
          SchoolSelector(
            key: ValueKey(state.selectedEducationLevel),
            educationLevel:
                state.selectedEducationLevel ??
                EducationSystemLevelsEnum.Preschool,
            onSchoolSelected: (school) {
              context.read<RegistrationBloc>().add(
                UpdateSchoolIdEvent(
                  schoolId: school?.id,
                  assignSchoolName: school?.name,
                ),
              );
            },
          ),
        const SizedBox(height: 16.h),

        /// 🔹 Môn dạy (MultiSelect)
        RegisterDropdownMultiSelect<SubjectEnum>(
          label: "Chọn môn dạy",
          requiredInput: true,
          selectedValues: state.subjects ?? [],
          items: SubjectEnum.values
              .map((subject) => MultiSelectItem(subject, subject.displayName))
              .toList(),
          onChanged: (values) {
            context.read<RegistrationBloc>().add(
              UpdateTeacherInfoEvent(subjects: values),
            );
          },
          hintText: "Chọn môn dạy",
          validator: (values) {
            if (values == null || values.isEmpty) {
              return "Vui lòng chọn ít nhất 1 môn";
            }
            return null;
          },
        ),
        const SizedBox(height: 16.h),

        /// 🔹 Trình độ học vấn (SingleSelect)
        RegisterDropdown<TeacherQualificationEnum>(
          label: "Trình độ học vấn",
          requiredInput: true,
          value: state.qualification,
          items: TeacherQualificationEnum.values
              .map(
                (q) => DropdownMenuItem(value: q, child: Text(q.displayName)),
              )
              .toList(),
          onChanged: (value) {
            context.read<RegistrationBloc>().add(
              UpdateTeacherInfoEvent(qualification: value),
            );
          },
        ),
      ],
    );
  }

  /// Form cho SchoolAdmin
  /// Form cho SchoolAdmin
  Widget _buildSchoolAdminForm(BuildContext context, RegistrationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLevelSelector(context, state),
        const SizedBox(height: 16.h),

        /// Create New School Option
        CheckboxListTile(
          title: const Text('Tạo trường học mới'),
          value: state.isCreateNewSchool,
          onChanged: (value) {
            context.read<RegistrationBloc>().add(
              UpdateSchoolAdminInfoEvent(isCreateNewSchool: value),
            );
          },
        ),
        const SizedBox(height: 16.h),

        if (state.isCreateNewSchool == true) ...[
          /// New School Form
          RegisterTextField(
            controller: _newSchoolNameController,
            label: 'Tên trường',
            hintText: 'Nhập tên trường học',
            requiredInput: true,
            validator: (v) =>
                Validators.requiredField(v, name: "Tên trường") ??
                Validators.name(v),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateSchoolAdminInfoEvent(schoolName: v),
            ),
          ),
          const SizedBox(height: 16.h),

          RegisterTextField(
            controller: _newSchoolAddressController,
            label: 'Địa chỉ trường',
            hintText: 'Nhập địa chỉ trường học',
            requiredInput: true,
            maxLines: 2,
            validator: (v) =>
                Validators.requiredField(v, name: "Địa chỉ trường") ??
                Validators.address(v),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateSchoolAdminInfoEvent(schoolAddress: v),
            ),
          ),
          const SizedBox(height: 16.h),

          RegisterTextField(
            controller: _newSchoolPhoneController,
            label: 'Số điện thoại trường',
            hintText: 'Nhập số điện thoại trường học',
            keyboardType: TextInputType.phone,
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateSchoolAdminInfoEvent(schoolPhone: v),
            ),
          ),
          const SizedBox(height: 16.h),

          RegisterTextField(
            controller: _newSchoolDescriptionController,
            label: 'Mô tả trường',
            hintText: 'Nhập mô tả về trường học',
            maxLines: 3,
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateSchoolAdminInfoEvent(schoolDescription: v),
            ),
          ),
        ] else ...[
          /// Existing School Selection
          if (state.selectedEducationLevel != null) ...[
            SchoolSelector(
              key: ValueKey(state.selectedEducationLevel),
              educationLevel:
                  state.selectedEducationLevel ??
                  EducationSystemLevelsEnum.Preschool,
              onSchoolSelected: (school) {
                context.read<RegistrationBloc>().add(
                  UpdateSchoolIdEvent(
                    schoolId: school?.id,
                    assignSchoolName: school?.name,
                  ),
                );
              },
            ),
            const SizedBox(height: 16.h),
          ],

          /// 🔹 Position in School (Dropdown dùng enum)
          RegisterDropdown<SchoolAdminPositionEnum>(
            label: "Chức vụ tại trường",
            requiredInput: true,
            value: state.position,
            items: SchoolAdminPositionEnum.values
                .map(
                  (pos) => DropdownMenuItem(
                    value: pos,
                    child: Text(pos.displayName),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<RegistrationBloc>().add(
                  UpdateSchoolAdminInfoEvent(position: value),
                );
              }
            },
          ),
        ],
      ],
    );
  }

  /// Form cho các vai trò còn lại
  Widget _buildOtherRoleForm(BuildContext context, RegistrationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLevelSelector(context, state),
        const SizedBox(height: 16),

        if (state.selectedEducationLevel != null)
          SchoolSelector(
            key: ValueKey(state.selectedEducationLevel),
            educationLevel:
                state.selectedEducationLevel ??
                EducationSystemLevelsEnum.Preschool,
            onSchoolSelected: (school) {
              context.read<RegistrationBloc>().add(
                UpdateSchoolIdEvent(
                  schoolId: school?.id,
                  assignSchoolName: school?.name,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildLevelSelector(BuildContext context, RegistrationState state) {
    return RegisterDropdown<EducationSystemLevelsEnum>(
      label: "Chọn cấp học",
      value: state.educationLevel, // enum trực tiếp
      requiredInput: true,
      items: EducationSystemLevelsEnum.values
          .map(
            (level) => DropdownMenuItem<EducationSystemLevelsEnum>(
              value: level,
              child: Text(level.displayName), // hiển thị tiếng Việt
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;

        context.read<RegistrationBloc>().add(
          UpdateSelectedEducationLevelEvent(selectedEducationLevel: value),
        );

        // Update education level based on role
        switch (state.selectedRole) {
          case RoleKeyEnum.Student:
            context.read<RegistrationBloc>().add(
              UpdateStudentInfoEvent(
                educationLevel: value, // gửi enum về backend
                classId: null, // Reset class khi đổi cấp học
              ),
            );
            break;
          case RoleKeyEnum.SchoolAdmin:
            context.read<RegistrationBloc>().add(
              UpdateSchoolAdminInfoEvent(
                schoolLevel: value, // gửi enum về backend
              ),
            );
            break;
          default:
            break;
        }
      },
    );
  }
}
