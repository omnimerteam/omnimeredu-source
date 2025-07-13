import 'package:flutter/material.dart';

class UnknownRolePage extends StatelessWidget {
  const UnknownRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unknown Role')),
      body: const Center(
        child: Text('Your account has no valid role assigned!'),
      ),
    );
  }
}
