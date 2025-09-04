import 'package:equatable/equatable.dart';

class SchoolDataEntity extends Equatable {
  final String id;
  final String name;
  final String? code;
  final String address;
  final String? phone;
  final String? description;
  final String level;
  final String? adminId;
  final String? logoUrl;
  final int studentCount;
  final Map<String, dynamic>? customTheme;

  const SchoolDataEntity({
    required this.id,
    required this.name,
    this.code,
    required this.address,
    this.phone,
    this.description,
    required this.level,
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
