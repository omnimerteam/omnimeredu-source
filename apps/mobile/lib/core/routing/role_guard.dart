/// Role Guard để kiểm soát quyền truy cập theo vai trò người dùng
///
/// Cách sử dụng:
/// 1. Thêm role mapping vào [roleAlias] để chuẩn hóa tên role từ database
/// 2. Định nghĩa quyền truy cập cho từng route trong [accessRules]
/// 3. Sử dụng [canAccess] để kiểm tra quyền truy cập
/// 4. Sử dụng [getNormalizedRole] để lấy role chuẩn hóa
class RoleGuard {
  /// Map role từ database về role chuẩn hóa
  ///
  /// Ví dụ:
  /// ```dart
  /// static const Map<String, String> roleAlias = {
  ///   'User': 'user',
  ///   'Admin': 'admin',
  ///   'Teacher': 'teacher',
  /// };
  /// ```
  static const Map<String, String> roleAlias = {
    'User': 'user',
    'SchoolAdmin': 'school_admin',
    'Teacher': 'teacher',
    'Student': 'student',
    // TODO: Thêm các role mapping khác ở đây
  };

  /// Định nghĩa quyền truy cập cho từng route
  ///
  /// Ví dụ:
  /// ```dart
  /// static const Map<String, List<String>> accessRules = {
  ///   '/admin-panel': ['admin'],
  ///   '/home': ['user', 'admin', 'teacher'],
  ///   '/profile': ['user', 'admin'],
  /// };
  /// ```
  static const Map<String, List<String>> accessRules = {
    '/home': ['user', 'school_admin'],
    '/school-admin/school': ['school_admin'],
    '/school-admin/classes': ['school_admin'],
    '/school-admin/grades': ['school_admin'],
    '/school-admin/membership-requests': ['school_admin'],
    '/school-admin/students': ['school_admin'],
    '/school-admin/personnel': ['school_admin'],
    '/school-admin/attendance': ['school_admin'],
    '/school-admin/tuition': ['school_admin'],
    '/teacher/home': ['teacher'],
    '/teacher/attendance': ['teacher'],
    '/teacher/qr': ['teacher'],
    '/student/home': ['student'],
    '/student/scan-qr': ['student'],
    // TODO: Thêm các route và quyền truy cập ở đây
  };

  /// Kiểm tra xem người dùng (với danh sách roleName) có quyền truy cập route không
  ///
  /// Tham số:
  /// - [dbRoles]: Danh sách role từ database
  /// - [routeName]: Tên route cần kiểm tra
  ///
  /// Trả về: true nếu có quyền, false nếu không
  static bool canAccess(List<String>? dbRoles, String routeName) {
    if (dbRoles == null || dbRoles.isEmpty) return false;

    // Chuẩn hóa tất cả role về key chuẩn
    final normalizedRoles = dbRoles
        .map((role) => roleAlias[role] ?? role.toLowerCase())
        .toList();

    // Lấy danh sách role được phép truy cập route
    final allowedRoles = accessRules[routeName];

    // Nếu route không có trong rules, cho phép tất cả
    if (allowedRoles == null) return true;

    // Chỉ cần có ít nhất 1 role nằm trong danh sách allowedRoles là được
    return normalizedRoles.any((role) => allowedRoles.contains(role));
  }

  /// Lấy role chuẩn hóa (nếu chỉ muốn xử lý một role đơn lẻ)
  ///
  /// Tham số:
  /// - [dbRole]: Role từ database
  ///
  /// Trả về: Role đã chuẩn hóa hoặc null
  static String? getNormalizedRole(String? dbRole) {
    if (dbRole == null) return null;
    return roleAlias[dbRole] ?? dbRole.toLowerCase();
  }
}
