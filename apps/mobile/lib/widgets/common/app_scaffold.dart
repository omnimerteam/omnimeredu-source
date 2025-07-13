import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/widgets/common/header/header_user_menu.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;

  const AppScaffold({Key? key, required this.body, this.floatingActionButton})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthenticationBloc>().state;

    final user = state.user;
    final role = state.role ?? 'Unknown';
    final displayName = user?.displayName ?? user?.email ?? 'Không rõ';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayName, style: const TextStyle(fontSize: 16)),
            Text(
              role,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: const [HeaderUserMenu()],
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
