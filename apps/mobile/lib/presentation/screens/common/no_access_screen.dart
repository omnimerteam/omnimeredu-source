import 'package:flutter/material.dart';

/// A screen that displays when the user does not have access to a feature.
///
/// [roleName] is the name of the user's role, used to display a specific message.
class NoAccessScreen extends StatelessWidget {
  final String? roleName;

  /// Creates a [NoAccessScreen].
  ///
  /// The [roleName] parameter specifies the user's role for the access message.

  const NoAccessScreen({super.key, this.roleName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, color: Colors.redAccent, size: 80),
              const SizedBox(height: 20),
              const Text(
                'Không có quyền truy cập',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                roleName != null
                    ? 'Tài khoản với vai trò "$roleName" không được phép truy cập tính năng này.'
                    : 'Tài khoản của bạn không được phép truy cập tính năng này.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // hoặc chuyển về Home/Login
                },
                icon: const Icon(Icons.home),
                label: const Text('Quay về trang chủ'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
