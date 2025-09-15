import 'package:flutter/material.dart';

enum UserRole { student, teacher, schoolAdmin, unknown, staff }

class RoleHelper {
  static UserRole parseRole(String? roleName) {
    final normalizedRole = roleName?.toLowerCase().trim() ?? '';

    switch (normalizedRole) {
      case 'student':
      case 'học sinh':
        return UserRole.student;
      case 'teacher':
      case 'giáo viên':
        return UserRole.teacher;
      case 'schooladmin':
      case 'quản trị viên':
        return UserRole.schoolAdmin;
      case 'canteenstaff':
      case 'nurse':
      case 'security':
        return UserRole.staff;
      default:
        return UserRole.unknown;
    }
  }

  static String getWelcomeMessage(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Hãy bắt đầu hành trình học tập của hôm nay!';
      case UserRole.teacher:
        return 'Chúc bạn một ngày giảng dạy thành công!';
      case UserRole.schoolAdmin:
        return 'Quản lý hệ thống hiệu quả và thông minh!';
      default:
        return 'Chúc bạn có một ngày làm việc hiệu quả!';
    }
  }

  static IconData getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Icons.school;
      case UserRole.teacher:
        return Icons.person_pin;
      case UserRole.schoolAdmin:
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  static String roleToString(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'student';
      case UserRole.teacher:
        return 'teacher';
      case UserRole.schoolAdmin:
        return 'admin';
      default:
        return 'unknown';
    }
  }

  static String getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Học sinh';
      case UserRole.teacher:
        return 'Giáo viên';
      case UserRole.schoolAdmin:
        return 'Quản trị viên';
      case UserRole.staff:
        return 'Nhân viên';
      default:
        return 'Người dùng';
    }
  }
}
