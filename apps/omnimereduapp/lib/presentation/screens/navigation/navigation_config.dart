import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../main_feature/main_feature_screen.dart';
import '../more/more_screen.dart';
import '../qr_attendance/student/qr_scanner_screen.dart';
import '../placeholders/admin_report_screen.dart';
import '../placeholders/admin_management_screen.dart';
import '../placeholders/teacher_classes_list_screen.dart';
import '../placeholders/student_learning_screen.dart';
import '../placeholders/staff_tasks_screen.dart';

/// Cấu hình navigation item
class NavItem {
  final IconData icon;
  final String label;
  final Widget screen;

  const NavItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}

/// Lấy navigation items theo role
class NavigationConfig {
  static List<NavItem> getNavItems({
    required String role,
    required dynamic user,
    String? classId,
  }) {
    switch (role) {
      case 'SchoolAdmin':
        return _getSchoolAdminNavItems(user);
      case 'Teacher':
        return _getTeacherNavItems(user, classId);
      case 'Student':
        return _getStudentNavItems(user);
      case 'Staff':
        return _getStaffNavItems(user);
      default:
        return _getDefaultNavItems(user);
    }
  }

  static List<NavItem> _getSchoolAdminNavItems(dynamic user) {
    return [
      NavItem(
        icon: Icons.home_rounded,
        label: 'Trang chủ',
        screen: DashboardScreen(user: user),
      ),
      const NavItem(
        icon: Icons.bar_chart_rounded,
        label: 'Thống kê',
        screen: AdminReportScreen(),
      ),
      const NavItem(
        icon: Icons.admin_panel_settings,
        label: 'Quản lý',
        screen: AdminManagementScreen(),
      ),
      const NavItem(
        icon: Icons.menu_rounded,
        label: 'Thêm',
        screen: MoreScreen(),
      ),
    ];
  }

  static List<NavItem> _getTeacherNavItems(dynamic user, String? classId) {
    return [
      NavItem(
        icon: Icons.home_rounded,
        label: 'Trang chủ',
        screen: DashboardScreen(user: user),
      ),
      NavItem(
        icon: Icons.how_to_reg_rounded,
        label: 'Điểm danh',
        screen: MainFeatureScreen(user: user, classId: classId),
      ),
      const NavItem(
        icon: Icons.class_rounded,
        label: 'Lớp học',
        screen: TeacherClassesListScreen(),
      ),
      const NavItem(
        icon: Icons.menu_rounded,
        label: 'Thêm',
        screen: MoreScreen(),
      ),
    ];
  }

  static List<NavItem> _getStudentNavItems(dynamic user) {
    return [
      NavItem(
        icon: Icons.home_rounded,
        label: 'Trang chủ',
        screen: DashboardScreen(user: user),
      ),
      const NavItem(
        icon: Icons.menu_book_rounded,
        label: 'Học tập',
        screen: StudentLearningScreen(),
      ),
      const NavItem(
        icon: Icons.qr_code_scanner,
        label: 'Quét QR',
        screen: QRScannerScreen(),
      ),
      const NavItem(
        icon: Icons.menu_rounded,
        label: 'Thêm',
        screen: MoreScreen(),
      ),
    ];
  }

  static List<NavItem> _getStaffNavItems(dynamic user) {
    return [
      NavItem(
        icon: Icons.home_rounded,
        label: 'Trang chủ',
        screen: DashboardScreen(user: user),
      ),
      const NavItem(
        icon: Icons.work_rounded,
        label: 'Công việc',
        screen: StaffTasksScreen(),
      ),
      const NavItem(
        icon: Icons.menu_rounded,
        label: 'Thêm',
        screen: MoreScreen(),
      ),
    ];
  }

  static List<NavItem> _getDefaultNavItems(dynamic user) {
    return [
      NavItem(
        icon: Icons.home_rounded,
        label: 'Trang chủ',
        screen: DashboardScreen(user: user),
      ),
      const NavItem(
        icon: Icons.menu_rounded,
        label: 'Thêm',
        screen: MoreScreen(),
      ),
    ];
  }
}
