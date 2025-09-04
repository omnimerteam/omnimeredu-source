import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/injection_container.dart';
import 'package:flutter_ios_android_platforms/presentation/app_view.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/school/school_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LoginBloc>()),
        BlocProvider(create: (_) => sl<RegistrationBloc>()),
        BlocProvider(create: (_) => sl<SchoolBloc>()),
        BlocProvider(create: (_) => sl<ClassBloc>()),
      ],
      child: const AppView(),
    );
  }
}
