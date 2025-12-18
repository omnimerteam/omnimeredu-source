import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../common/widgets/input/primary_text_field.dart';
import '../../../../common/widgets/input/primary_dropdown.dart';
import '../../../../common/widgets/input/primary_multi_select_dropdown.dart';
import '../../../../../../core/validation/field_validator.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_event.dart';
import '../bloc/registration_state.dart';
import 'school_selector.dart';
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

  // FocusNodes
  final FocusNode _guardianNameFocus = FocusNode();
  final FocusNode _guardianPhoneFocus = FocusNode();
  final FocusNode _newSchoolNameFocus = FocusNode();
  final FocusNode _newSchoolAddressFocus = FocusNode();
  final FocusNode _newSchoolPhoneFocus = FocusNode();
  final FocusNode _newSchoolDescriptionFocus = FocusNode();

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

    _guardianNameFocus.addListener(_onFocusChange);
    _guardianPhoneFocus.addListener(_onFocusChange);
    _newSchoolNameFocus.addListener(_onFocusChange);
    _newSchoolAddressFocus.addListener(_onFocusChange);
    _newSchoolPhoneFocus.addListener(_onFocusChange);
    _newSchoolDescriptionFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    _newSchoolNameController.dispose();
    _newSchoolAddressController.dispose();
    _newSchoolPhoneController.dispose();
    _newSchoolDescriptionController.dispose();

    _guardianNameFocus.removeListener(_onFocusChange);
    _guardianPhoneFocus.removeListener(_onFocusChange);
    _newSchoolNameFocus.removeListener(_onFocusChange);
    _newSchoolAddressFocus.removeListener(_onFocusChange);
    _newSchoolPhoneFocus.removeListener(_onFocusChange);
    _newSchoolDescriptionFocus.removeListener(_onFocusChange);

    _guardianNameFocus.dispose();
    _guardianPhoneFocus.dispose();
    _newSchoolNameFocus.dispose();
    _newSchoolAddressFocus.dispose();
    _newSchoolPhoneFocus.dispose();
    _newSchoolDescriptionFocus.dispose();
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
    return PrimaryDropdown<RoleKeyEnum>(
      hintText: "Bạn là",
      required: true,
      value: state.selectedRole,
      prefixIcon: Icons.person_outline,
      items: RoleKeyEnum.values
          .where((role) => role != RoleKeyEnum.None)
          .map(
            (role) =>
                DropdownMenuItem(value: role, child: Text(role.displayName)),
          )
          .toList(),
      onChanged: (role) {
        if (role == null) return;

        // Reset state theo role mới
        context.read<RegistrationBloc>().add(UpdateRoleEvent(role));

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
        SizedBox(height: 16.h),

        SchoolSelector(
          key: ValueKey(state.selectedEducationLevel),
          educationLevel:
              state.selectedEducationLevel ??
              EducationSystemLevelsEnum.Preschool,
          onSchoolSelected: (school) {
            if (school != null) {
              context.read<RegistrationBloc>().add(
                UpdateSchoolIdEvent(
                  schoolId: school.id,
                  assignSchoolName: school.name,
                ),
              );
            } else {
              context.read<RegistrationBloc>().add(
                UpdateSchoolIdEvent(schoolId: null, assignSchoolName: null),
              );
            }
          },
        ),
        SizedBox(height: 16.h),

        if (state.schoolId != null)
          ClassSelector(
            key: ValueKey(state.schoolId),
            schoolId: state.schoolId ?? "",
            gradeGroup: state.gradeGroup,
            onClassSelected: (clazz) {
              if (clazz != null) {
                context.read<RegistrationBloc>().add(
                  UpdateClassIdEvent(
                    classId: clazz.id,
                    assignClassName: clazz.name,
                  ),
                );
              } else {
                context.read<RegistrationBloc>().add(
                  UpdateClassIdEvent(classId: null, assignClassName: null),
                );
              }
            },
          ),
        SizedBox(height: 16.h),

        /// Grade
        /// Grade (Dropdown theo cấp học)
        if (state.selectedEducationLevel != null)
          PrimaryDropdown<EducationGradesEnum>(
            hintText: "Lớp",
            required: true,
            prefixIcon: Icons.grade_outlined,
            value:
                state.selectedEducationLevel!.grades.contains(state.gradeGroup)
                ? state.gradeGroup
                : null,
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
            validator: FieldValidators.required(fieldName: "Lớp"),
          ),
        SizedBox(height: 16.h),

        /// Guardian Name
        PrimaryTextField(
          controller: _guardianNameController,
          focusNode: _guardianNameFocus,
          isFocused: _guardianNameFocus.hasFocus,
          hintText: 'Nhập họ tên phụ huynh',
          prefixIcon: Icons.person_outline,
          required: true,
          validator: FieldValidators.fullname(fieldName: "Họ tên phụ huynh"),
          onChanged: (v) => context.read<RegistrationBloc>().add(
            UpdateStudentInfoEvent(guardianName: v),
          ),
        ),
        SizedBox(height: 16.h),

        /// Guardian Phone
        PrimaryTextField(
          controller: _guardianPhoneController,
          focusNode: _guardianPhoneFocus,
          isFocused: _guardianPhoneFocus.hasFocus,
          hintText: 'Nhập số điện thoại phụ huynh',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          required: true,
          validator: FieldValidators.phone(
            fieldName: "Số điện thoại phụ huynh",
          ),
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
        SizedBox(height: 16.h),

        if (state.selectedEducationLevel != null)
          SchoolSelector(
            key: ValueKey(state.selectedEducationLevel),
            educationLevel:
                state.selectedEducationLevel ??
                EducationSystemLevelsEnum.Preschool,
            onSchoolSelected: (school) {
              if (school != null) {
                context.read<RegistrationBloc>().add(
                  UpdateSchoolIdEvent(
                    schoolId: school.id,
                    assignSchoolName: school.name,
                  ),
                );
              } else {
                context.read<RegistrationBloc>().add(
                  UpdateSchoolIdEvent(schoolId: null, assignSchoolName: null),
                );
              }
            },
          ),
        SizedBox(height: 16.h),

        /// 🔹 Môn dạy (MultiSelect)
        PrimaryMultiSelectDropdown<SubjectEnum>(
          title: "Chọn môn dạy",
          hintText: "Chọn môn dạy",
          required: true,
          prefixIcon: Icons.menu_book_outlined,
          selectedValues: state.subjects ?? [],
          items: SubjectEnum.values
              .map((subject) => MultiSelectItem(subject, subject.displayName))
              .toList(),
          onChanged: (values) {
            context.read<RegistrationBloc>().add(
              UpdateTeacherInfoEvent(subjects: values),
            );
          },
          validator: (values) {
            if (values == null || values.isEmpty) {
              return "Vui lòng chọn ít nhất 1 môn";
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),

        /// 🔹 Trình độ học vấn (SingleSelect)
        PrimaryDropdown<TeacherQualificationEnum>(
          hintText: "Trình độ học vấn",
          required: true,
          prefixIcon: Icons.school_outlined,
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
        SizedBox(height: 16.h),

        /// Create New School Option
        CheckboxListTile(
          title: Text('Tạo trường học mới'),
          value: state.isCreateNewSchool,
          onChanged: (value) {
            context.read<RegistrationBloc>().add(
              UpdateSchoolAdminInfoEvent(isCreateNewSchool: value),
            );
          },
        ),
        SizedBox(height: 16.h),

        if (state.isCreateNewSchool == true) ...[
          /// New School Form
          PrimaryTextField(
            controller: _newSchoolNameController,
            focusNode: _newSchoolNameFocus,
            isFocused: _newSchoolNameFocus.hasFocus,
            hintText: 'Nhập tên trường học',
            prefixIcon: Icons.school_outlined,
            required: true,
            validator: FieldValidators.required(fieldName: "Tên trường"),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateSchoolAdminInfoEvent(schoolName: v),
            ),
          ),
          SizedBox(height: 16.h),

          PrimaryTextField(
            controller: _newSchoolAddressController,
            focusNode: _newSchoolAddressFocus,
            isFocused: _newSchoolAddressFocus.hasFocus,
            hintText: 'Nhập địa chỉ trường học',
            prefixIcon: Icons.location_on_outlined,
            required: true,
            validator: FieldValidators.address(fieldName: "Địa chỉ trường"),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateSchoolAdminInfoEvent(schoolAddress: v),
            ),
          ),
          SizedBox(height: 16.h),

          PrimaryTextField(
            controller: _newSchoolPhoneController,
            focusNode: _newSchoolPhoneFocus,
            isFocused: _newSchoolPhoneFocus.hasFocus,
            hintText: 'Nhập số điện thoại trường học',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateSchoolAdminInfoEvent(schoolPhone: v),
            ),
          ),
          SizedBox(height: 16.h),

          PrimaryTextField(
            controller: _newSchoolDescriptionController,
            focusNode: _newSchoolDescriptionFocus,
            isFocused: _newSchoolDescriptionFocus.hasFocus,
            hintText: 'Nhập mô tả về trường học',
            prefixIcon: Icons.description_outlined,
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
                if (school != null) {
                  context.read<RegistrationBloc>().add(
                    UpdateSchoolIdEvent(
                      schoolId: school.id,
                      assignSchoolName: school.name,
                    ),
                  );
                } else {
                  context.read<RegistrationBloc>().add(
                    UpdateSchoolIdEvent(schoolId: null, assignSchoolName: null),
                  );
                }
              },
            ),
            SizedBox(height: 16.h),
          ],

          /// 🔹 Position in School (Dropdown dùng enum)
          PrimaryDropdown<SchoolAdminPositionEnum>(
            hintText: "Chức vụ tại trường",
            prefixIcon: Icons.work_outline,
            required: true,
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
              if (school != null) {
                context.read<RegistrationBloc>().add(
                  UpdateSchoolIdEvent(
                    schoolId: school.id,
                    assignSchoolName: school.name,
                  ),
                );
              } else {
                context.read<RegistrationBloc>().add(
                  UpdateSchoolIdEvent(schoolId: null, assignSchoolName: null),
                );
              }
            },
          ),
      ],
    );
  }

  Widget _buildLevelSelector(BuildContext context, RegistrationState state) {
    return PrimaryDropdown<EducationSystemLevelsEnum>(
      hintText: "Chọn cấp học",
      prefixIcon: Icons.school,
      value: state.educationLevel, // enum trực tiếp
      required: true,
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
