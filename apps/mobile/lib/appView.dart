import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/authentication/authentication_bloc.dart';

import 'package:flutter_ios_android_platforms/screens/auth/login_screen.dart';
import 'package:flutter_ios_android_platforms/screens/auth/signup_screen.dart';
import 'package:flutter_ios_android_platforms/screens/home/schoolAdmin_screen.dart';
import 'package:flutter_ios_android_platforms/screens/home/staff_screen.dart';
import 'package:flutter_ios_android_platforms/screens/home/student_screen.dart';
import 'package:flutter_ios_android_platforms/screens/home/teacher_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmnimerEDU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/signup': (_) => const SignupScreen(),
        '/login': (_) => const LoginScreen(),
      },
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previous, current) =>
            previous.status != current.status || previous.role != current.role,
        builder: (context, state) {
          if (state.status == AuthenticationStatus.unauthenticated) {
            return const LoginScreen();
          }

          if (state.status == AuthenticationStatus.authenticated) {
            switch (state.role) {
              case 'SchoolAdmin':
                return const SchoolAdminHomePage();
              case 'Teacher':
                return const TeacherHomePage();
              case 'Student':
                return const StudentHomePage();
              case 'Staff':
              case 'CanteenStaff':
              case 'Nurse':
              case 'Security':
                return const StaffHomePage();
              default:
                return const Scaffold(
                  body: Center(child: Text('Vai trò không hợp lệ')),
                );
            }
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
