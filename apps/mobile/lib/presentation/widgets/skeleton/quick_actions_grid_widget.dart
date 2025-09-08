import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/card/action_card_widget.dart';

class QuickActionsGridWidget extends StatelessWidget {
  final String role;

  const QuickActionsGridWidget({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final actions = _getActionsForRole(role);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return ActionCardWidget(
          icon: action['icon'],
          title: action['title'],
          subtitle: action['subtitle'],
          color: action['color'],
          onTap: action['onTap'],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getActionsForRole(String role) {
    switch (role) {
      case 'student':
      case 'học sinh':
        return [
          {
            'icon': Icons.assignment,
            'title': 'Bài tập',
            'subtitle': 'Xem bài tập được giao',
            'color': AppColors.blue,
            'onTap': () => print('Navigate to assignments'),
          },
          {
            'icon': Icons.grade,
            'title': 'Điểm số',
            'subtitle': 'Xem kết quả học tập',
            'color': Colors.green,
            'onTap': () => print('Navigate to grades'),
          },
          {
            'icon': Icons.schedule,
            'title': 'Thời khóa biểu',
            'subtitle': 'Lịch học trong tuần',
            'color': Colors.orange,
            'onTap': () => print('Navigate to schedule'),
          },
          {
            'icon': Icons.message,
            'title': 'Tin nhắn',
            'subtitle': 'Liên lạc với giáo viên',
            'color': Colors.purple,
            'onTap': () => print('Navigate to messages'),
          },
        ];

      case 'teacher':
      case 'giáo viên':
        return [
          {
            'icon': Icons.class_,
            'title': 'Lớp học',
            'subtitle': 'Quản lý lớp học',
            'color': AppColors.blue,
            'onTap': () => print('Navigate to classes'),
          },
          {
            'icon': Icons.assignment_turned_in,
            'title': 'Chấm bài',
            'subtitle': 'Chấm điểm bài tập',
            'color': Colors.green,
            'onTap': () => print('Navigate to grading'),
          },
          {
            'icon': Icons.add_task,
            'title': 'Tạo bài tập',
            'subtitle': 'Giao bài tập mới',
            'color': Colors.orange,
            'onTap': () => print('Navigate to create assignment'),
          },
          {
            'icon': Icons.how_to_reg,
            'title': 'Điểm danh',
            'subtitle': 'Điểm danh học sinh',
            'color': Colors.purple,
            'onTap': () => print('Navigate to attendance'),
          },
        ];

      case 'admin':
      case 'quản trị viên':
        return [
          {
            'icon': Icons.people,
            'title': 'Quản lý người dùng',
            'subtitle': 'Thêm/sửa tài khoản',
            'color': AppColors.blue,
            'onTap': () => print('Navigate to user management'),
          },
          {
            'icon': Icons.school,
            'title': 'Quản lý trường',
            'subtitle': 'Cài đặt hệ thống',
            'color': Colors.green,
            'onTap': () => print('Navigate to school management'),
          },
          {
            'icon': Icons.bar_chart,
            'title': 'Thống kê',
            'subtitle': 'Báo cáo tổng quan',
            'color': Colors.orange,
            'onTap': () => print('Navigate to statistics'),
          },
          {
            'icon': Icons.settings,
            'title': 'Cài đặt',
            'subtitle': 'Cấu hình ứng dụng',
            'color': Colors.purple,
            'onTap': () => print('Navigate to settings'),
          },
        ];

      default:
        return [
          {
            'icon': Icons.info,
            'title': 'Thông tin',
            'subtitle': 'Xem thông tin cơ bản',
            'color': AppColors.blue,
            'onTap': () => print('Navigate to info'),
          },
          {
            'icon': Icons.help,
            'title': 'Trợ giúp',
            'subtitle': 'Hướng dẫn sử dụng',
            'color': Colors.orange,
            'onTap': () => print('Navigate to help'),
          },
        ];
    }
  }
}
