import 'package:flutter/material.dart';

class DefaultDashboard extends StatelessWidget {
  const DefaultDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.waving_hand, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Chào mừng bạn đến với ứng dụng!',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
