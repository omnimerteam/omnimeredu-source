import '../../../core/constants/enum_constant.dart';

class SchoolEntity {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final String? description;
  final EducationSystemLevelsEnum level;
  final String? logoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SchoolEntity({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.description,
    required this.level,
    this.logoUrl,
    this.createdAt,
    this.updatedAt,
  });
}