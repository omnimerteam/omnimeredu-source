import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/class_teacher_assign_entity.dart';

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
    final hasAttendance = classAssignment.isHaveAttendance;
    final isMainTeacher = classAssignment.isMain;

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            /// 🔹 Icon lớp học
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.class_outlined,
                color: Colors.blue.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            /// 🔹 Thông tin lớp
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClassTitle(isMainTeacher),
                  const SizedBox(height: 4),
                  _buildClassDetails(),
                  if (!hasAttendance) _buildAttendanceWarning(),
                ],
              ),
            ),

            /// 🔹 Menu tác vụ
            _buildMenu(hasAttendance),
          ],
        ),
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
            // Cột trái: Grade
            Expanded(
              child: Text(
                'Khối: ${entity.gradeName}',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            const SizedBox(width: 16),

            // Cột phải: Sĩ số
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
  Widget _buildMenu(bool hasAttendance) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey.shade700),
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
        _menuItem(
          value: 'view_students',
          icon: Icons.people_outline,
          color: Colors.orange.shade700,
          text: 'Xem chi tiết học sinh',
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
