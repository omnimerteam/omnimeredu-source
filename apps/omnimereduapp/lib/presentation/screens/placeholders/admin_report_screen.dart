import 'package:flutter/material.dart';
import '../common/under_development_screen.dart';

class AdminReportScreen extends StatelessWidget {
  const AdminReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UnderDevelopmentScreen(
      featureName: 'Thống kê & Báo cáo',
      expectedReleaseDate: DateTime(2025, 6, 1),
    );
  }
}
