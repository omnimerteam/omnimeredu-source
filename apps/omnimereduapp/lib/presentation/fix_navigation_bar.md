# Hướng Dẫn Sửa Navigation Bar với CurvedNavigationBar

## 1. Giới Thiệu

Hướng dẫn này mô tả cách thay thế navigation bar hiện tại bằng `curved_navigation_bar` package để tạo trải nghiệm người dùng mượt mà và hiện đại hơn cho các roles: **SchoolAdmin**, **Teacher**, **Student**, **Staff**.

### Dependencies Cần Thêm

```yaml
# pubspec.yaml
dependencies:
  curved_navigation_bar: ^1.0.6
```

---

## 2. Phân Tích Tính Năng Theo Role

### 2.1. Tính Năng CHUNG (Tất cả roles)

| Tab       | Icon                 | Label     | Screen            |
| --------- | -------------------- | --------- | ----------------- |
| Dashboard | `Icons.home_rounded` | Trang chủ | `DashboardScreen` |
| More      | `Icons.menu_rounded` | Thêm      | `MoreScreen`      |

### 2.2. Tính Năng RIÊNG BIỆT

| Role            | Tab Riêng | Icon                         | Label       | Screen                    |
| --------------- | --------- | ---------------------------- | ----------- | ------------------------- |
| **SchoolAdmin** | Báo cáo   | `Icons.bar_chart_rounded`    | Thống kê    | `AdminReportScreen`       |
|                 | Quản lý   | `Icons.admin_panel_settings` | Quản lý     | `AdminManagementScreen`   |
| **Teacher**     | Điểm danh | `Icons.how_to_reg_rounded`   | Điểm danh   | `TeacherAttendanceScreen` |
|                 | Lớp học   | `Icons.class_rounded`        | Lớp của tôi | `TeacherClassesScreen`    |
| **Student**     | Học tập   | `Icons.menu_book_rounded`    | Học tập     | `StudentLearningScreen`   |
|                 | Điểm danh | `Icons.qr_code_scanner`      | Quét QR     | `QRScannerScreen`         |
| **Staff**       | Công việc | `Icons.work_rounded`         | Công việc   | `StaffTasksScreen`        |

---

## 3. Cấu Trúc Navigation Mới

### 3.1. SchoolAdmin (4 tabs)

```
[🏠 Trang chủ] [📊 Thống kê] [⚙️ Quản lý] [≡ Thêm]
```

### 3.2. Teacher (4 tabs)

```
[🏠 Trang chủ] [✓ Điểm danh] [📚 Lớp học] [≡ Thêm]
```

### 3.3. Student (4 tabs)

```
[🏠 Trang chủ] [📖 Học tập] [📷 Quét QR] [≡ Thêm]
```

### 3.4. Staff (3 tabs)

```
[🏠 Trang chủ] [💼 Công việc] [≡ Thêm]
```

---

## 4. Implementation Code

### 4.1. Tạo file `navigation_config.dart`

```dart
// lib/presentation/screens/navigation/navigation_config.dart

import 'package:flutter/material.dart';

/// Cấu hình navigation item
class NavItem {
  final IconData icon;
  final String label;
  final Widget screen;

  const NavItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}

/// Lấy navigation items theo role
class NavigationConfig {
  static List<NavItem> getNavItems({
    required String role,
    required dynamic user,
    String? classId,
  }) {
    switch (role) {
      case 'SchoolAdmin':
        return _getSchoolAdminNavItems(user);
      case 'Teacher':
        return _getTeacherNavItems(user, classId);
      case 'Student':
        return _getStudentNavItems(user);
      case 'Staff':
        return _getStaffNavItems(user);
      default:
        return _getDefaultNavItems(user);
    }
  }

  static List<NavItem> _getSchoolAdminNavItems(dynamic user) {
    return [
      NavItem(
        icon: Icons.home_rounded,
        label: 'Trang chủ',
        screen: DashboardScreen(user: user),
      ),
      NavItem(
        icon: Icons.bar_chart_rounded,
        label: 'Thống kê',
        screen: AdminReportScreen(), // TODO: Implement
      ),
      NavItem(
        icon: Icons.admin_panel_settings,
        label: 'Quản lý',
        screen: AdminManagementScreen(), // TODO: Implement
      ),
      const NavItem(
        icon: Icons.menu_rounded,
        label: 'Thêm',
        screen: MoreScreen(),
      ),
    ];
  }

  static List<NavItem> _getTeacherNavItems(dynamic user, String? classId) {
    return [
      NavItem(
        icon: Icons.home_rounded,
        label: 'Trang chủ',
        screen: DashboardScreen(user: user),
      ),
      NavItem(
        icon: Icons.how_to_reg_rounded,
        label: 'Điểm danh',
        screen: MainFeatureScreen(user: user, classId: classId),
      ),
      NavItem(
        icon: Icons.class_rounded,
        label: 'Lớp học',
        screen: TeacherClassesListScreen(), // TODO: Implement
      ),
      const NavItem(
        icon: Icons.menu_rounded,
        label: 'Thêm',
        screen: MoreScreen(),
      ),
    ];
  }

  static List<NavItem> _getStudentNavItems(dynamic user) {
    return [
      NavItem(
        icon: Icons.home_rounded,
        label: 'Trang chủ',
        screen: DashboardScreen(user: user),
      ),
      NavItem(
        icon: Icons.menu_book_rounded,
        label: 'Học tập',
        screen: StudentLearningScreen(), // TODO: Implement
      ),
      const NavItem(
        icon: Icons.qr_code_scanner,
        label: 'Quét QR',
        screen: QRScannerScreen(),
      ),
      const NavItem(
        icon: Icons.menu_rounded,
        label: 'Thêm',
        screen: MoreScreen(),
      ),
    ];
  }

  static List<NavItem> _getStaffNavItems(dynamic user) {
    return [
      NavItem(
        icon: Icons.home_rounded,
        label: 'Trang chủ',
        screen: DashboardScreen(user: user),
      ),
      NavItem(
        icon: Icons.work_rounded,
        label: 'Công việc',
        screen: StaffTasksScreen(), // TODO: Implement
      ),
      const NavItem(
        icon: Icons.menu_rounded,
        label: 'Thêm',
        screen: MoreScreen(),
      ),
    ];
  }

  static List<NavItem> _getDefaultNavItems(dynamic user) {
    return [
      NavItem(
        icon: Icons.home_rounded,
        label: 'Trang chủ',
        screen: DashboardScreen(user: user),
      ),
      const NavItem(
        icon: Icons.menu_rounded,
        label: 'Thêm',
        screen: MoreScreen(),
      ),
    ];
  }
}
```

