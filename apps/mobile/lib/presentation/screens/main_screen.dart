import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/core/widget/keep_alive_wrapper.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/common/home_header_widget.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_feature/main_feature_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/more/more_screen.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/login/login_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/cubit/teacher_classes_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_feature/teacher/bloc/teacher_attendance_bloc.dart';
import 'package:flutter_ios_android_platforms/injection_container.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String? _selectedClassId; // classId chọn từ bên ngoài
  PageController? _pageController;
  late AnimationController _animationController;
  late List<AnimationController> _iconAnimationControllers;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _iconAnimationControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _iconAnimationControllers[_selectedIndex].forward();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _animationController.dispose();
    for (var controller in _iconAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Mở tab điểm danh + truyền classId
  void openTeacherAttendance(String classId, DateTime date) {
    setState(() {
      _selectedIndex = 1;
      _selectedClassId = classId; // gán classId
    });
    _pageController?.jumpToPage(1);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    _iconAnimationControllers[_selectedIndex].reverse();
    _iconAnimationControllers[index].forward();

    setState(() {
      _selectedIndex = index;
    });

    if ((index - _selectedIndex).abs() == 1) {
      _pageController?.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController?.jumpToPage(index);
    }
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
              body: SafeArea(
                child: Column(
                  children: [
                    HomeHeaderWidget(),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          _iconAnimationControllers[_selectedIndex].reverse();
                          _iconAnimationControllers[index].forward();

                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        children: [
                          KeepAliveWrapper(child: DashboardScreen(user: user)),
                          KeepAliveWrapper(
                            child: MainFeatureScreen(
                              user: user,
                              classId: _selectedClassId, // truyền trực tiếp
                            ),
                          ),
                          const MoreScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: _buildCustomBottomNavigationBar(
                context,
                role,
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
            // Thêm các providers khác cho SchoolAdmin nếu cần
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
            // Thêm các providers khác cho Student nếu cần
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

  Widget _buildCustomBottomNavigationBar(BuildContext context, String roleKey) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, -5),
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              context,
              icon: Icons.dashboard_rounded,
              label: 'Dashboard',
              index: 0,
              isSelected: _selectedIndex == 0,
            ),
            _buildNavItem(
              context,
              icon: _getIconMainFeature(roleKey),
              label: _getLabelMainFeature(roleKey),
              index: 1,
              isSelected: _selectedIndex == 1,
            ),
            _buildNavItem(
              context,
              icon: Icons.menu_rounded,
              label: 'Thêm',
              index: 2,
              isSelected: _selectedIndex == 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _onItemTapped(index),
        child: SizedBox(
          height: 90,
          child: AnimatedBuilder(
            animation: _iconAnimationControllers[index],
            builder: (context, child) {
              final curvedValue = Curves.easeOutBack.transform(
                _iconAnimationControllers[index].value,
              );

              final scale = 1.0 + (curvedValue * 0.12);
              final iconSize = 26.0 + (curvedValue * 4.0);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: scale,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      width: isSelected ? 50 : 44,
                      height: isSelected ? 50 : 44,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.8),
                                  AppColors.primary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        icon,
                        size: iconSize,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: isSelected ? 11 : 10,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
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
        return Icons.school;
      case 'Teacher':
        return Icons.how_to_reg;
      case 'SchoolAdmin':
        return Icons.bar_chart;
      default:
        return Icons.timeline;
    }
  }
}
