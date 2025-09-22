import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/injection_container.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/login/login_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/school/school_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/registration_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/class/bloc/class_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/class/bloc/class_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/class/class_management_page.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/grade/bloc/grade_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/grade/bloc/grade_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/grade/grade_management_page.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/membership_request_management_page.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/school/bloc/school_data_schooladmin_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/school/bloc/school_data_schooladmin_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/school/school_data_schooladmin_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/student/bloc/student_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/student/bloc/student_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/student/student_management_screen.dart';

import 'role_guard.dart';

class RouteConfig {
  static Widget buildPage({required String routeName, required String role}) {
    if (!RoleGuard.canAccess(role, routeName)) {
      return const _ForbiddenPage();
    }

    switch (routeName) {
      case '/main':
        return const MainScreen();

      case '/school-admin/school':
        return BlocProvider(
          create: (_) =>
              sl<SchoolDataSchoolAdminBloc>()..add(LoadSchoolDataAdmin()),
          child: const SchoolDataSchoolAdminScreen(),
        );

      case '/school-admin/classes':
        return BlocProvider(
          create: (_) =>
              sl<ClassManagementBloc>()..add(const LoadClassesEvent()),
          child: const ClassManagementPage(),
        );

      case '/school-admin/membership-requests':
        return BlocProvider(
          create: (_) =>
              sl<MembershipRequestManagementBloc>()
                ..add(const LoadMembershipRequestsEvent()),
          child: const MembershipRequestManagementPage(),
        );

      case '/school-admin/grades':
        return BlocProvider(
          create: (_) =>
              sl<GradeManagementBloc>()..add(const LoadGradesEvent()),
          child: const GradeManagementPage(),
        );

      case '/school-admin/students':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  sl<StudentManagementBloc>()..add(const LoadStudentsEvent()),
            ),
            BlocProvider(
              create: (context) {
                final authState = context.read<AuthenticationBloc>().state;
                String schoolId = '';
                if (authState is AuthenticationAuthenticated) {
                  schoolId = authState.user.schoolId ?? '';
                }
                final bloc = sl<ClassBloc>();
                if (schoolId.isNotEmpty) {
                  bloc.add(LoadClassesBySchool(schoolId));
                }
                return bloc;
              },
            ),
          ],
          child: const StudentManagementPage(),
        );

      default:
        return const MainScreen();
    }
  }

  static Widget buildAuthPage(String? routeName) {
    if (routeName == '/register') {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<RegistrationBloc>()),
          BlocProvider(create: (_) => sl<SchoolBloc>()),
          BlocProvider(create: (_) => sl<ClassBloc>()),
        ],
        child: const RegistrationScreen(),
      );
    } else {
      return BlocProvider(
        create: (_) => sl<LoginBloc>(),
        child: const LoginScreen(),
      );
    }
  }
}

/// Trang hiển thị khi không đủ quyền
class _ForbiddenPage extends StatelessWidget {
  const _ForbiddenPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Bạn không có quyền truy cập trang này")),
    );
  }
}
