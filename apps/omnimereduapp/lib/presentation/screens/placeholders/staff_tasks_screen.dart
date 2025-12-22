import 'package:flutter/material.dart';
import '../common/under_development_screen.dart';

class StaffTasksScreen extends StatelessWidget {
  const StaffTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UnderDevelopmentScreen(
      featureName: 'Công việc',
      expectedReleaseDate: DateTime(2025, 9, 1),
    );
  }
}
