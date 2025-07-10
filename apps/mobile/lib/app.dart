import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/screens/auth/login_screen.dart';
import 'package:flutter_ios_android_platforms/screens/auth/signup_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmnimerEDU',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
      },
    );
  }
}
