import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_theme.dart';
import 'package:flutter_ios_android_platforms/core/theme/theme_cubit.dart';
import 'package:flutter_ios_android_platforms/injection_container.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/login/login_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/login/bloc/login_bloc.dart'; // <-- import LoginBloc
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/school/school_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/registration_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/class/bloc/class_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/class/bloc/class_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/class/class_management_page.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/membership_request_management_page.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/school/bloc/school_data_schooladmin_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/school/bloc/school_data_schooladmin_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/school/school_data_schooladmin_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'OmniMer EDU',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routes: {
                // route tạo LoginBloc khi push tới /login
                '/login': (context) => BlocProvider(
                  create: (ctx) => LoginBloc(
                    loginUseCase: sl(),
                    authenticationBloc: ctx.read<AuthenticationBloc>(),
                  ),
                  child: const LoginScreen(),
                ),

                // register flow tạo RegistrationBloc + SchoolBloc + ClassBloc local cho flow
                '/register': (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<RegistrationBloc>()),
                    BlocProvider(create: (_) => sl<SchoolBloc>()),
                    BlocProvider(create: (_) => sl<ClassBloc>()),
                  ],
                  child: const RegistrationScreen(),
                ),

                '/main': (context) => const MainScreen(),

                '/school-admin/school': (context) => BlocProvider(
                  create: (_) =>
                      sl<SchoolDataSchoolAdminBloc>()
                        ..add(LoadSchoolDataAdmin()),
                  child: const SchoolDataSchoolAdminScreen(),
                ),

                '/school-admin/classes': (context) => BlocProvider(
                  create: (context) =>
                      sl<ClassManagementBloc>()..add(const LoadClassesEvent()),
                  child: const ClassManagementPage(),
                ),

                '/school-admin/membership-requests': (context) => BlocProvider(
                  create: (context) =>
                      sl<MembershipRequestManagementBloc>()
                        ..add(const LoadMembershipRequestsEvent()),
                  child: const MembershipRequestManagementPage(),
                ),
              },

              // use Builder so we have the right BuildContext when creating LoginBloc for home
              home: Builder(builder: (ctx) => _buildHome(ctx, state)),
            );
          },
        );
      },
    );
  }

  // now _buildHome has access to a BuildContext so it can create LoginBloc when needed
  Widget _buildHome(BuildContext context, AuthenticationState state) {
    if (state is AuthenticationAuthenticated) {
      return const MainScreen();
    }
    if (state is AuthenticationUnauthenticated) {
      // create LoginBloc only when showing login as home
      return BlocProvider(
        create: (ctx) => LoginBloc(
          loginUseCase: sl(),
          authenticationBloc: ctx.read<AuthenticationBloc>(),
        ),
        child: const LoginScreen(),
      );
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
