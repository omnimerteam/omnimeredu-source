// lib/app_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_theme.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/login/login_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/registration_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'OmniMer EDU',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegistrationScreen(),
            '/main': (context) => const MainScreen(),
          },
          home: _buildHome(state),
        );
      },
    );
  }

  Widget _buildHome(AuthenticationState state) {
    if (state is AuthenticationAuthenticated) {
      return const MainScreen();
    }
    if (state is AuthenticationUnauthenticated) {
      return const LoginScreen();
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
