import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/utils/display_mapper.dart';
import '../auth/login/bloc/login_bloc.dart';
import '../auth/login/bloc/login_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          final user = state.user;
          if (user == null) {
            return const Center(child: Text("Chưa đăng nhập"));
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : const AssetImage(
                            "assets/images/default/default_avatar.png",
                          )
                          as ImageProvider,
              ),
              const SizedBox(height: 16),
              Text(user.fullName, style: const TextStyle(fontSize: 20)),
              Text("Vai trò: ${DisplayMapper.roleName(user.roleName)}"),
            ],
          );
        },
      ),
    );
  }
}
