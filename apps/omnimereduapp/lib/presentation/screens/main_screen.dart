import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widget/keep_alive_wrapper.dart';
import '../widgets/common/home_header_widget.dart';
import '../../core/bloc/authentication/authentication_bloc.dart';
import '../../core/bloc/authentication/authentication_state.dart';
import 'auth/login/login_screen.dart';
import 'dashboard/cubit/dashboard_cubit.dart';
import 'dashboard/teacher/cubit/teacher_classes_cubit.dart';
import 'common/class_selector/bloc/class_selector_bloc.dart';
import 'common/class_selector/bloc/class_selector_event.dart';
import 'main_feature/teacher/bloc/teacher_attendance_bloc.dart';
import 'navigation/navigation_config.dart';
import '../../injection_container.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? _selectedClassId; // classId chọn từ bên ngoài
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  /// Mở tab điểm danh + truyền classId
  void openTeacherAttendance(String classId, DateTime date) {
    setState(() {
      _selectedIndex = 1;
      _selectedClassId = classId;
    });
    // CurvedNavigationBar doesn't have a direct controller to animate to index externally
    // without using the key state if exposed, but setState index update handles the view.
    // To update the bar visual:
    final navState = _bottomNavigationKey.currentState;
    if (navState != null) {
      navState.setPage(1);
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          final user = state.user;
          final role = user.roleName;

          return _buildRoleBasedProviders(
            role: role,
            user: user,
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              extendBody:
                  true, // Important for CurvedNavigationBar transparency effect
              body: SafeArea(
                bottom:
                    false, // Allow content to go behind nav bar if needed, but we used extendBody
                child: Column(
                  children: [
                    HomeHeaderWidget(),
                    Expanded(child: _buildPageContent(user, role)),
                  ],
                ),
              ),
              bottomNavigationBar: _buildCurvedNavigationBar(
                context,
                role,
                user,
              ),
            ),
          );
        }

        if (state is AuthenticationUnauthenticated) {
          return const LoginScreen();
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  /// Khởi tạo các BLoC/Cubit theo vai trò
  Widget _buildRoleBasedProviders({
    required String role,
    required dynamic user,
    required Widget child,
  }) {
    switch (role) {
      case 'Teacher':
      case 'giáo viên':
        return MultiBlocProvider(
          providers: [
            // Dashboard providers
            BlocProvider(
              create: (_) => sl<DashboardCubit>()..loadDashboard(role),
            ),
            BlocProvider(create: (_) => sl<TeacherClassesCubit>()),
            // MainFeature providers
            BlocProvider(create: (_) => sl<TeacherAttendanceBloc>()),
            BlocProvider(
              create: (_) {
                final bloc = sl<ClassSelectorBloc>();
                if (user.id.isNotEmpty) {
                  bloc.add(LoadClassesByTeacher(user.id));
                }
                return bloc;
              },
            ),
          ],
          child: child,
        );

      case 'SchoolAdmin':
        return MultiBlocProvider(
          providers: [
            // Dashboard providers
            BlocProvider(
              create: (_) => sl<DashboardCubit>()..loadDashboard(role),
            ),
          ],
          child: child,
        );

      case 'Student':
        return MultiBlocProvider(
          providers: [
            // Dashboard providers
            BlocProvider(
              create: (_) => sl<DashboardCubit>()..loadDashboard(role),
            ),
          ],
          child: child,
        );

      case 'Staff':
        return MultiBlocProvider(
          providers: [
            // Dashboard providers
            BlocProvider(
              create: (_) => sl<DashboardCubit>()..loadDashboard(role),
            ),
          ],
          child: child,
        );

      default:
        return BlocProvider(
          create: (_) => sl<DashboardCubit>()..loadDashboard(role),
          child: child,
        );
    }
  }

  Widget _buildPageContent(dynamic user, String role) {
    final navItems = NavigationConfig.getNavItems(
      role: role,
      user: user,
      classId: _selectedClassId,
    );

    // Ensure selectedIndex is valid
    if (_selectedIndex >= navItems.length) {
      _selectedIndex = 0;
    }

    return IndexedStack(
      index: _selectedIndex,
      children: navItems
          .map((item) => KeepAliveWrapper(child: item.screen))
          .toList(),
    );
  }

  Widget _buildCurvedNavigationBar(
    BuildContext context,
    String role,
    dynamic user,
  ) {
    final navItems = NavigationConfig.getNavItems(role: role, user: user);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _selectedIndex,
      height: 65,
      items: navItems
          .map(
            (item) =>
                _buildNavItem(item.icon, item.label, navItems.indexOf(item)),
          )
          .toList(),
      color: isDarkMode ? AppColors.grey800 : Colors.white,
      buttonBackgroundColor: AppColors.primary,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 400),
      onTap: _onItemTapped,
      letIndexChange: (index) => true,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    // CurvedNavigationBar items are just icons usually, but we can try complex widgets.
    // However, CurvedNavigationBar expects widgets to be uniform size usually or it might look weird.
    // Standard usage is just Icon. Let's try to include label if selected or always?
    // CurvedNavigationBar transforms the selected item (moves it up).
    // Putting text might be tight.
    // Let's stick to Icon for now to match the "Curved" aesthetic which is usually icon-only for the floating button.
    // But wait, the request mentioned "Sắp xếp lại để các tính năng rõ ràng cho người dùng hơn". Labels help clarity.
    // The previous implementation had labels.
    // Let's try to put Icon.

    return Icon(
      icon,
      size: 30,
      color: isSelected ? Colors.white : AppColors.grey600,
    );
  }
}
