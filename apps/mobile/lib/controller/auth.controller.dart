import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/screens/home/schoolAdmin_screen.dart';
import 'package:flutter_ios_android_platforms/screens/home/staff_screen.dart';
import 'package:flutter_ios_android_platforms/screens/home/student_screen.dart';
import 'package:flutter_ios_android_platforms/screens/home/teacher_screen.dart';
import 'package:flutter_ios_android_platforms/screens/other/unknow_screen.dart';

class AuthController {
  static void navigateToHomeByRole(BuildContext context, String role) {
    switch (role) {
      case 'SchoolAdmin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SchoolAdminHomePage()),
        );
        break;
      case 'Teacher':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TeacherHomePage()),
        );
        break;
      case 'Staff':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StaffHomePage()),
        );
        break;
      case 'Student':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentHomePage()),
        );
        break;
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UnknownRolePage()),
        );
        break;
    }
  }
}
