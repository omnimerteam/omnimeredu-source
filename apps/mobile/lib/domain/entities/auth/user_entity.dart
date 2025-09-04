import 'package:equatable/equatable.dart';

abstract class BaseUser extends Equatable {
  final String id;
  final String fullName;
  final String roleId;
  final String? gender;
  final DateTime? birthday;
  final String? phone;
  final String? address;
  final bool isVerified;
  final String? schoolId;
  final String? avatarUrl;
  final String roleKey;

  const BaseUser({
    required this.id,
    required this.fullName,
    required this.roleId,
    this.gender,
    this.birthday,
    this.phone,
    this.address,
    this.isVerified = false,
    this.schoolId,
    this.avatarUrl,
    required this.roleKey,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    roleId,
    gender,
    birthday,
    phone,
    address,
    isVerified,
    schoolId,
    avatarUrl,
    roleKey,
  ];
}

class Student extends BaseUser {
  final String? classId;
  final String? guardianName;
  final String? guardianPhone;
  final String educationLevel;
  final String? grade;
  final List<RegisteredExtraFee>? registeredExtraFees;
  final List<String>? registeredDiscounts;

  const Student({
    required super.id,
    required super.fullName,
    required super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
    this.classId,
    this.guardianName,
    this.guardianPhone,
    required this.educationLevel,
    this.grade,
    this.registeredExtraFees,
    this.registeredDiscounts,
  }) : super(roleKey: 'Student');

  @override
  List<Object?> get props => [
    ...super.props,
    classId,
    guardianName,
    guardianPhone,
    educationLevel,
    grade,
    registeredExtraFees,
    registeredDiscounts,
  ];
}

class Teacher extends BaseUser {
  final String? literacy;
  final List<String>? subjects;

  const Teacher({
    required super.id,
    required super.fullName,
    required super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
    this.literacy,
    this.subjects,
  }) : super(roleKey: 'Teacher');

  @override
  List<Object?> get props => [...super.props, literacy, subjects];
}

class SchoolAdmin extends BaseUser {
  final String position;

  const SchoolAdmin({
    required super.id,
    required super.fullName,
    required super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
    this.position = "Hiệu trưởng",
  }) : super(roleKey: 'SchoolAdmin');

  @override
  List<Object?> get props => [...super.props, position];
}

class SuperAdmin extends BaseUser {
  const SuperAdmin({
    required super.id,
    required super.fullName,
    required super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
  }) : super(roleKey: 'SuperAdmin');
}

class RegisteredExtraFee extends Equatable {
  final String extraFeeId;
  final double amount;

  const RegisteredExtraFee({required this.extraFeeId, required this.amount});

  @override
  List<Object?> get props => [extraFeeId, amount];
}
