import '../../../../core/constants/enum_constant.dart';
import '../../../../domain/entities/school/school_entity.dart';

class SchoolModel extends SchoolEntity {
  const SchoolModel({
    required super.id,
    required super.name,
    required super.code,
    required super.address,
    super.phone,
    super.description,
    required super.level,
    super.logoUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      level: EducationSystemLevelsEnum.fromString(json['level']),
      logoUrl: json['logoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'phone': phone,
      'description': description,
      'level': level.name,
      'logoUrl': logoUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  SchoolEntity toEntity() {
    return SchoolEntity(
      id: id,
      name: name,
      code: code,
      address: address,
      phone: phone,
      description: description,
      level: level,
      logoUrl: logoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
