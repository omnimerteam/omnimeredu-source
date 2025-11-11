import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnimereduapp/presentation/screens/dashboard/teacher/cubit/teacher_classes_cubit.dart';
import 'package:omnimereduapp/presentation/screens/dashboard/teacher/cubit/teacher_classes_state.dart';
import '../../../../../domain/entities/teaching_assignment/class_teacher_assign_entity.dart';
import '../../../../../domain/entities/dashboard/teacher/teacher_dashboard_data_entity.dart';
import '../../cubit/dashboard_cubit.dart';
import '../../cubit/dashboard_state.dart';

class TeacherClassItem extends StatelessWidget {
  final ClassTeacherAssignEntity classAssignment;
  final VoidCallback onInitializeAttendance;
  final VoidCallback onViewAttendance;
  final VoidCallback onViewStudents;

  const TeacherClassItem({
    Key? key,
    required this.classAssignment,
    required this.onInitializeAttendance,
    required this.onViewAttendance,
    required this.onViewStudents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 🔹 Listen to both cubits để update UI realtime
    return BlocListener<TeacherClassesCubit, TeacherClassesState>(
      listener: (context, state) => _handleClassesStateChange(context, state),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, dashboardState) {
          // 🔹 Lấy data mới nhất từ dashboard
          final currentClass = _getCurrentClassData(dashboardState);
          final hasAttendance = currentClass.isHaveAttendance;
          final isMainTeacher = currentClass.isMain;

          // 🔹 Check nếu đang loading cho class này
          final isLoading = _isClassLoading(context);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasAttendance ? Colors.grey.shade300 : Colors.red,
                width: hasAttendance ? 1 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      /// 🔹 Icon lớp học với loading overlay
                      _buildClassIcon(isLoading),
                      const SizedBox(width: 12),

                      /// 🔹 Thông tin lớp
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildClassTitle(isMainTeacher),
                            const SizedBox(height: 4),
                            _buildClassDetails(),
                            if (!hasAttendance && !isLoading)
                              _buildAttendanceWarning(),
                            if (isLoading) _buildLoadingIndicator(),
                          ],
                        ),
                      ),

                      /// 🔹 Menu tác vụ (disable khi loading)
                      _buildMenu(hasAttendance, isLoading),
                    ],
                  ),
                ),

                // 🔹 Loading overlay khi đang xử lý
                if (isLoading) _buildLoadingOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔹 Xử lý state changes từ TeacherClassesCubit
  void _handleClassesStateChange(
    BuildContext context,
    TeacherClassesState state,
  ) {
    if (state is AttendanceInitialized && state.classId == classAssignment.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(state.message)),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (state is AttendanceInitializationError &&
        state.classId == classAssignment.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(state.message)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }

    if (state is AttendanceDeleted && state.classId == classAssignment.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(state.message)),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (state is AttendanceDeletionError &&
        state.classId == classAssignment.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(state.message)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// 🔹 Lấy data class mới nhất từ dashboard
  ClassTeacherAssignEntity _getCurrentClassData(DashboardState dashboardState) {
    if (dashboardState is DashboardLoaded &&
        dashboardState.data is TeacherDashboardDataEntity) {
      final data = dashboardState.data as TeacherDashboardDataEntity;
      final classes = data.classAssignment ?? [];

      // Tìm class với ID tương ứng
      return classes.firstWhere(
        (c) => c.id == classAssignment.id,
        orElse: () => classAssignment,
      );
    }
    return classAssignment;
  }

  /// 🔹 Check xem class này có đang loading không
  bool _isClassLoading(BuildContext context) {
    final state = context.watch<TeacherClassesCubit>().state;

    if (state is InitializingAttendance &&
        state.classId == classAssignment.id) {
      return true;
    }
    if (state is DeletingAttendance && state.classId == classAssignment.id) {
      return true;
    }
    return false;
  }

  /// Icon lớp học với animation khi loading
  Widget _buildClassIcon(bool isLoading) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isLoading ? Colors.grey.shade100 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          : Icon(Icons.class_outlined, color: Colors.blue.shade700, size: 24),
    );
  }

  /// Loading indicator dưới class details
  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Đang xử lý...',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Loading overlay che toàn bộ card
  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  /// Tiêu đề lớp + badge "Chủ nhiệm"
  Widget _buildClassTitle(bool isMainTeacher) {
    return Row(
      children: [
        Flexible(
          child: Text(
            classAssignment.classEntity.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isMainTeacher) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Text(
              'Chủ nhiệm',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Chi tiết lớp: mã, khối, sĩ số, môn
  Widget _buildClassDetails() {
    final entity = classAssignment.classEntity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mã lớp: ${entity.code}',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Khối: ${entity.gradeName}',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Sĩ số: ${entity.studentsCount}/${entity.maxStudents}',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],
        ),
        Text(
          'Môn: ${classAssignment.subject.displayName}',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  /// Thông báo chưa lập bảng điểm danh
  Widget _buildAttendanceWarning() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: Colors.red.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            'Chưa lập bảng điểm danh',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Menu tác vụ (PopupMenu)
  Widget _buildMenu(bool hasAttendance, bool isLoading) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: isLoading ? Colors.grey.shade400 : Colors.grey.shade700,
      ),
      enabled: !isLoading, // Disable menu khi loading
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(-10, 40),
      itemBuilder: (context) => [
        if (!hasAttendance)
          _menuItem(
            value: 'initialize_attendance',
            icon: Icons.assignment_add,
            color: Colors.blue.shade700,
            text: 'Tạo bảng điểm danh',
          ),
        if (hasAttendance)
          _menuItem(
            value: 'view_attendance',
            icon: Icons.assignment_outlined,
            color: Colors.green.shade700,
            text: 'Xem bảng điểm danh',
          ),
        if (hasAttendance)
          _menuItem(
            value: 'delete_attendance',
            icon: Icons.delete_outline,
            color: Colors.red.shade700,
            text: 'Xóa bảng điểm danh',
          ),
        _menuItem(
          value: 'view_students',
          icon: Icons.people_outline,
          color: Colors.orange.shade700,
          text: 'Chi tiết lớp học',
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'initialize_attendance':
            onInitializeAttendance();
            break;
          case 'view_attendance':
            onViewAttendance();
            break;
          case 'delete_attendance':
            // TODO: Implement delete
            break;
          case 'view_students':
            onViewStudents();
            break;
        }
      },
    );
  }

  PopupMenuItem<String> _menuItem({
    required String value,
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}
