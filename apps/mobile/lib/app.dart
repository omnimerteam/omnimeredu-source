import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/appView.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/repositories/auth_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();

    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(authRepository: authRepository),
        child: const AppView(),
      ),
    );
  }
}
