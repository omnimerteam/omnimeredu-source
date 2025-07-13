import 'package:flutter/material.dart';

class SchoolAdminHomePage extends StatelessWidget {
  const SchoolAdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('School Admin Home')),
      body: const Center(child: Text('Welcome, School Administrator!')),
    );
  }
}