### 4.2. Sửa `main_screen.dart` với CurvedNavigationBar

```dart
// lib/presentation/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widget/keep_alive_wrapper.dart';
import '../widgets/common/home_header_widget.dart';
import 'main_feature/main_feature_screen.dart';
import 'more/more_screen.dart';
import '../../core/bloc/authentication/authentication_bloc.dart';
import '../../core/bloc/authentication/authentication_state.dart';
import 'auth/login/login_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'dashboard/cubit/dashboard_cubit.dart';
import 'dashboard/teacher/cubit/teacher_classes_cubit.dart';
import 'common/class_selector/bloc/class_selector_bloc.dart';
import 'common/class_selector/bloc/class_selector_event.dart';
import 'main_feature/teacher/bloc/teacher_attendance_bloc.dart';
import 'qr_attendance/student/qr_scanner_screen.dart';
import '../../injection_container.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? _selectedClassId;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  /// Mở tab điểm danh + truyền classId
  void openTeacherAttendance(String classId, DateTime date) {
    setState(() {
      _selectedIndex = 1;
      _selectedClassId = classId;
    });
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
              body: SafeArea(
                child: Column(
                  children: [
                    HomeHeaderWidget(),
                    Expanded(
                      child: _buildPageContent(user, role),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: _buildCurvedNavigationBar(context, role),
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

  /// Build page content based on selected index and role
  Widget _buildPageContent(dynamic user, String role) {
    final screens = _getScreensForRole(user, role);
    return IndexedStack(
      index: _selectedIndex,
      children: screens.map((screen) => KeepAliveWrapper(child: screen)).toList(),
    );
  }

  /// Get screens list based on role
  List<Widget> _getScreensForRole(dynamic user, String role) {
    switch (role) {
      case 'SchoolAdmin':
        return [
          DashboardScreen(user: user),
          _buildUnderDevelopment('Thống kê'), // AdminReportScreen
          _buildUnderDevelopment('Quản lý'),  // AdminManagementScreen
          const MoreScreen(),
        ];

      case 'Teacher':
        return [
          DashboardScreen(user: user),
          MainFeatureScreen(user: user, classId: _selectedClassId),
          _buildUnderDevelopment('Lớp học'), // TeacherClassesListScreen
          const MoreScreen(),
        ];

      case 'Student':
        return [
          DashboardScreen(user: user),
          _buildUnderDevelopment('Học tập'),  // StudentLearningScreen
          const QRScannerScreen(),
          const MoreScreen(),
        ];

      case 'Staff':
        return [
          DashboardScreen(user: user),
          _buildUnderDevelopment('Công việc'), // StaffTasksScreen
          const MoreScreen(),
        ];

      default:
        return [
          DashboardScreen(user: user),
          const MoreScreen(),
        ];
    }
  }

  Widget _buildUnderDevelopment(String featureName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: AppColors.grey400),
          const SizedBox(height: 16),
          Text(
            '$featureName đang phát triển',
            style: TextStyle(fontSize: 18, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  /// Build CurvedNavigationBar based on role
  Widget _buildCurvedNavigationBar(BuildContext context, String role) {
    final items = _getNavItemsForRole(role);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _selectedIndex,
      height: 65,
      items: items,
      color: isDarkMode ? AppColors.grey800 : Colors.white,
      buttonBackgroundColor: AppColors.primary,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 400),
      onTap: _onItemTapped,
      letIndexChange: (index) => true,
    );
  }

  /// Get navigation icons based on role
  List<Widget> _getNavItemsForRole(String role) {
    switch (role) {
      case 'SchoolAdmin':
        return [
          _buildNavIcon(Icons.home_rounded, 0),
          _buildNavIcon(Icons.bar_chart_rounded, 1),
          _buildNavIcon(Icons.admin_panel_settings, 2),
          _buildNavIcon(Icons.menu_rounded, 3),
        ];

      case 'Teacher':
        return [
          _buildNavIcon(Icons.home_rounded, 0),
          _buildNavIcon(Icons.how_to_reg_rounded, 1),
          _buildNavIcon(Icons.class_rounded, 2),
          _buildNavIcon(Icons.menu_rounded, 3),
        ];

      case 'Student':
        return [
          _buildNavIcon(Icons.home_rounded, 0),
          _buildNavIcon(Icons.menu_book_rounded, 1),
          _buildNavIcon(Icons.qr_code_scanner, 2),
          _buildNavIcon(Icons.menu_rounded, 3),
        ];

      case 'Staff':
        return [
          _buildNavIcon(Icons.home_rounded, 0),
          _buildNavIcon(Icons.work_rounded, 1),
          _buildNavIcon(Icons.menu_rounded, 2),
        ];

      default:
        return [
          _buildNavIcon(Icons.home_rounded, 0),
          _buildNavIcon(Icons.menu_rounded, 1),
        ];
    }
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return Icon(
      icon,
      size: 28,
      color: isSelected ? Colors.white : AppColors.grey600,
    );
  }

  /// Khởi tạo các BLoC/Cubit theo vai trò (giữ nguyên logic)
  Widget _buildRoleBasedProviders({
    required String role,
    required dynamic user,
    required Widget child,
  }) {
    switch (role) {
      case 'Teacher':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<DashboardCubit>()..loadDashboard(role),
            ),
            BlocProvider(create: (_) => sl<TeacherClassesCubit>()),
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
            BlocProvider(
              create: (_) => sl<DashboardCubit>()..loadDashboard(role),
            ),
          ],
          child: child,
        );

      case 'Student':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<DashboardCubit>()..loadDashboard(role),
            ),
            // Thêm providers cho QR Scanner nếu cần
          ],
          child: child,
        );

      case 'Staff':
        return MultiBlocProvider(
          providers: [
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
}
```

