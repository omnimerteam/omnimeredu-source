import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_theme.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/login/login_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/registration_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OmniMer EDU',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // Định nghĩa các routes cho các màn hình
      routes: {
        '/': (context) => const LoginScreen(), // Màn hình khởi đầu
        '/register': (context) =>
            const RegistrationScreen(), // Màn hình đăng ký
      },
      initialRoute: '/',
    );
  }
}
