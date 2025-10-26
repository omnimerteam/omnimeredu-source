import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/base_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/school_admin_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/staff_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/teacher_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/user_profile/cubit/user_profile_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/user_profile/cubit/user_profile_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/user_profile/widgets/edit_user_profile_form.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/image_picker/app_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() => _selectedImage = File(image.path));

      if (mounted) {
        context.read<UserProfileCubit>().updateAvatar(_selectedImage!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().loadUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại',
            onPressed: () {
              final cubit = context.read<UserProfileCubit>();
              cubit.refresh();
            },
          ),
        ],
      ),
      body: BlocConsumer<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is UserProfileAvatarUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật ảnh đại diện thành công'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserProfileLoaded ||
              state is UserProfileAvatarUploading ||
              state is UserProfileAvatarUpdated ||
              state is UserProfileUpdated) {
            // Chọn user dựa trên state
            BaseUserEntity user;
            bool isUploading = false;

            if (state is UserProfileLoaded) {
              user = state.user;
            } else if (state is UserProfileAvatarUploading) {
              user = state.user;
              isUploading = true;
            } else if (state is UserProfileUpdated) {
              user = state.user;
            } else {
              user = (state as UserProfileAvatarUpdated).user;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar
                  Center(
                    child: Stack(
                      children: [
                        ImagePickerWidget(
                          avatarUrl: user.avatarUrl,
                          imageFile: _selectedImage,
                          onTap: isUploading ? () {} : _pickImage,
                          label: 'Ảnh đại diện',
                          size: 120,
                          isCircular: true,
                        ),
                        if (isUploading)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Thông tin cơ bản
                  _buildSectionTitle('Thông tin cơ bản'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow('Họ và tên', user.fullName),
                    _buildInfoRow('Email', user.email ?? 'Chưa cập nhật'),
                    _buildInfoRow(
                      'Số điện thoại',
                      user.phone ?? 'Chưa cập nhật',
                    ),
                    _buildInfoRow(
                      'Giới tính',
                      DisplayMapper.genderName(user.gender),
                    ),
                    _buildInfoRow(
                      'Ngày sinh',
                      user.birthday != null
                          ? DateFormat('dd/MM/yyyy').format(user.birthday!)
                          : 'Chưa cập nhật',
                    ),
                    _buildInfoRow('Địa chỉ', user.address ?? 'Chưa cập nhật'),
                    _buildInfoRow(
                      'Trạng thái',
                      user.isVerified ? 'Đã xác thực' : 'Chưa xác thực',
                      valueColor: user.isVerified
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Thông tin theo vai trò
                  _buildRoleSpecificInfo(user),

                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) => BlocProvider.value(
                                value: context.read<UserProfileCubit>(),
                                child: EditUserProfileDialog(user: user),
                              ),
                            );
                          },

                          icon: const Icon(Icons.edit),
                          label: const Text('Cập nhật thông tin'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/profile/change-password',
                          ),
                          icon: const Icon(Icons.lock_outline),
                          label: const Text('Đổi mật khẩu'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Không thể tải thông tin người dùng'),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    ),
  );

  Widget _buildInfoCard(List<Widget> children) => Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: children),
    ),
  );

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildRoleSpecificInfo(BaseUserEntity user) {
    switch (user.roleKey) {
      case 'Student':
        return _buildStudentInfo(user as StudentEntity);
      case 'Teacher':
        return _buildTeacherInfo(user as TeacherEntity);
      case 'SchoolAdmin':
        return _buildSchoolAdminInfo(user as SchoolAdminEntity);
      case 'Staff':
        return _buildStaffInfo(user as StaffEntity);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStudentInfo(StudentEntity student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Thông tin học sinh'),
        const SizedBox(height: 12),
        _buildInfoCard([
          _buildInfoRow('Cấp học', student.educationLevel.displayName),
          if (student.gradeGroup != null)
            _buildInfoRow('Khối', student.gradeGroup!.displayName),
          _buildInfoRow(
            'Tên phụ huynh',
            student.guardianName ?? 'Chưa cập nhật',
          ),
          _buildInfoRow(
            'SĐT phụ huynh',
            student.guardianPhone ?? 'Chưa cập nhật',
          ),
          if (student.registeredExtraFees != null &&
              student.registeredExtraFees!.isNotEmpty)
            _buildInfoRow(
              'Phí phụ thu',
              '${student.registeredExtraFees!.length} khoản',
            ),
          if (student.registeredDiscounts != null &&
              student.registeredDiscounts!.isNotEmpty)
            _buildInfoRow(
              'Ưu đãi',
              '${student.registeredDiscounts!.length} khoản',
            ),
        ]),
      ],
    );
  }

  Widget _buildTeacherInfo(TeacherEntity teacher) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Thông tin giáo viên'),
        const SizedBox(height: 12),
        _buildInfoCard([
          if (teacher.qualification != null)
            _buildInfoRow('Trình độ', teacher.qualification!.displayName),
          if (teacher.subjects != null && teacher.subjects!.isNotEmpty)
            _buildInfoRow(
              'Môn giảng dạy',
              teacher.subjects!.map((s) => s.displayName).join(', '),
            ),
        ]),
      ],
    );
  }

  Widget _buildSchoolAdminInfo(SchoolAdminEntity admin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Thông tin quản trị viên'),
        const SizedBox(height: 12),
        _buildInfoCard([
          if (admin.position != null)
            _buildInfoRow('Chức vụ', admin.position!.displayName),
        ]),
      ],
    );
  }

  Widget _buildStaffInfo(StaffEntity staff) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Thông tin nhân viên'),
        const SizedBox(height: 12),
        _buildInfoCard([_buildInfoRow('Vai trò', 'Nhân viên')]),
      ],
    );
  }
}
