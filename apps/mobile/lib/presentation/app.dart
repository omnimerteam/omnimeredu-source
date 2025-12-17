import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/presentation/app_view.dart';
import 'package:mobile/presentation/common/blocs/auth_bloc/auth_bloc.dart';
import 'package:mobile/services/locator.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Pixel 9 Pro specifications: 427x952 dp
      designSize: const Size(427, 952),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: sl(),
            logoutUseCase: sl(),
            getCurrentUserUseCase: sl(),
            registerUserUseCase: sl(),
          )..add(AuthCheckRequested()),
          child: const AppView(),
        );
      },
    );
  }
}
