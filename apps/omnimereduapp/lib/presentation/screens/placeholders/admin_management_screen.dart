import 'package:flutter/material.dart';
import '../common/under_development_screen.dart';

class AdminManagementScreen extends StatelessWidget {
  const AdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UnderDevelopmentScreen(
      featureName: 'Quản lý Hệ thống',
      expectedReleaseDate: DateTime(2025, 7, 1),
    );
  }
}
