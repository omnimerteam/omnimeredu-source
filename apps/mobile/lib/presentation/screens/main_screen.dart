import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/login/login_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/common/home_header_widget.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/progress/progress_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/more/more_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/features/feature_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Start with Dashboard (center)
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController?.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          final user = state.user;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  // Header
                  HomeHeaderWidget(
                    user: user,
                    onAccountTap: () => _navigateToAccount(context),
                    onProfileTap: () => _navigateToProfile(context),
                    onLogoutTap: () => _handleLogout(context),
                  ),

                  // Main Content
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      children: [
                        FeatureScreen(user: user),
                        DashboardScreen(user: user),
                        ProgressScreen(user: user),
                        const MoreScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(context, user),
          );
        }

        if (state is AuthenticationUnauthenticated) {
          return const LoginScreen();
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, dynamic user) {
    final role = user.roleName?.toLowerCase() ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.featured_play_list),
            activeIcon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.featured_play_list),
            ),
            label: _getFeatureLabel(role),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            activeIcon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.dashboard),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.trending_up),
            activeIcon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.trending_up),
            ),
            label: _getProgressLabel(role),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz),
            activeIcon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.more_horiz),
            ),
            label: 'Thêm',
          ),
        ],
      ),
    );
  }

  String _getFeatureLabel(String role) {
    final normalizedRole = role.toLowerCase().trim();

    switch (normalizedRole) {
      case 'student':
      case 'học sinh':
        return 'Học tập';
      case 'teacher':
      case 'giáo viên':
        return 'Giảng dạy';
      case 'schooladmin':
      case 'quản trị trường':
        return 'Quản lý';
      default:
        return 'Tính năng';
    }
  }

  String _getProgressLabel(String role) {
    final normalizedRole = role.toLowerCase().trim();
    switch (normalizedRole) {
      case 'student':
      case 'học sinh':
        return 'Tiến độ';
      case 'teacher':
      case 'giáo viên':
        return 'Thống kê';
      case 'schooladmin':
      case 'quản trị trường':
        return 'Báo cáo';
      default:
        return 'Tiến trình';
    }
  }

  void _navigateToAccount(BuildContext context) {
    // TODO: Navigate to account screen
    print('Navigate to account');
  }

  void _navigateToProfile(BuildContext context) {
    // TODO: Navigate to profile screen
    print('Navigate to profile');
  }

  void _handleLogout(BuildContext context) {
    context.read<AuthenticationBloc>().add(AuthenticationLoggedOut());
  }
}
