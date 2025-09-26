import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/personnel_entity.dart';
import '../bloc/personnel_management_bloc.dart';
import '../bloc/personnel_management_event.dart';
import '../bloc/personnel_management_state.dart';

class PersonnelDetailsBottomSheet extends StatelessWidget {
  const PersonnelDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonnelManagementBloc, PersonnelManagementState>(
      builder: (context, state) {
        if (state is PersonnelManagementLoaded) {
          if (state.isLoadingDetails) {
            return _buildLoadingContent(context);
          }

          if (state.detailsErrorMessage != null) {
            return _buildErrorContent(context, state.detailsErrorMessage!);
          }

          if (state.selectedPersonnelDetails != null) {
            return _buildPersonnelDetails(
              context,
              state.selectedPersonnelDetails!,
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(24),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải thông tin nhân sự...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String errorMessage) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Có lỗi xảy ra',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<PersonnelManagementBloc>().add(
                  HidePersonnelDetailsEvent(),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonnelDetails(
    BuildContext context,
    PersonnelEntity personnel,
  ) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Thông tin nhân sự',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<PersonnelManagementBloc>().add(
                          HidePersonnelDetailsEvent(),
                        );
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar and basic info
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    personnel.fullName.isNotEmpty
                                        ? personnel.fullName
                                              .substring(0, 1)
                                              .toUpperCase()
                                        : '?',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                              // Status indicator
                              if (!personnel.isVerified)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  personnel.fullName,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getRoleColor(
                                      personnel.roleKey,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    DisplayMapper.personnelName(
                                      personnel.roleName,
                                    ),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: _getRoleColor(personnel.roleKey),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (!personnel.isVerified) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Đình chỉ công tác',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Information sections
                      _buildInfoSection(context, 'Thông tin cá nhân', [
                        if (personnel.email?.isNotEmpty == true)
                          _buildInfoItem(
                            context,
                            Icons.email_outlined,
                            'Email',
                            personnel.email!,
                          ),
                        if (personnel.birthday != null)
                          _buildInfoItem(
                            context,
                            Icons.cake_outlined,
                            'Ngày sinh',
                            personnel.birthday != null
                                ? '${AppConstants.dateFormatter.format(personnel.birthday!)} ${_calculateAge(personnel.birthday!)}'
                                : 'Không có dữ liệu',
                          ),
                        if (personnel.gender != null)
                          _buildInfoItem(
                            context,
                            personnel.gender == 'Male'
                                ? Icons.male
                                : Icons.female,
                            'Giới tính',
                            DisplayMapper.genderName(personnel.gender),
                          ),
                        if (personnel.phone?.isNotEmpty == true)
                          _buildInfoItem(
                            context,
                            Icons.phone_outlined,
                            'Số điện thoại',
                            personnel.phone!,
                          ),
                        if (personnel.address?.isNotEmpty == true)
                          _buildInfoItem(
                            context,
                            Icons.location_on_outlined,
                            'Địa chỉ',
                            personnel.address!,
                          ),
                      ]),

                      const SizedBox(height: 24),

                      _buildInfoSection(context, 'Thông tin công việc', [
                        _buildInfoItem(
                          context,
                          Icons.work_outlined,
                          'Vai trò',
                          DisplayMapper.personnelName(personnel.roleName),
                        ),
                        if (personnel.position != null)
                          _buildInfoItem(
                            context,
                            Icons.admin_panel_settings_outlined,
                            'Chức vụ',
                            personnel.position!.displayName,
                          ),
                        if (personnel.qualification != null)
                          _buildInfoItem(
                            context,
                            Icons.school_outlined,
                            'Trình độ',
                            personnel.qualification!.displayName,
                          ),
                        if (personnel.subjects?.isNotEmpty == true)
                          _buildInfoItem(
                            context,
                            Icons.subject_outlined,
                            'Môn học',
                            personnel.subjects!
                                .map((s) => s.displayName)
                                .join(', '),
                          ),
                      ]),

                      const SizedBox(height: 24),

                      _buildInfoSection(context, 'Thông tin hệ thống', [
                        _buildInfoItem(
                          context,
                          Icons.access_time_outlined,
                          'Ngày tạo',
                          personnel.createdAt != null
                              ? AppConstants.dateTimeFormatter.format(
                                  personnel.createdAt!,
                                )
                              : 'Không có dữ liệu',
                        ),
                        _buildInfoItem(
                          context,
                          Icons.update_outlined,
                          'Cập nhật lần cuối',
                          personnel.updatedAt != null
                              ? AppConstants.dateTimeFormatter.format(
                                  personnel.updatedAt!,
                                )
                              : 'Không có dữ liệu',
                        ),
                      ]),

                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<PersonnelManagementBloc>().add(
                                  ShowAssignmentDialogEvent(personnel),
                                );
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.assignment_outlined),
                              label: const Text('Phân công việc'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.secondary,
                                foregroundColor: theme.colorScheme.onSecondary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calculateAge(DateTime birthday) {
    final now = DateTime.now();
    final age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      return '(${age - 1} tuổi)';
    }
    return '($age tuổi)';
  }

  Color _getRoleColor(String roleKey) {
    switch (roleKey) {
      case 'SchoolAdmin':
        return Colors.purple;
      case 'Teacher':
        return Colors.blue;
      case 'Security':
        return Colors.green;
      case 'Nurse':
        return Colors.red;
      case 'CanteenStaff':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
