import 'package:flutter/material.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome Student!'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/student/scan_qr');
              },
              child: const Text('Scan Attendance QR'),
            ),
          ],
        ),
      ),
    );
  }
}
