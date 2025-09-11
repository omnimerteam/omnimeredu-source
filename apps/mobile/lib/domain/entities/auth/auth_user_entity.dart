import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String id;
  final String fullName;
  final String roleName;
  final bool? isVerified;
  final String? schoolName;
  final String? avatarUrl;
  final String? position; // SchoolAdmin
  final String? literacy; // Teacher
  final String? className; // Student
  final String? educationLevel;
  final String? grade;

  const AuthUserEntity({
    required this.id,
    required this.fullName,
    required this.roleName,
    this.isVerified,
    this.schoolName,
    this.avatarUrl,
    this.position,
    this.literacy,
    this.className,
    this.educationLevel,
    this.grade,
  });

  static const _noChange = Object();

  AuthUserEntity copyWith({
    Object? id = _noChange,
    Object? fullName = _noChange,
    Object? roleName = _noChange,
    Object? isVerified = _noChange,
    Object? schoolName = _noChange,
    Object? avatarUrl = _noChange,
    Object? position = _noChange,
    Object? literacy = _noChange,
    Object? className = _noChange,
    Object? educationLevel = _noChange,
    Object? grade = _noChange,
  }) {
    return AuthUserEntity(
      id: id == _noChange ? this.id : id as String,
      fullName: fullName == _noChange ? this.fullName : fullName as String,
      roleName: roleName == _noChange ? this.roleName : roleName as String,
      isVerified: isVerified == _noChange
          ? this.isVerified
          : isVerified as bool?,
      schoolName: schoolName == _noChange
          ? this.schoolName
          : schoolName as String?,
      avatarUrl: avatarUrl == _noChange ? this.avatarUrl : avatarUrl as String?,
      position: position == _noChange ? this.position : position as String?,
      literacy: literacy == _noChange ? this.literacy : literacy as String?,
      className: className == _noChange ? this.className : className as String?,
      educationLevel: educationLevel == _noChange
          ? this.educationLevel
          : educationLevel as String?,
      grade: grade == _noChange ? this.grade : grade as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    roleName,
    isVerified,
    schoolName,
    avatarUrl,
    position,
    literacy,
    className,
    educationLevel,
    grade,
  ];
}