---

## 5. Tùy Chỉnh Giao Diện CurvedNavigationBar

### 5.1. Thêm Label dưới Icon

```dart
Widget _buildNavItem(IconData icon, String label, int index) {
  final isSelected = _selectedIndex == index;
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        size: 26,
        color: isSelected ? Colors.white : AppColors.grey600,
      ),
      if (!isSelected) ...[
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.grey600,
          ),
        ),
      ],
    ],
  );
}
```

### 5.2. Custom Theme cho CurvedNavigationBar

```dart
// Trong file theme hoặc constants
class NavBarTheme {
  static const double height = 65.0;
  static const Duration animationDuration = Duration(milliseconds: 400);
  static const Curve animationCurve = Curves.easeInOut;

  static Color getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.grey800 : Colors.white;
  }

  static Color get buttonColor => AppColors.primary;
}
```

---

## 6. So Sánh Cấu Trúc Cũ vs Mới

### Cũ (Custom BottomNavigationBar)

- ❌ Code phức tạp với AnimationController
- ❌ Hardcode 3 tabs cho tất cả roles
- ❌ Không linh hoạt khi thêm role mới

### Mới (CurvedNavigationBar)

- ✅ Code gọn gàng, dễ maintain
- ✅ Số tabs linh hoạt theo role
- ✅ Animation mượt mà built-in
- ✅ Dễ dàng customize

---

## 7. Checklist Implementation

- [ ] Thêm `curved_navigation_bar: ^1.0.6` vào pubspec.yaml
- [ ] Chạy `flutter pub get`
- [ ] Tạo file `navigation_config.dart`
- [ ] Cập nhật `main_screen.dart`
- [ ] Tạo placeholder screens cho các tính năng chưa có:
  - [ ] `AdminReportScreen`
  - [ ] `AdminManagementScreen`
  - [ ] `TeacherClassesListScreen`
  - [ ] `StudentLearningScreen`
  - [ ] `StaffTasksScreen`
- [ ] Test trên các roles khác nhau
- [ ] Đảm bảo IndexedStack giữ state

---

## 8. Notes

### Vấn Đề Cần Lưu Ý

1. **IndexedStack vs PageView**: Sử dụng `IndexedStack` để giữ state của các screens, không rebuild khi chuyển tab.
2. **KeepAliveWrapper**: Vẫn cần để giữ state phức tạp như scroll position.
3. **Provider Scope**: Đảm bảo các BLoC/Cubit được provide ở đúng scope theo role.

### Tính Năng Nâng Cao

- Badge notification trên nav item
- Deep linking vào tab cụ thể
- Swipe gesture giữa các tabs (nếu cần)

---

**Last Updated:** 2025-12-22
