import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/routing/role_guard.dart';
import 'package:mobile/presentation/screen/auth/registration/bloc/registration_bloc.dart';
import 'package:mobile/presentation/screen/auth/registration/bloc/school/school_bloc.dart';
import 'package:mobile/presentation/screen/auth/registration/bloc/class/class_bloc.dart';
import 'package:mobile/presentation/screen/auth/registration/registration_screen.dart';
import '../../presentation/screen/school_admin/school/school_screen.dart';
import 'package:mobile/presentation/screen/auth/login/login_screen.dart';
import 'package:mobile/presentation/screen/auth/login/bloc/login_bloc.dart';
import 'package:mobile/presentation/screen/main_screen.dart';
import 'package:mobile/presentation/common/blocs/auth_bloc/auth_bloc.dart';
import '../../presentation/screen/school_admin/grade/grade_management_screen.dart';
import '../../presentation/screen/school_admin/grade/bloc/grade_management_bloc.dart';
import '../../presentation/screen/school_admin/grade/bloc/grade_management_event.dart';
import '../../presentation/screen/school_admin/membership_request/membership_request_screen.dart';
import '../../presentation/screen/school_admin/membership_request/bloc/membership_request_bloc.dart';
import 'package:mobile/injection_container.dart' as di;

/// RouteConfig - Quản lý routing và navigation cho ứng dụng
///
/// Cách sử dụng:
/// 1. Định nghĩa route names trong phần ROUTE NAMES
/// 2. Implement buildAuthPage() cho các trang không cần authentication
/// 3. Implement buildPage() cho các trang cần authentication và role-based access
/// 4. Sử dụng các navigation helpers để điều hướng
class RouteConfig {
  // ==================== ROUTE NAMES ====================
  // Auth routes - Không cần authentication
  static const String login = '/login';
  static const String register = '/registration';

  // Main routes - Cần authentication và role-based access
  static const String main = '/main';
  static const String home = '/home';

  // TODO: Thêm các route names khác ở đây
  // Ví dụ:
  static const String profile = '/profile';
  static const String settings = '/settings';

  // School Admin Routes
  static const String schoolAdminSchool = '/school-admin/school';
  static const String schoolAdminClasses = '/school-admin/classes';
  static const String schoolAdminGrades = '/school-admin/grades';
  static const String schoolAdminMembershipRequests =
      '/school-admin/membership-requests';
  static const String schoolAdminStudents = '/school-admin/students';
  static const String schoolAdminPersonnel = '/school-admin/personnel';
  static const String schoolAdminAttendance = '/school-admin/attendance';
  static const String schoolAdminTuition = '/school-admin/tuition';

  // ==================== BUILD AUTH PAGES ====================
  /// Build các trang không cần authentication (login, register, forgot password)
  ///
  /// Ví dụ:
  /// ```dart
  /// static Widget buildAuthPage(String? routeName) {
  ///   switch (routeName) {
  ///     case register:
  ///       return BlocProvider(
  ///         create: (_) => RegisterCubit(),
  ///         child: const RegisterScreen(),
  ///       );
  ///     case login:
  ///     default:
  ///       return BlocProvider(
  ///         create: (_) => LoginCubit(),
  ///         child: const LoginScreen(),
  ///       );
  ///   }
  /// }
  /// ```
  static Widget buildAuthPage(String? routeName) {
    switch (routeName) {
      case register:
        return MultiBlocProvider(
          providers: [
            BlocProvider<RegistrationBloc>(create: (_) => RegistrationBloc()),
            BlocProvider<SchoolBloc>(create: (_) => di.sl<SchoolBloc>()),
            BlocProvider<ClassBloc>(create: (_) => di.sl<ClassBloc>()),
          ],
          child: const RegistrationScreen(),
        );
      case login:
      default:
        return Builder(
          builder: (context) => BlocProvider(
            create: (_) =>
                LoginBloc(authenticationBloc: context.read<AuthBloc>()),
            child: const LoginScreen(),
          ),
        );
    }
  }

