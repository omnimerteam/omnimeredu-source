import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
// import 'screens/auth/register_screen.dart';

void main() {
  runApp(StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý học sinh',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue[800],
          elevation: 0,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        // '/register': (context) => RegisterScreen(),
      },
    );
  }
}
