import 'package:flutter/material.dart';
import '../common/under_development_screen.dart';

class StudentLearningScreen extends StatelessWidget {
  const StudentLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UnderDevelopmentScreen(
      featureName: 'Góc Học tập',
      expectedReleaseDate: DateTime(2025, 8, 1),
    );
  }
}
