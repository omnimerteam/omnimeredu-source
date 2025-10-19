import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/teacher/teacher_dashboard_data_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/class_teacher_assign_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/cubit/teacher_classes_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/cubit/teacher_classes_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/widgets/teacher_classes_section.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/widgets/teacher_dashboard_quick_access.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';

class TeacherDashboard extends StatelessWidget {
  final AuthUserEntity user;
  final TeacherDashboardDataEntity? data;
  final bool isLoading;

  const TeacherDashboard({
    Key? key,
    required this.user,
    required this.data,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherClassesCubit, TeacherClassesState>(
      listener: (context, state) {
        if (state is AttendanceInitialized) {
          _showSnack(context, state.message, Colors.green);
        }
        if (state is AttendanceInitializationError) {
          _showSnack(context, state.message, Colors.red);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            TeacherClassesSection(
              isLoading: isLoading,
              state: state,
              classes: data?.classAssignment ?? [],
              onInitializeAttendance: (assignment) =>
                  _showInitializeAttendanceConfirmation(context, assignment),
              onViewAttendance: (assignment) =>
                  _handleViewAttendance(context, assignment),
              onViewStudents: (assignment) =>
                  _navigateToClassDetail(context, assignment),
            ),
            const SizedBox(height: 32),
            TeacherDashboardQuickAccess(),
          ],
        );
      },
    );
  }

  /// 👉 Gọi sang TeacherAttendance màn chính
  void _handleViewAttendance(
    BuildContext context,
    ClassTeacherAssignEntity assignment,
  ) {
    final mainState = context.findAncestorStateOfType<MainScreenState>();
    if (mainState != null) {
      mainState.openTeacherAttendance(
        assignment.classEntity.id,
        DateTime.now(),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Không tìm thấy classId")));
    }
  }

  void _showSnack(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInitializeAttendanceConfirmation(
    BuildContext context,
    ClassTeacherAssignEntity assignment,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận tạo bảng điểm danh'),
        content: Text(
          'Bạn có chắc chắn muốn tạo bảng điểm danh cho lớp "${assignment.classEntity.name}"?',
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  text: 'Hủy',
                  type: AppButtonType.cancel,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: AppButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.read<TeacherClassesCubit>().initializeAttendance(
                      classId: assignment.classEntity.id,
                      schoolId: assignment.schoolId,
                    );
                  },
                  text: 'Xác nhận',
                  type: AppButtonType.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToClassDetail(
    BuildContext context,
    ClassTeacherAssignEntity assignment,
  ) {
    Navigator.pushNamed(
      context,
      '/school-admin/classes/detail',
      arguments: {'classId': assignment.classEntity.id},
    );
  }
}
