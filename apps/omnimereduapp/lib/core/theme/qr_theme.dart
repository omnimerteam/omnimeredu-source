import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Theme extensions cho tính năng QR Attendance
class QRAttendanceTheme {
  // QR Display Colors
  static const Color qrForeground = AppColors.textDark;
  static const Color qrBackground = AppColors.backgroundLight;
  static const Color qrLogoBackground = AppColors.backgroundLight;
  
  // Status Colors cho điểm danh
  static const Color presentColor = AppColors.success;       // Có mặt
  static const Color absentColor = AppColors.error;          // Vắng mặt
  static const Color lateColor = AppColors.warning;          // Đi muộn
  static const Color excusedColor = AppColors.info;          // Có phép

  // Gradient cho QR Screen
  static const List<Color> qrScreenGradient = [
    Color(0xFF006a9c),
    Color(0xFF1E88E5),
  ];

  // Scanner overlay
  static const Color scannerOverlay = Color(0x88000000);
  static const Color scannerBorder = Color(0xFF4FC3F7); // Light blue
  static const Color scannerCorner = Color(0xFF4FC3F7); // Light blue
  
  // Sizes
  static const double qrSize = 280.0;
  static const double scannerFrameSize = 280.0;
  static const double cornerLength = 40.0;
  static const double cornerWidth = 4.0;
  
  // Card styling
  static BoxDecoration qrCardDecoration(bool isDarkMode) => BoxDecoration(
    color: isDarkMode ? AppColors.grey800 : AppColors.backgroundLight,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowMedium,
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Status badge decoration
  static BoxDecoration statusBadgeDecoration(Color color) => BoxDecoration(
    color: color.withOpacity(0.15),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: color.withOpacity(0.3)),
  );

  // Get attendance status color
  static Color getAttendanceStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
      case 'có mặt':
        return presentColor;
      case 'absent':
      case 'vắng':
        return absentColor;
      case 'late':
      case 'muộn':
        return lateColor;
      case 'excused':
      case 'có phép':
        return excusedColor;
      default:
        return AppColors.grey500;
    }
  }

  // Get attendance status icon
  static IconData getAttendanceStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'present':
      case 'có mặt':
        return Icons.check_circle;
      case 'absent':
      case 'vắng':
        return Icons.cancel;
      case 'late':
      case 'muộn':
        return Icons.access_time;
      case 'excused':
      case 'có phép':
        return Icons.info;
      default:
        return Icons.help_outline;
    }
  }
}

