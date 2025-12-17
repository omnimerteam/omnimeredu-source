import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/school/school_data_entity.dart';

class SchoolDataModel extends SchoolDataEntity {
  const SchoolDataModel({
    super.id,
    super.name,
    super.code,
    super.address,
    super.phone,
    super.description,
    super.level,
    super.adminId,
    super.logoUrl,
    super.studentCount,
    super.customTheme,
  });

  factory SchoolDataModel.fromJson(Map<String, dynamic> json) {
    return SchoolDataModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      level: json['level'] != null
          ? EducationSystemLevelsEnum.values.firstWhere(
              (e) =>
                  e.name == json['level'] ||
                  e.toString().split('.').last == json['level'],
              orElse: () => EducationSystemLevelsEnum.Primary,
            )
          : null,
      adminId: json['adminId'] as String?,
      logoUrl: json['logoUrl'] as String?,
      studentCount: (json['studentCount'] as num?)?.toInt() ?? 0,
      customTheme: json['customTheme'] as Map<String, dynamic>?,
    );
  }

  factory SchoolDataModel.fromEntity(SchoolDataEntity entity) {
    return SchoolDataModel(
      id: entity.id,
      name: entity.name,
      code: entity.code,
      address: entity.address,
      phone: entity.phone,
      description: entity.description,
      level: entity.level,
      adminId: entity.adminId,
      logoUrl: entity.logoUrl,
      studentCount: entity.studentCount,
      customTheme: entity.customTheme,
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
      'level': level?.name,
      'adminId': adminId,
      'logoUrl': logoUrl,
      'studentCount': studentCount,
      'customTheme': customTheme,
    };
  }
}
