import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/widgets/class_member_action.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/widgets/class_member_form.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/widgets/class_member_mode_tab.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/widgets/class_member_student_table.dart';

class ClassMemberDialog extends StatelessWidget {
  final String? initialClassId;
  final String schoolId;
  final bool isTeacher;

  const ClassMemberDialog({
    super.key,
    this.initialClassId,
    required this.schoolId,
    this.isTeacher = false,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để tính % width/height
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.9;
    final dialogHeight = screenSize.height * 0.8;

    return BlocListener<ClassMemberBloc, ClassMemberState>(
      listener: (context, state) {
        if (state is ClassMemberSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${state.message}\n'
                'Thành công: ${state.successCount}, '
                'Thất bại: ${state.failedCount}',
              ),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.of(context).pop(true);
        } else if (state is ClassMemberError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Dialog(
        insetPadding: const EdgeInsets.all(16), // tránh tràn mép
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth,
            maxHeight: dialogHeight,
          ),
          child: Column(
            children: [
              _buildHeader(context),

              Expanded(child: _buildContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  /// Header có nút đóng
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.group, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Quản lý thành viên lớp',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.close),
            tooltip: 'Đóng',
          ),
        ],
      ),
    );
  }

  /// Nội dung chính
  Widget _buildContent(BuildContext context) {
    return BlocBuilder<ClassMemberBloc, ClassMemberState>(
      builder: (context, state) {
        if (state is ClassMemberInitial || state is ClassMemberLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ClassMemberLoaded) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Phần nội dung chính scroll được
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (!isTeacher)
                          ClassMemberModeTabs(currentMode: state.mode),

                        if (!isTeacher) const SizedBox(height: 24),

                        // Form chọn lớp / thao tác
                        ClassMemberForm(
                          mode: state.mode,
                          schoolId: schoolId,
                          initialClassId: initialClassId,
                          isTeacher: isTeacher,
                        ),

                        const SizedBox(height: 24),

                        // Bảng học sinh, có height cố định để tránh lỗi render
                        SizedBox(
                          height: 350,
                          child: ClassMemberStudentTable(
                            students: state.filteredStudents,
                            selectedIds: state.selectedStudentIds,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Nút hành động cố định phía dưới
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ClassMemberActions(
                    canSubmit: state.canSubmit,
                    isSubmitting: state.isSubmitting,
                    mode: state.mode,
                  ),
                ),
              ],
            ),
          );
        }

        // Fallback lỗi
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.red),
              const SizedBox(height: 16),
              Text(
                'Có lỗi xảy ra, vui lòng thử lại.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
