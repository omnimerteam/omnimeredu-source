import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/theme/app_colors.dart';
import '../common/blocs/auth_bloc/auth_bloc.dart';
import 'package:mobile/core/routing/route_config.dart';

// Placeholder for Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Settings Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final role = state.user.roleName;
          return _buildScaffold(role);
        }
        // Fallback or loading state if needed, though AppView handles Auth check
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildScaffold(String role) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> pages = _getPages(role);
    final List<CurvedNavigationBarItem> navItems = _getNavItems(role);

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndex,
        backgroundColor: Colors.transparent,
        color: isDarkMode ? AppColors.grey900 : Colors.white,
        buttonBackgroundColor: AppColors.primary,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        iconPadding: 12,
        onTap: _onItemTapped,
        items: navItems,
      ),
    );
  }

  List<Widget> _getPages(String role) {
    final roles = [role];
    switch (role) {
      case 'SchoolAdmin':
        return [
          RouteConfig.buildPage(
            routeName: RouteConfig.schoolAdminDashboard,
            role: roles,
          ),
          RouteConfig.buildPage(
            routeName: RouteConfig.schoolAdminReports,
            role: roles,
          ),
          RouteConfig.buildPage(routeName: RouteConfig.settings, role: roles),
        ];
      case 'Teacher':
        return [
          RouteConfig.buildPage(
            routeName: RouteConfig.teacherHome,
            role: roles,
          ),
          RouteConfig.buildPage(
            routeName: RouteConfig.teacherAttendance,
            role: roles,
          ),
          RouteConfig.buildPage(routeName: RouteConfig.settings, role: roles),
        ];
      case 'Student':
        return [
          RouteConfig.buildPage(
            routeName: RouteConfig.studentHome,
            role: roles,
          ),
          RouteConfig.buildPage(
            routeName: RouteConfig.studentScanQr,
            role: roles,
          ),
          RouteConfig.buildPage(routeName: RouteConfig.settings, role: roles),
        ];
      default:
        return [
          const Center(child: Text("Home")),
          const Center(child: Text("Feature")),
          RouteConfig.buildPage(routeName: RouteConfig.settings, role: roles),
        ];
    }
  }

  List<CurvedNavigationBarItem> _getNavItems(String role) {
    // Common Settings Item
    final settingsItem = CurvedNavigationBarItem(
      child: Icon(
        Icons.settings_rounded,
        size: 26,
        color: _selectedIndex == 2 ? Colors.white : AppColors.grey600,
      ),
      label: 'Cài đặt',
      labelStyle: _getLabelStyle(_selectedIndex == 2),
    );

    switch (role) {
      case 'SchoolAdmin':
        return [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.dashboard_rounded,
              size: 26,
              color: _selectedIndex == 0 ? Colors.white : AppColors.grey600,
            ),
            label: 'Dashboard',
            labelStyle: _getLabelStyle(_selectedIndex == 0),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.bar_chart_rounded,
              size: 26,
              color: _selectedIndex == 1 ? Colors.white : AppColors.grey600,
            ),
            label: 'Báo cáo',
            labelStyle: _getLabelStyle(_selectedIndex == 1),
          ),
          settingsItem,
        ];
      case 'Teacher':
        return [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home_rounded,
              size: 26,
              color: _selectedIndex == 0 ? Colors.white : AppColors.grey600,
            ),
            label: 'Home',
            labelStyle: _getLabelStyle(_selectedIndex == 0),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.post_add_rounded,
              size: 26,
              color: _selectedIndex == 1 ? Colors.white : AppColors.grey600,
            ),
            label: 'Điểm danh',
            labelStyle: _getLabelStyle(_selectedIndex == 1),
          ),
          settingsItem,
        ];
      case 'Student':
        return [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home_rounded,
              size: 26,
              color: _selectedIndex == 0 ? Colors.white : AppColors.grey600,
            ),
            label: 'Home',
            labelStyle: _getLabelStyle(_selectedIndex == 0),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.qr_code_scanner_rounded,
              size: 26,
              color: _selectedIndex == 1 ? Colors.white : AppColors.grey600,
            ),
            label: 'Quét mã',
            labelStyle: _getLabelStyle(_selectedIndex == 1),
          ),
          settingsItem,
        ];
      default:
        return [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home,
              color: _selectedIndex == 0 ? Colors.white : AppColors.grey600,
            ),
            label: 'Home',
            labelStyle: _getLabelStyle(_selectedIndex == 0),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.star,
              color: _selectedIndex == 1 ? Colors.white : AppColors.grey600,
            ),
            label: 'Feature',
            labelStyle: _getLabelStyle(_selectedIndex == 1),
          ),
          settingsItem,
        ];
    }
  }

  TextStyle _getLabelStyle(bool isSelected) {
    return TextStyle(
      fontSize: 12,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      color: isSelected ? AppColors.primary : AppColors.grey600,
      fontFamily: 'Inter',
    );
  }
}
