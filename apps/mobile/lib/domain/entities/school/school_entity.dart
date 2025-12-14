import 'package:equatable/equatable.dart';
import '../../../core/constants/enum_constant.dart';

class SchoolEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String address;
  final String? phone;
  final String? description;
  final EducationSystemLevelsEnum level;
  final String? logoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SchoolEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    this.phone,
    this.description,
    required this.level,
    this.logoUrl,
    this.createdAt,
    this.updatedAt,
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
    logoUrl,
    createdAt,
    updatedAt,
  ];
}
