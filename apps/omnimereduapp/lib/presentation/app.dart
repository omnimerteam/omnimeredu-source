import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/theme_cubit.dart';
import '../injection_container.dart';
import 'app_view.dart';
import '../core/bloc/authentication/authentication_bloc.dart';
import '../core/bloc/authentication/authentication_event.dart';
import 'screens/auth/login/bloc/login_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthenticationBloc>()..add(AuthenticationStarted()),
        ),
        BlocProvider(
          create: (_) => LoginBloc(
            loginUseCase: sl(),
            authenticationBloc: sl<AuthenticationBloc>(),
          ),
        ),
        // thêm các bloc khác nếu cần
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: const AppView(),
    );
  }
}