  // ==================== BUILD AUTHENTICATED PAGES ====================
  /// Build các trang cần authentication và kiểm tra role-based access
  ///
  /// Tham số:
  /// - [routeName]: Tên route cần build
  /// - [role]: Danh sách role của user hiện tại
  /// - [arguments]: Arguments truyền vào route (optional)
  ///
  /// Ví dụ:
  /// ```dart
  /// static Widget buildPage({
  ///   required String routeName,
  ///   required List<String>? role,
  ///   Map<String, dynamic>? arguments,
  /// }) {
  ///   // Kiểm tra quyền truy cập
  ///   if (!RoleGuard.canAccess(role, routeName)) {
  ///     return _ForbiddenPage(role: role, routeName: routeName);
  ///   }
  ///
  ///   // Build page theo route
  ///   switch (routeName) {
  ///     case home:
  ///       return BlocProvider(
  ///         create: (_) => HomeBloc(),
  ///         child: const HomeScreen(),
  ///       );
  ///     case profile:
  ///       final userId = arguments?['userId'] as String?;
  ///       return ProfileScreen(userId: userId);
  ///     default:
  ///       return _ErrorPage(message: 'Không tìm thấy trang: $routeName');
  ///   }
  /// }
  /// ```
  static Widget buildPage({
    required String routeName,
    required List<String>? role,
    Map<String, dynamic>? arguments,
  }) {
    // Kiểm tra quyền truy cập
    if (!RoleGuard.canAccess(role, routeName)) {
      return _ForbiddenPage(role: role, routeName: routeName);
    }

    // Build page theo route
    switch (routeName) {
      case main:
      case home:
        return const MainScreen();

      case schoolAdminSchool:
        return const SchoolAdminSchoolScreen();

      case schoolAdminGrades:
        return BlocProvider(
          create: (_) =>
              di.sl<GradeManagementBloc>()..add(const LoadGradesEvent()),
          child: const GradeManagementScreen(),
        );

      case schoolAdminClasses:
      case schoolAdminMembershipRequests:
        return BlocProvider(
          create: (_) => di.sl<MembershipRequestBloc>(),
          child: const MembershipRequestScreen(),
        );

      case schoolAdminStudents:
      case schoolAdminPersonnel:
      case schoolAdminAttendance:
      case schoolAdminTuition:
        return Scaffold(
          appBar: AppBar(title: Text(routeName.split('/').last)),
          body: const Center(child: Text("Tính năng đang phát triển")),
        );

      // TODO: Thêm các route khác ở đây

      default:
        return _ErrorPage(message: 'Không tìm thấy trang: $routeName');
    }
  }

  // ==================== NAVIGATION HELPERS ====================
  /// Các helper methods để điều hướng giữa các màn hình
  ///
  /// Ví dụ:
  /// ```dart
  /// static void navigateToLogin(BuildContext context) {
  ///   Navigator.of(context).pushNamedAndRemoveUntil(login, (route) => false);
  /// }
  ///
  /// static void navigateToProfile(
  ///   BuildContext context, {
  ///   required String userId,
  /// }) {
  ///   Navigator.of(context).pushNamed(profile, arguments: {'userId': userId});
  /// }
  /// ```

  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(login, (route) => false);
  }

  static void navigateToMain(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(main, (route) => false);
  }

  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamed(home);
  }

  static void navigateToRegister(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(register, (route) => false);
  }

  // TODO: Thêm các navigation helpers khác ở đây
}

// ==================== ERROR PAGES ====================

/// Trang hiển thị khi không đủ quyền truy cập
class _ForbiddenPage extends StatelessWidget {
  final List<String>? role;
  final String routeName;

  const _ForbiddenPage({required this.role, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Không có quyền truy cập'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.block, size: 80.w, color: Colors.red),
              SizedBox(height: 24.h),
              Text(
                'Không có quyền truy cập',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'Bạn không có quyền truy cập trang này.\nVai trò của bạn: ${role ?? "Không xác định"}',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Quay lại'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 16.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Trang hiển thị khi có lỗi
class _ErrorPage extends StatelessWidget {
  final String message;

  const _ErrorPage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lỗi'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80.w, color: Colors.orange),
              SizedBox(height: 24.h),
              Text(
                'Có lỗi xảy ra',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              Text(
                message,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Quay lại'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 16.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
