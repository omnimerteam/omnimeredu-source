import 'package:flutter/material.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Home')),
      body: const Center(child: Text('Welcome, Teacher!')),
    );
  }
}
