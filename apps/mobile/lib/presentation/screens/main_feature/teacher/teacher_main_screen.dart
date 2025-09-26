import 'package:flutter/material.dart';

class TeacherMainFeatureScreen extends StatelessWidget {
  const TeacherMainFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tiến độ học tập')),
      body: Center(
        child: Text(
          " đây là trang học sinh 🎓",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
