import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/authentication/authentication_bloc.dart';

class HeaderUserWidget extends StatelessWidget {
  final String displayName;
  final String role;

  const HeaderUserWidget({
    super.key,
    required this.displayName,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.person, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayName, style: const TextStyle(fontSize: 16)),
            Text(
              role,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        const Spacer(),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'account') {
              // TODO: điều hướng đến trang tài khoản
            } else if (value == 'logout') {
              context.read<AuthenticationBloc>().add(
                AuthenticationLogoutRequested(),
              );
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'account',
              child: Text('Quản lý tài khoản'),
            ),
            const PopupMenuItem(value: 'logout', child: Text('Đăng xuất')),
          ],
        ),
      ],
    );
  }
}
