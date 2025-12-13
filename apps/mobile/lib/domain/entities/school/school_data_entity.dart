import '../../../core/constants/enum_constant.dart';

class SchoolDataEntity {
  final String name;
  final String address;
  final String? phone;
  final String? description;
  final EducationSystemLevelsEnum level;
  final String? logoUrl;

  SchoolDataEntity({
    required this.name,
    required this.address,
    this.phone,
    this.description,
    required this.level,
    this.logoUrl,
  });
}