import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_state.dart';

class StepReview extends StatelessWidget {
  final RegistrationState state;

  const StepReview({super.key, required this.state});

  Widget _reviewItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xem lại thông tin',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Basic info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông tin cơ bản',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                _reviewItem('Email', state.email),
                _reviewItem('Họ và tên', state.fullName),
                _reviewItem(
                  'Giới tính',
                  DisplayMapper.genderName(state.gender),
                ),
                if (state.phone != null) _reviewItem('SĐT', state.phone),
                if (state.birthday != null)
                  _reviewItem(
                    'Ngày sinh',
                    '${state.birthday!.day}/${state.birthday!.month}/${state.birthday!.year}',
                  ),
                if (state.address != null)
                  _reviewItem('Địa chỉ', state.address),
                if (state.avatarFile != null)
                  _reviewItem('Ảnh đại diện', 'Đã chọn'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (state.selectedRoleId != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin công việc',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _reviewItem(
                    'Công việc',
                    DisplayMapper.roleName(state.selectedRoleName!),
                  ),
                  if (state.assignSchoolName != null &&
                      !state.isCreateNewSchool)
                    _reviewItem(
                      'Trường ${state.selectedRoleName!.toLowerCase() != 'student' ? 'công tác' : ''}',
                      state.assignSchoolName,
                    ),
                  if (state.selectedRoleName!.toLowerCase() == 'student') ...[
                    _reviewItem(
                      'Cấp học',
                      DisplayMapper.educationLevelName(state.educationLevel),
                    ),
                    if (state.classId != null)
                      _reviewItem('Lớp', state.assignClassName),
                    if (state.grade != null) _reviewItem('Khối', state.grade),
                    _reviewItem('Tên phụ huynh', state.guardianName),
                    _reviewItem('SĐT phụ huynh', state.guardianPhone),
                  ],
                  if (state.selectedRoleName!.toLowerCase() == 'teacher') ...[
                    _reviewItem(
                      'Trình độ',
                      DisplayMapper.teacherQualificationName(
                        state.qualification,
                      ),
                    ),
                    _reviewItem(
                      'Môn giảng dạy',
                      (state.subjects != null && state.subjects!.isNotEmpty)
                          ? state.subjects!
                                .map((s) => DisplayMapper.subjectsName(s) ?? '')
                                .where((name) => name.isNotEmpty)
                                .join(', ')
                          : 'Chưa chọn',
                    ),
                  ],
                  if (state.selectedRoleName!.toLowerCase() ==
                      'schooladmin') ...[
                    if (!state.isCreateNewSchool) ...[
                      _reviewItem('Chức vụ', state.position),
                    ] else ...[
                      _reviewItem('Tên trường', state.schoolName),
                      _reviewItem(
                        'Cấp trường',
                        DisplayMapper.educationLevelName(state.schoolLevel),
                      ),
                      _reviewItem('Địa chỉ trường', state.schoolAddress),
                      if (state.schoolPhone != null)
                        _reviewItem('SĐT trường', state.schoolPhone),
                      if (state.schoolDescription != null)
                        _reviewItem('Mô tả trường', state.schoolDescription),
                    ],
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
