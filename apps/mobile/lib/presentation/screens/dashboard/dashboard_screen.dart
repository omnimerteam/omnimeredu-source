import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/school_admin_dashboard_data_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/cubit/dashboard_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/widget/schooladmin_dashboard.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/widget/default_dashboard.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/widget/welcome_card.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/skeleton/skeleton_loader_widget.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/skeleton/quick_actions_grid_widget.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/role_helper.dart';

class DashboardScreen extends StatelessWidget {
  final AuthUserEntity user;

  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(
        repository: context.read(), // inject repository
        cacheService: context.read(), // inject cache service
      )..loadDashboard(user.roleName), // load ngay khi mở
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const SkeletonLoaderWidget();
          } else if (state is DashboardError) {
            return _buildErrorState(context, state.message, user.roleName);
          } else if (state is DashboardLoaded) {
            return _buildLoadedState(context, state, user);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, String role) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Đã có lỗi xảy ra',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<DashboardCubit>().loadDashboard(role);
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(
    BuildContext context,
    DashboardLoaded state,
    AuthUserEntity user,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<DashboardCubit>().refreshDashboard(state.role);
      },
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            WelcomeCard(user: user),
            const SizedBox(height: 20),

            // Quick Actions
            _buildSectionTitle(context, 'Thao tác nhanh'),
            const SizedBox(height: 12),
            QuickActionsGridWidget(role: state.role),
            const SizedBox(height: 20),

            // Role-specific content
            _buildRoleBasedContent(user, state),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildRoleBasedContent(AuthUserEntity user, DashboardLoaded state) {
    switch (user.roleName) {
      // case UserRole.student:
      //   if (state.data is StudentDashboardDataEntity) {
      //     return StudentDashboard(
      //       user: user,
      //       data: state.data as StudentDashboardDataEntity,
      //     );
      //   }
      //   return const DefaultDashboard();

      // case UserRole.teacher:
      //   if (state.data is TeacherDashboardDataEntity) {
      //     return TeacherDashboard(
      //       user: user,
      //       data: state.data as TeacherDashboardDataEntity,
      //     );
      //   }
      //   return const DefaultDashboard();

      case UserRole.schoolAdmin:
        if (state.data is SchoolAdminDashboardDataEntity) {
          return SchoolAdminDashboard(
            data: state.data as SchoolAdminDashboardDataEntity,
          );
        }
        return const DefaultDashboard();

      default:
        return const DefaultDashboard();
    }
  }
}
