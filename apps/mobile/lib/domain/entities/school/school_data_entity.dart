import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

class SchoolDataEntity extends Equatable {
  final String? id;
  final String? name;
  final String? code;
  final String? address;
  final String? phone;
  final String? description;
  final EducationSystemLevelsEnum? level;
  final String? adminId;
  final String? logoUrl;
  final int studentCount;
  final Map<String, dynamic>? customTheme;

  const SchoolDataEntity({
    this.id,
    this.name,
    this.code,
    this.address,
    this.phone,
    this.description,
    this.level,
    this.adminId,
    this.logoUrl,
    this.studentCount = 0,
    this.customTheme,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    address,
    phone,
    description,
    level,
    adminId,
    logoUrl,
    studentCount,
    customTheme,
  ];
}
