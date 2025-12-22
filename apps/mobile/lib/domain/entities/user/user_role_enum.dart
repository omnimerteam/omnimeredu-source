/// Enum định nghĩa các vai trò người dùng trong hệ thống
enum UserRole {
  SchoolAdmin('SchoolAdmin', 'Quản trị trường'),
  Teacher('Teacher', 'Giáo viên'),
  Staff('Staff', 'Nhân viên'),
  Student('Student', 'Học sinh');

  final String key;
  final String displayName;

  const UserRole(this.key, this.displayName);

  /// Chuyển đổi từ String sang UserRole
  static UserRole fromString(String? value) {
    if (value == null) {
      throw ArgumentError('UserRole value cannot be null');
    }

    return UserRole.values.firstWhere(
      (role) => role.key == value,
      orElse: () => throw ArgumentError('Invalid UserRole: $value'),
    );
  }

  /// Lấy giá trị String của role
  String get asString => key;
}
