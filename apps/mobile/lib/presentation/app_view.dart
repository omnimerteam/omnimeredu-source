import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/routing/route_config.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_theme.dart';
import 'package:flutter_ios_android_platforms/core/theme/theme_cubit.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/injection_container.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/login/login_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'OmniMer EDU',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const AuthWrapper(),
          onGenerateRoute: (settings) {
            // Lấy state hiện tại của AuthenticationBloc
            final authState = context.read<AuthenticationBloc>().state;

            // Nếu chưa login -> chuyển về login/register
            if (authState is! AuthenticationAuthenticated) {
              return MaterialPageRoute(
                builder: (_) => RouteConfig.buildAuthPage(settings.name),
                settings: settings,
              );
            }

            // Nếu đã login -> build page theo role
            return MaterialPageRoute(
              builder: (_) => RouteConfig.buildPage(
                routeName: settings.name ?? '/main',
                role: authState.user.roleName,
              ),
              settings: settings,
            );
          },
        );
      },
    );
  }
}

/// Wrapper để quản lý login/logout
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      listener: (context, state) {},
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return const MainScreen();
          } else if (state is AuthenticationUnauthenticated) {
            return BlocProvider(
              create: (_) => sl<LoginBloc>(),
              child: const LoginScreen(),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
