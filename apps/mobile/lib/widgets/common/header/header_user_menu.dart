import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/authentication/authentication_bloc.dart';

class HeaderUserMenu extends StatelessWidget {
  const HeaderUserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'account') {
          // TODO: điều hướng đến trang tài khoản
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đi đến trang tài khoản')),
          );
        } else if (value == 'logout') {
          // 👇 Sử dụng Future.microtask để tránh crash khi widget đang dispose
          Future.microtask(() {
            context.read<AuthenticationBloc>().add(
              AuthenticationLogoutRequested(),
            );
          });
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'account', child: Text('Quản lý tài khoản')),
        PopupMenuItem(value: 'logout', child: Text('Đăng xuất')),
      ],
    );
  }
}
