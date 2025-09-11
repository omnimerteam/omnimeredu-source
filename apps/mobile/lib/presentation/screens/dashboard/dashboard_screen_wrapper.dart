import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

      // Lấy DashboardCubit có sẵn
      final dashboardCubit = context.read<DashboardCubit>();

      // Gọi loadDashboard (nếu cần đảm bảo chỉ gọi 1 lần thì nên đưa vào BlocListener)
      dashboardCubit.loadDashboard(user.roleName);

      return DashboardScreen(user: user);
    }

    return const Center(child: CircularProgressIndicator());
  }
}
