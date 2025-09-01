class AuthUserEntity {
  final String id;
  final String fullName;
  final String roleName;
  final bool? isVerified;
  final String? schoolName;
  final String? avatarUrl;
  // Các trường thông tin bổ sung tùy từng vai trò
  // SchoolAdmin
  final String? position;
  // Teacher
  final String? literacy;
  // Student
  final String? className;
  final String? educationLevel;
  final String? grade;

  const AuthUserEntity({
    required this.id,
    required this.fullName,
    required this.roleName,
    this.isVerified,
    this.schoolName,
    this.avatarUrl,
    // Các trường thông tin bổ sung tùy từng vai trò
    // SchoolAdmin
    this.position,
    // Teacher
    this.literacy,
    // Student
    this.className,
    this.educationLevel,
    this.grade,
  });
}
