import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/auth/auth_user_entity.dart';
import '../../../domain/entities/dashboard/school_admin/school_admin_dashboard_data_entity.dart';
import '../../../domain/entities/dashboard/teacher/teacher_dashboard_data_entity.dart';
import '../../../injection_container.dart';
import '../common/no_access_screen.dart';
import 'cubit/dashboard_cubit.dart';
import 'cubit/dashboard_state.dart';
import 'school_admin/schooladmin_dashboard.dart';
import 'teacher/cubit/teacher_classes_cubit.dart';
import 'teacher/teacher_dashboard.dart';

class DashboardScreen extends StatelessWidget {
  final AuthUserEntity user;

  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoaded) {
          return _buildDashboardByRole(
            context,
            data: state.data,
            isLoading: false,
          );
        }

        if (state is DashboardError) {
          return _buildDashboardByRole(context, data: null, isLoading: false);
        }

        // DashboardLoading hoặc Initial
        return _buildDashboardByRole(context, data: null, isLoading: true);
      },
    );
  }

  Widget _buildDashboardByRole(
    BuildContext context, {
    required dynamic data,
    required bool isLoading,
  }) {
    switch (user.roleName) {
      case "SchoolAdmin":
        return RefreshIndicator(
          onRefresh: () =>
              context.read<DashboardCubit>().refreshDashboard(user.roleName),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: SchoolAdminDashboard(
              data: data is SchoolAdminDashboardDataEntity ? data : null,
              isLoading: isLoading,
              roleName: user.roleName,
            ),
          ),
        );

      case "Teacher":
        return BlocProvider(
          create: (_) => sl<TeacherClassesCubit>(),
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<DashboardCubit>().refreshDashboard(
                user.roleName,
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: TeacherDashboard(
                user: user,
                data: data is TeacherDashboardDataEntity ? data : null,
                isLoading: isLoading,
              ),
            ),
          ),
        );

      default:
        return NoAccessScreen();
    }
  }
}
