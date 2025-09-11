import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/school_admin_dashboard_data_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/cubit/dashboard_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/school_admin/schooladmin_dashboard.dart';

class DashboardScreen extends StatelessWidget {
  final AuthUserEntity user;

  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Ở đây bạn giả định rằng DashboardCubit đã được cung cấp ở ancestor (AppView hoặc route)
    final cubit = context.read<DashboardCubit>();

    // Trigger load khi mở màn
    cubit.loadDashboard(user.roleName);

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardError) {
          return Center(child: Text(state.message));
        }

        if (state is DashboardLoaded) {
          return _buildDashboardByRole(context, state.data);
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// Phân UI theo role
  Widget _buildDashboardByRole(BuildContext context, dynamic data) {
    switch (user.roleName) {
      case "SchoolAdmin":
        if (data is SchoolAdminDashboardDataEntity) {
          return RefreshIndicator(
            onRefresh: () =>
                context.read<DashboardCubit>().refreshDashboard(user.roleName),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: SchoolAdminDashboard(data: data),
            ),
          );
        }
        return const Center(
          child: Text("Dữ liệu không hợp lệ cho SchoolAdmin"),
        );

      // TODO: thêm các case khác như teacher, student
      default:
        return const Center(child: Text("Role không được hỗ trợ"));
    }
  }
}
