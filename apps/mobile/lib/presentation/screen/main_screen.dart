import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../core/bloc/authentication/authentication_bloc.dart';
// import '../../core/bloc/authentication/authentication_state.dart';

// TODO: Import các màn hình con khi đã tạo
// import 'dashboard/dashboard_screen.dart';
// import 'main_feature/main_feature_screen.dart';
// import 'more/more_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Mock data cho role (khi chưa có AuthBloc)
  final String _currentRole =
      'Student'; // Test: 'Student', 'Teacher', 'SchoolAdmin'

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
    // TODO: Sử dụng BlocBuilder<AuthenticationBloc> để lấy role thực tế
    /*
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
           final role = state.user.roleName;
           return _buildScaffold(role);
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    );
    */

    return _buildScaffold(_currentRole);
  }

  Widget _buildScaffold(String role) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true, // Quan trọng để background tràn xuống dưới bottom bar
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Chặn swipe để tránh xung đột
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          // Index 0: Dashboard
          _buildPlaceholderScreen("Dashboard Screen", Colors.blue.shade50),

          // Index 1: Main Feature (Role based)
          _buildPlaceholderScreen(
            "${_getLabelMainFeature(role)} Screen",
            Colors.green.shade50,
          ),

          // Index 2: More / Settings
          _buildPlaceholderScreen("Menu & Settings", Colors.orange.shade50),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _selectedIndex,
        backgroundColor: Colors.transparent, // Để nhìn thấy nội dung phía sau
        color: isDarkMode ? AppColors.grey900 : Colors.white,
        buttonBackgroundColor: AppColors.primary,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        iconPadding: 12,
        onTap: (index) {
          _onItemTapped(index);
        },
        items: [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.dashboard_rounded,
              size: 26,
              color: _selectedIndex == 0 ? Colors.white : AppColors.grey600,
            ),
            label: 'Home',
            labelStyle: _getLabelStyle(_selectedIndex == 0),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              _getIconMainFeature(role),
              size: 26,
              color: _selectedIndex == 1 ? Colors.white : AppColors.grey600,
            ),
            label: _getLabelMainFeature(role),
            labelStyle: _getLabelStyle(_selectedIndex == 1),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.menu_rounded,
              size: 26,
              color: _selectedIndex == 2 ? Colors.white : AppColors.grey600,
            ),
            label: 'Menu',
            labelStyle: _getLabelStyle(_selectedIndex == 2),
          ),
        ],
      ),
    );
  }

  TextStyle _getLabelStyle(bool isSelected) {
    return TextStyle(
      fontSize: 12,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      color: isSelected ? AppColors.primary : AppColors.grey600,
      fontFamily: 'Inter', // From AppTheme
    );
  }

  String _getLabelMainFeature(String roleKey) {
    switch (roleKey) {
      case 'Student':
        return 'Học tập';
      case 'Teacher':
        return 'Điểm danh';
      case 'SchoolAdmin':
        return 'Báo cáo';
      default:
        return 'Tiến trình';
    }
  }

  IconData _getIconMainFeature(String roleKey) {
    switch (roleKey) {
      case 'Student':
        return Icons.school_rounded;
      case 'Teacher':
        return Icons.how_to_reg_rounded;
      case 'SchoolAdmin':
        return Icons.bar_chart_rounded;
      default:
        return Icons.timeline_rounded;
    }
  }

  // Placeholder widget tạm thời
  Widget _buildPlaceholderScreen(String title, Color bgColor) {
    return Container(
      color: bgColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text("Coming Soon..."),
          ],
        ),
      ),
    );
  }
}
