import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import '../bloc/student_management_bloc.dart';
import '../bloc/student_management_event.dart';
import '../bloc/student_management_state.dart';

class StudentDetailsBottomSheet extends StatelessWidget {
  const StudentDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentManagementBloc, StudentManagementState>(
      builder: (context, state) {
        if (state is StudentManagementLoaded) {
          if (state.isLoadingDetails) {
            return _buildLoadingContent(context);
          }

          if (state.detailsErrorMessage != null) {
            return _buildErrorContent(context, state.detailsErrorMessage!);
          }

          if (state.selectedStudentDetails != null) {
            return _buildStudentDetails(context, state.selectedStudentDetails!);
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
            Text('Đang tải thông tin học sinh...'),
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
                context.read<StudentManagementBloc>().add(
                  HideStudentDetailsEvent(),
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

  Widget _buildStudentDetails(BuildContext context, StudentEntity student) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
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
                        'Thông tin học sinh',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<StudentManagementBloc>().add(
                          HideStudentDetailsEvent(),
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
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary.withOpacity(0.1),
                            ),
                            child: Center(
                              child: Text(
                                student.fullName.isNotEmpty == true
                                    ? student.fullName
                                          .substring(0, 1)
                                          .toUpperCase()
                                    : '?',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.fullName.isEmpty
                                      ? student.fullName
                                      : 'Không có tên',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (student.gender != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: student.gender == 'male'
                                          ? Colors.blue.withOpacity(0.1)
                                          : Colors.pink.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      student.gender == 'male' ? 'Nam' : 'Nữ',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: student.gender == 'male'
                                                ? Colors.blue
                                                : Colors.pink,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Information sections
                      _buildInfoSection(context, 'Thông tin cá nhân', [
                        if (student.birthday != null)
                          _buildInfoItem(
                            context,
                            Icons.cake_outlined,
                            'Ngày sinh',
                            '${DateFormat('dd/MM/yyyy').format(student.birthday!)} ${_calculateAge(student.birthday!)}',
                          ),
                        if (student.phone?.isNotEmpty == true)
                          _buildInfoItem(
                            context,
                            Icons.phone_outlined,
                            'Số điện thoại',
                            student.phone!,
                          ),
                        // if (student.email?.isNotEmpty == true)
                        //   _buildInfoItem(
                        //     context,
                        //     Icons.email_outlined,
                        //     'Email',
                        //     student.email!,
                        //   ),
                        if (student.address?.isNotEmpty == true)
                          _buildInfoItem(
                            context,
                            Icons.location_on_outlined,
                            'Địa chỉ',
                            student.address!,
                          ),
                      ]),

                      const SizedBox(height: 24),

                      _buildInfoSection(context, 'Thông tin học tập', [
                        if (student.gradeGroup != null)
                          _buildInfoItem(
                            context,
                            Icons.school_outlined,
                            'Khối lớp',
                            student.gradeGroup!.displayName,
                          ),
                        // _buildInfoItem(
                        //   context,
                        //   Icons.class_outlined,
                        //   'Lớp học',
                        //   student.className ?? 'Chưa phân lớp',
                        // ),
                        // if (student.schoolName?.isNotEmpty == true)
                        //   _buildInfoItem(
                        //     context,
                        //     Icons.account_balance_outlined,
                        //     'Trường học',
                        //     student.schoolName!,
                        //   ),
                      ]),

                      const SizedBox(height: 24),

                      _buildInfoSection(context, 'Thông tin hệ thống', [
                        if (student.id != null)
                          _buildInfoItem(
                            context,
                            Icons.badge_outlined,
                            'Mã học sinh',
                            student.id!,
                          ),
                        if (student.createdAt != null)
                          _buildInfoItem(
                            context,
                            Icons.access_time_outlined,
                            'Ngày tạo',
                            DateFormat(
                              'dd/MM/yyyy HH:mm',
                            ).format(student.createdAt!),
                          ),
                        if (student.updatedAt != null)
                          _buildInfoItem(
                            context,
                            Icons.update_outlined,
                            'Cập nhật lần cuối',
                            DateFormat(
                              'dd/MM/yyyy HH:mm',
                            ).format(student.updatedAt!),
                          ),
                      ]),

                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<StudentManagementBloc>().add(
                                  LoadStudentForEditEvent(student),
                                );
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Chỉnh sửa'),
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
}
