import 'package:flutter/material.dart';

class StaffHomePage extends StatelessWidget {
  const StaffHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Home')),
      body: const Center(child: Text('Welcome, Staff Member!')),
    );
  }
}
