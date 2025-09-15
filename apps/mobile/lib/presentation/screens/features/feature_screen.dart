import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/under_development_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/card/action_card_widget.dart';

class FeatureScreen extends StatelessWidget {
  final dynamic user;

  const FeatureScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String role = user.roleName?.toLowerCase() ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeaderSection(context, role),
          const SizedBox(height: 24),

          // Main Features
          _buildSectionTitle(context, 'Chức năng chính'),
          const SizedBox(height: 16),
          _buildMainFeatures(context, role),
          const SizedBox(height: 24),

          // Additional Features
          _buildSectionTitle(context, 'Tính năng bổ sung'),
          const SizedBox(height: 16),
          _buildAdditionalFeatures(context, role),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, String role) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getRoleIcon(role), size: 32, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getRoleTitle(role),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getRoleDescription(role),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildMainFeatures(BuildContext context, String role) {
    final features = _getMainFeaturesForRole(role);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return ActionCardWidget(
          icon: feature['icon'],
          title: feature['title'],
          subtitle: feature['subtitle'],
          color: feature['color'],
          onTap: () => _navigateToFeature(context, feature['route']),
        );
      },
    );
  }

  Widget _buildAdditionalFeatures(BuildContext context, String role) {
    final features = _getAdditionalFeaturesForRole(role);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: feature['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(feature['icon'], size: 24, color: feature['color']),
            ),
            title: Text(
              feature['title'],
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Text(
              feature['subtitle'],
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () => _navigateToFeature(context, feature['route']),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getMainFeaturesForRole(String role) {
    switch (role) {
      case 'student':
      case 'học sinh':
        return [
          {
            'icon': Icons.schedule,
            'title': 'Thời khóa biểu',
            'subtitle': 'Xem lịch học hằng ngày',
            'color': AppColors.blue,
            'route': 'schedule',
          },
          {
            'icon': Icons.book,
            'title': 'Quá trình học tập',
            'subtitle': 'Theo dõi tiến độ học',
            'color': Colors.green,
            'route': 'learning_progress',
          },
          {
            'icon': Icons.assignment,
            'title': 'Bài tập',
            'subtitle': 'Danh sách bài tập',
            'color': Colors.orange,
            'route': 'assignments',
          },
          {
            'icon': Icons.grade,
            'title': 'Điểm số',
            'subtitle': 'Kết quả học tập',
            'color': Colors.purple,
            'route': 'grades',
          },
        ];

      case 'teacher':
      case 'giáo viên':
        return [
          {
            'icon': Icons.how_to_reg,
            'title': 'Điểm danh',
            'subtitle': 'Điểm danh học sinh',
            'color': AppColors.blue,
            'route': 'attendance',
          },
          {
            'icon': Icons.add_task,
            'title': 'Giao bài tập',
            'subtitle': 'Tạo bài tập mới',
            'color': Colors.green,
            'route': 'create_assignment',
          },
          {
            'icon': Icons.assignment_turned_in,
            'title': 'Chấm bài',
            'subtitle': 'Chấm điểm bài tập',
            'color': Colors.orange,
            'route': 'grading',
          },
          {
            'icon': Icons.class_,
            'title': 'Quản lý lớp',
            'subtitle': 'Thông tin lớp học',
            'color': Colors.purple,
            'route': 'class_management',
          },
        ];

      case 'admin':
      case 'quản trị viên':
        return [
          {
            'icon': Icons.people,
            'title': 'Quản lý người dùng',
            'subtitle': 'Thêm, sửa tài khoản',
            'color': AppColors.blue,
            'route': 'user_management',
          },
          {
            'icon': Icons.school,
            'title': 'Quản lý trường',
            'subtitle': 'Cài đặt hệ thống',
            'color': Colors.green,
            'route': 'school_management',
          },
          {
            'icon': Icons.bar_chart,
            'title': 'Thống kê',
            'subtitle': 'Báo cáo và phân tích',
            'color': Colors.orange,
            'route': 'statistics',
          },
          {
            'icon': Icons.settings,
            'title': 'Cài đặt hệ thống',
            'subtitle': 'Cấu hình ứng dụng',
            'color': Colors.purple,
            'route': 'system_settings',
          },
        ];

      default:
        return [
          {
            'icon': Icons.info,
            'title': 'Thông tin',
            'subtitle': 'Thông tin cơ bản',
            'color': AppColors.blue,
            'route': 'info',
          },
          {
            'icon': Icons.help,
            'title': 'Trợ giúp',
            'subtitle': 'Hướng dẫn sử dụng',
            'color': Colors.orange,
            'route': 'help',
          },
        ];
    }
  }

  List<Map<String, dynamic>> _getAdditionalFeaturesForRole(String role) {
    switch (role) {
      case 'student':
      case 'học sinh':
        return [
          {
            'icon': Icons.message,
            'title': 'Tin nhắn',
            'subtitle': 'Liên lạc với giáo viên và bạn bè',
            'color': Colors.blue,
            'route': 'messages',
          },
          {
            'icon': Icons.library_books,
            'title': 'Thư viện',
            'subtitle': 'Tài liệu và sách điện tử',
            'color': Colors.brown,
            'route': 'library',
          },
          {
            'icon': Icons.event,
            'title': 'Sự kiện',
            'subtitle': 'Hoạt động và sự kiện trường học',
            'color': Colors.indigo,
            'route': 'events',
          },
        ];

      case 'teacher':
      case 'giáo viên':
        return [
          {
            'icon': Icons.analytics,
            'title': 'Báo cáo',
            'subtitle': 'Thống kê và báo cáo lớp học',
            'color': Colors.blue,
            'route': 'reports',
          },
          {
            'icon': Icons.calendar_month,
            'title': 'Lịch dạy',
            'subtitle': 'Quản lý lịch giảng dạy',
            'color': Colors.green,
            'route': 'teaching_schedule',
          },
          {
            'icon': Icons.folder,
            'title': 'Tài liệu',
            'subtitle': 'Quản lý tài liệu giảng dạy',
            'color': Colors.orange,
            'route': 'documents',
          },
        ];

      case 'admin':
      case 'quản trị viên':
        return [
          {
            'icon': Icons.security,
            'title': 'Bảo mật',
            'subtitle': 'Quản lý bảo mật hệ thống',
            'color': Colors.red,
            'route': 'security',
          },
          {
            'icon': Icons.backup,
            'title': 'Sao lưu dữ liệu',
            'subtitle': 'Backup và restore',
            'color': Colors.blue,
            'route': 'backup',
          },
          {
            'icon': Icons.update,
            'title': 'Cập nhật hệ thống',
            'subtitle': 'Kiểm tra và cập nhật',
            'color': Colors.green,
            'route': 'system_update',
          },
        ];

      default:
        return [
          {
            'icon': Icons.notifications,
            'title': 'Thông báo',
            'subtitle': 'Quản lý thông báo',
            'color': Colors.orange,
            'route': 'notifications',
          },
        ];
    }
  }

  String _getRoleTitle(String role) {
    switch (role) {
      case 'student':
      case 'học sinh':
        return 'Chức năng Học sinh';
      case 'teacher':
      case 'giáo viên':
        return 'Chức năng Giáo viên';
      case 'admin':
      case 'quản trị viên':
        return 'Chức năng Quản trị';
      default:
        return 'Chức năng';
    }
  }

  String _getRoleDescription(String role) {
    switch (role) {
      case 'student':
      case 'học sinh':
        return 'Các tính năng hỗ trợ học tập và phát triển';
      case 'teacher':
      case 'giáo viên':
        return 'Công cụ hỗ trợ giảng dạy và quản lý lớp học';
      case 'admin':
      case 'quản trị viên':
        return 'Quản lý và điều hành hệ thống trường học';
      default:
        return 'Các tính năng và tiện ích hữu ích';
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'student':
      case 'học sinh':
        return Icons.school;
      case 'teacher':
      case 'giáo viên':
        return Icons.person_pin;
      case 'admin':
      case 'quản trị viên':
        return Icons.admin_panel_settings;
      default:
        return Icons.apps;
    }
  }

  void _navigateToFeature(BuildContext context, String route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UnderDevelopmentScreen(featureName: route),
      ),
    );
  }
}
