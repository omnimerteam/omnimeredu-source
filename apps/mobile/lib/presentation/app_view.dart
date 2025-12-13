import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mobile/core/routing/route_config.dart';
// import 'package:receive_intent/receive_intent.dart' as ri;
// import 'package:url_launcher/url_launcher.dart';
import 'screen/auth/login/login_screen.dart';
import 'screen/auth/registration/registration_screen.dart';
import '../../core/theme/app_theme.dart';

// TODO: Import AuthenticationBloc, LoginCubit, BlocListener...

/// Global navigator key để có thể điều khiển navigation từ bất kỳ đâu
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  void initState() {
    super.initState();
    // TODO: Setup intent checking sau khi cài dependencies
    // _checkIntent();
  }

  // Future<void> _checkIntent() async {
  //   try {
  //     final ri.Intent? intent = await ri.ReceiveIntent.getInitialIntent();
  //     if (intent != null &&
  //         intent.action == 'android.intent.action.VIEW_PERMISSION_USAGE') {
  //       _openPrivacyPolicy();
  //     }
  //   } catch (e) {
  //     debugPrint("Error checking intent: $e");
  //   }
  // }

  // Future<void> _openPrivacyPolicy() async {
  //   final Uri url = Uri.parse(
  //     'https://doc-hosting.flycricket.io/omnimer-health-privacy-policy/37b589ac-7f6f-4ee9-9b0f-fb1ffabc4f04/privacy',
  //   );
  //   if (!await launchUrl(url)) {
  //     debugPrint('Could not launch $url');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: Wrap với BlocListener<AuthenticationBloc> và BlocBuilder<ThemeCubit>
    /*
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) {
        // Chỉ listen khi chuyển sang Unauthenticated (logout)
        return current is AuthenticationUnauthenticated &&
            previous is! AuthenticationUnauthenticated;
      },
      listener: (context, state) {
        if (state is AuthenticationUnauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToLogin();
          });
        }
      },
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
             // ... configuration ...
          );
        },
      ),
    );
    */

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'OmniMer EDU',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // TODO: Lấy từ ThemeCubit
      // home: const AuthWrapper(), // TODO: Dùng AuthWrapper sau khi có Bloc
      home: const AuthWrapper(),
      // onGenerateRoute: ... // TODO: Setup RouteConfig
      routes: {
        '/login': (context) => const LoginScreen(),
        '/registration': (context) => const RegistrationScreen(),
      },
    );
  }

  // void _navigateToLogin() {
  //   final navigator = navigatorKey.currentState;
  //   if (navigator != null) {
  //     navigator.pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (_) => BlocProvider(
  //           create: (_) => LoginCubit(
  //             loginUseCase: sl(),
  //             authenticationBloc: sl<AuthenticationBloc>(),
  //           ),
  //           child: const LoginScreen(),
  //         ),
  //       ),
  //       (route) => false,
  //     );
  //   }
  // }
}

/// Wrapper để quản lý login/logout và routing tự động
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with BlocConsumer when AuthenticationBloc is implemented
    // For now, we'll show the login screen by default
    return const LoginScreen();

    /*
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return const HomeScreen(); // TODO: Import HomeScreen
        } else if (state is AuthenticationUnauthenticated ||
            state is AuthenticationError) {
          return const LoginScreen();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
    */
  }
}
