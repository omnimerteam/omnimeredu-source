import 'package:flutter/material.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome Teacher!'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/teacher/create_attendance');
              },
              child: const Text('Create Attendance Sheet'),
            ),
          ],
        ),
      ),
    );
  }
}
