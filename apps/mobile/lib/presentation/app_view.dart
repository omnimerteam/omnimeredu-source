import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import 'common/blocs/auth_bloc/auth_bloc.dart';
import 'screen/main_screen.dart';
import '../../core/routing/route_config.dart';

/// Global navigator key để có thể điều khiển navigation từ bất kỳ đâu
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => RouteConfig.buildAuthPage(RouteConfig.login),
              ),
              (route) => false,
            );
          });
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is AuthRegistered) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState?.pushReplacementNamed(RouteConfig.login);
          });
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'OmniMer EDU',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            home: state is AuthAuthenticated
                ? const MainScreen()
                : RouteConfig.buildAuthPage(RouteConfig.login),
            routes: {
              RouteConfig.login: (context) =>
                  RouteConfig.buildAuthPage(RouteConfig.login),
              RouteConfig.register: (context) =>
                  RouteConfig.buildAuthPage(RouteConfig.register),
              RouteConfig.main: (context) => const MainScreen(),
            },
          );
        },
      ),
    );
  }
}
