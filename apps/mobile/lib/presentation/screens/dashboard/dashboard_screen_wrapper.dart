import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/injection_container.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_state.dart';

class DashboardScreenWrapper extends StatelessWidget {
  const DashboardScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthenticationBloc>().state;

    if (state is AuthenticationAuthenticated) {
      final user = state.user;

      return BlocProvider(
        create: (_) => sl<DashboardCubit>()..loadDashboard(user.roleName),
        child: DashboardScreen(user: user),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}
