import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF006a9c);
  static const Color blue = Color(0xFF1E88E5);
  static const Color lightBlue = Color(0xFF4A90E2);
  static const Color extraLightBlue = Color(0xFFD0E6FF);

  // Text / Background
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF002134);
  static const Color textDark = Color(0xFF002134);
  static const Color textLight = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color red = Color(0xFFb22e33);
  static const Color darkRed = Color(0xFF82060e);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Subject Colors (for educational content)
  static const Color mathColor = Color(0xFF2196F3);
  static const Color literatureColor = Color(0xFF4CAF50);
  static const Color englishColor = Color(0xFFFF9800);
  static const Color physicsColor = Color(0xFF9C27B0);
  static const Color chemistryColor = Color(0xFFF44336);
  static const Color biologyColor = Color(0xFF8BC34A);
  static const Color historyColor = Color(0xFF795548);
  static const Color geographyColor = Color(0xFF009688);

  // Role-based Colors
  static const Color studentColor = Color(0xFF2196F3);
  static const Color teacherColor = Color(0xFF4CAF50);
  static const Color adminColor = Color(0xFF9C27B0);
  static const Color parentColor = Color(0xFFFF9800);

  // Status Colors
  static const Color pendingColor = Color(0xFFFF9800);
  static const Color approvedColor = Color(0xFF4CAF50);
  static const Color rejectedColor = Color(0xFFF44336);
  static const Color completedColor = Color(0xFF2196F3);
  static const Color inProgressColor = Color(0xFF9C27B0);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF006a9c),
    Color(0xFF1E88E5),
  ];

  static const List<Color> successGradient = [
    Color(0xFF4CAF50),
    Color(0xFF8BC34A),
  ];

  static const List<Color> warningGradient = [
    Color(0xFFFF9800),
    Color(0xFFFFC107),
  ];

  static const List<Color> errorGradient = [
    Color(0xFFF44336),
    Color(0xFFE91E63),
  ];

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFFF44336),
    Color(0xFF009688),
    Color(0xFF795548),
    Color(0xFF607D8B),
  ];

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // Overlay Colors
  static const Color overlayLight = Color(0x33FFFFFF);
  static const Color overlayDark = Color(0x33000000);

  // Helper methods
  static Color getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
      case 'toán':
        return mathColor;
      case 'literature':
      case 'văn':
      case 'ngữ văn':
        return literatureColor;
      case 'english':
      case 'tiếng anh':
        return englishColor;
      case 'physics':
      case 'vật lý':
        return physicsColor;
      case 'chemistry':
      case 'hóa học':
        return chemistryColor;
      case 'biology':
      case 'sinh học':
        return biologyColor;
      case 'history':
      case 'lịch sử':
        return historyColor;
      case 'geography':
      case 'địa lý':
        return geographyColor;
      default:
        return primary;
    }
  }

  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'student':
      case 'học sinh':
        return studentColor;
      case 'teacher':
      case 'giáo viên':
        return teacherColor;
      case 'admin':
      case 'quản trị viên':
        return adminColor;
      case 'parent':
      case 'phụ huynh':
        return parentColor;
      default:
        return primary;
    }
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'đang chờ':
        return pendingColor;
      case 'approved':
      case 'đã duyệt':
        return approvedColor;
      case 'rejected':
      case 'từ chối':
        return rejectedColor;
      case 'completed':
      case 'hoàn thành':
        return completedColor;
      case 'in_progress':
      case 'đang thực hiện':
        return inProgressColor;
      default:
        return grey500;
    }
  }

  static Color getGradeColor(double grade) {
    if (grade >= 8.5) {
      return Color(0xFF4CAF50); // Excellent - Green
    } else if (grade >= 7.0) {
      return Color(0xFF2196F3); // Good - Blue
    } else if (grade >= 5.5) {
      return Color(0xFFFF9800); // Average - Orange
    } else if (grade >= 4.0) {
      return Color(0xFFF44336); // Poor - Red
    } else {
      return Color(0xFF9E9E9E); // Very Poor - Grey
    }
  }

  static Color getProgressColor(double progress) {
    if (progress >= 0.8) {
      return success;
    } else if (progress >= 0.6) {
      return info;
    } else if (progress >= 0.4) {
      return warning;
    } else {
      return error;
    }
  }

  // Theme-based colors
  static Color getCardBackground(bool isDarkMode) {
    return isDarkMode ? grey800 : backgroundLight;
  }

  static Color getTextColor(bool isDarkMode) {
    return isDarkMode ? textLight : textDark;
  }

  static Color getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? backgroundDark : grey50;
  }

  static Color getDividerColor(bool isDarkMode) {
    return isDarkMode ? grey700 : grey300;
  }
}
