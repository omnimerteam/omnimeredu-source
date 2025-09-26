import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/no_access_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_feature/teacher/teacher_main_screen.dart';

class MainFeatureScreen extends StatelessWidget {
  final dynamic user; // user có roleName

  const MainFeatureScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final role = user.roleName?.toLowerCase() ?? '';

    switch (role) {
      // case 'student':
      // case 'học sinh':
      // return BlocProvider(
      //   create: (_) => StudentMainBloc()..add(LoadStudentMainData(user.id)),
      //   child: StudentMainFeatureScreen(user: user),
      // );

      case 'teacher':
      case 'giáo viên':
      // return BlocProvider(
      //   create: (_) => TeacherMainBloc()..add(LoadTeacherMainData(user.id)),
      //   child: TeacherMainFeatureScreen(),
      // );

      // case 'admin':
      // case 'schooladmin':
      // case 'quản trị viên':
      // return BlocProvider(
      //   create: (_) => AdminMainBloc()..add(LoadAdminMainData(user.id)),
      //   child: AdminMainFeatureScreen(user: user),
      // );

      default:
        return NoAccessScreen();
    }
  }
}
