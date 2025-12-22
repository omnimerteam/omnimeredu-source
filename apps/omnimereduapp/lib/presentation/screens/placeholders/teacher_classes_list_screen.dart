import 'package:flutter/material.dart';
import '../common/under_development_screen.dart';

class TeacherClassesListScreen extends StatelessWidget {
  const TeacherClassesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UnderDevelopmentScreen(
      featureName: 'Danh sách Lớp học',
      expectedReleaseDate: DateTime(2025, 5, 1),
    );
  }
}
