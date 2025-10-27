import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/authentication/authentication_state.dart';
import '../../presentation/screens/common/grade_select/cubit/grade_select_cubit.dart';
import '../../injection_container.dart';
import '../../presentation/screens/attendance_record/attendance_detail_screen.dart';
import '../../presentation/screens/attendance_record/bloc/attendance_detail_bloc.dart';
import '../../presentation/screens/attendance_record/bloc/attendance_detail_event.dart';
import '../../presentation/screens/auth/change_password/change_password_screen.dart';
import '../../presentation/screens/auth/change_password/cubit/change_password_cubit.dart';
import '../../presentation/screens/auth/forget_password/bloc/forget_password_bloc.dart';
import '../../presentation/screens/auth/forget_password/forget_password_screen.dart';
import '../../presentation/screens/auth/login/bloc/login_bloc.dart';
import '../../presentation/screens/auth/login/login_screen.dart';
import '../../presentation/screens/auth/user_profile/cubit/user_profile_cubit.dart';
import '../../presentation/screens/auth/user_profile/user_profile_screen.dart';
import '../../presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import '../../presentation/screens/common/class_selector/bloc/class_selector_event.dart';
import '../../presentation/screens/auth/registration/bloc/registration_bloc.dart';
import '../../presentation/screens/auth/registration/bloc/school/school_bloc.dart';
import '../../presentation/screens/auth/registration/registration_screen.dart';
import '../../presentation/screens/auth/role/bloc/role_bloc.dart';
import '../../presentation/screens/class_detail/class_detail_screen.dart';
import '../../presentation/screens/class_detail/cubit/class_detail_cubit.dart';
import '../../presentation/screens/common/student_selector/cubit/student_selector_cubit.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/school_admin/attendance/attendance_management_page.dart';
import '../../presentation/screens/school_admin/attendance/bloc/attendance_management_bloc.dart';
import '../../presentation/screens/school_admin/attendance/bloc/attendance_management_event.dart';
import '../../presentation/screens/school_admin/class/bloc/class_management_bloc.dart';
import '../../presentation/screens/school_admin/class/bloc/class_management_event.dart';
import '../../presentation/screens/school_admin/class/class_management_page.dart';
import '../../presentation/screens/school_admin/grade/bloc/grade_management_bloc.dart';
import '../../presentation/screens/school_admin/grade/bloc/grade_management_event.dart';
import '../../presentation/screens/school_admin/grade/grade_management_page.dart';
import '../../presentation/screens/school_admin/membership_request/bloc/membership_request_management_bloc.dart';
import '../../presentation/screens/school_admin/membership_request/bloc/membership_request_management_event.dart';
import '../../presentation/screens/school_admin/membership_request/membership_request_management_page.dart';
import '../../presentation/screens/school_admin/personnel/bloc/personnel_management_bloc.dart';
import '../../presentation/screens/school_admin/personnel/personel_management_page.dart';
import '../../presentation/screens/school_admin/school/bloc/school_data_schooladmin_bloc.dart';
import '../../presentation/screens/school_admin/school/bloc/school_data_schooladmin_event.dart';
import '../../presentation/screens/school_admin/school/school_data_schooladmin_screen.dart';
import '../../presentation/screens/school_admin/tuition/extra_fee/bloc/extra_fee_management_bloc.dart';
import '../../presentation/screens/school_admin/tuition/extra_fee/bloc/extra_fee_management_event.dart';
import '../../presentation/screens/school_admin/tuition/extra_fee/extra_fee_management_screen.dart';
import '../../presentation/screens/school_admin/tuition/tuition_management_center_screen.dart';
import '../../presentation/screens/student/student_managent/bloc/student_management_bloc.dart';
import '../../presentation/screens/student/student_managent/bloc/student_management_event.dart';
import '../../presentation/screens/student/student_managent/student_management_screen.dart';

import 'role_guard.dart';

class RouteConfig {
  static Widget buildPage({
    required String routeName,
    required String role,
    Map<String, dynamic>? arguments,
  }) {
    if (!RoleGuard.canAccess(role, routeName)) {
      return const _ForbiddenPage();
    }

    switch (routeName) {
      case '/main':
        return const MainScreen();

      case '/profile':
        return BlocProvider(
          create: (context) {
            return sl<UserProfileCubit>();
          },
          child: Builder(
            builder: (context) {
              final authState = context.read<AuthenticationBloc>().state;
              String userId = '';
              if (authState is AuthenticationAuthenticated) {
                userId = authState.user.id;
              }
              return UserProfileScreen(userId: userId);
            },
          ),
        );

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

      case '/school-admin/classes/detail':
        final classId = arguments?['classId'] as String?;
        if (classId == null) {
          return const _ErrorPage(message: 'Class ID is required');
        }
        return BlocProvider(
          create: (_) => sl<ClassDetailCubit>(),
          child: ClassDetailScreen(classId: classId),
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
                final bloc = sl<ClassSelectorBloc>();
                if (schoolId.isNotEmpty) {
                  bloc.add(LoadClassesBySchool(schoolId));
                }
                return bloc;
              },
            ),
          ],
          child: const StudentManagementPage(),
        );

      case '/school-admin/personnel':
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<PersonnelManagementBloc>()),
            BlocProvider(create: (_) => sl<ClassSelectorBloc>()),
            BlocProvider(create: (_) => sl<RoleBloc>()),
          ],
          child: const PersonnelManagementPage(),
        );

      case '/school-admin/attendance':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  sl<AttendanceManagementBloc>()..add(LoadAttendancesEvent()),
            ),
            BlocProvider(create: (_) => sl<ClassSelectorBloc>()),
          ],
          child: const AttendanceManagementPage(),
        );

      case '/school-admin/attendance/detail-record':
        final attendanceId = arguments?['attendanceId'] as String;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  sl<AttendanceDetailBloc>()
                    ..add(LoadAttendanceDetailEvent(attendanceId)),
            ),
            //BlocProvider(create: (_) => sl<ClassSelectorBloc>()),
          ],
          child: AttendanceDetailPage(attendanceId: attendanceId),
        );

      case '/profile/change-password':
        return BlocProvider(
          create: (_) => sl<ChangePasswordCubit>(),
          child: const ChangePasswordScreen(),
        );

      case '/school-admin/tuition':
        return TuitionManagementCenterScreen();

      case '/school-admin/tuition/extra-fee':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  sl<ExtraFeeManagementBloc>()
                    ..add(LoadExtraFeeEvent()), // Load danh sách phí phụ
            ),
            BlocProvider(
              create: (context) {
                final authState = context.read<AuthenticationBloc>().state;
                String schoolId = '';
                if (authState is AuthenticationAuthenticated) {
                  schoolId = authState.user.schoolId ?? '';
                }
                final bloc = sl<ClassSelectorBloc>();
                if (schoolId.isNotEmpty) {
                  bloc.add(LoadClassesBySchool(schoolId));
                }
                return bloc;
              },
            ),
            BlocProvider(create: (_) => sl<GradeSelectCubit>()..loadGrades()),
            BlocProvider(
              create: (_) => sl<StudentSelectorCubit>()..loadStudents(),
            ),
          ],
          child: const ExtraFeeManagementScreen(),
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
          BlocProvider(create: (_) => sl<ClassSelectorBloc>()),
        ],
        child: const RegistrationScreen(),
      );
    } else if (routeName == '/forget-password') {
      return BlocProvider(
        create: (_) => sl<ForgetPasswordBloc>(),
        child: const ForgetPasswordScreen(),
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

class _ErrorPage extends StatelessWidget {
  final String message;

  const _ErrorPage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Lỗi', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(message),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}
