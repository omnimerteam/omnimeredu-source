import 'dart:convert';
import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/school/school_data_entity.dart';

/// 🔹 Data Model cho School (Data Layer)
class SchoolModel {
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

  const SchoolModel({
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

  /// 🔹 Parse từ JSON (backend → app)
  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    // Parse customTheme
    Map<String, dynamic>? parsedTheme;
    final rawTheme = json['customTheme'];
    if (rawTheme is Map<String, dynamic>) {
      parsedTheme = rawTheme;
    } else if (rawTheme is String && rawTheme.isNotEmpty) {
      try {
        parsedTheme = Map<String, dynamic>.from(jsonDecode(rawTheme));
      } catch (_) {
        parsedTheme = null;
      }
    }

    return SchoolModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      level: EducationSystemLevelsEnum.fromString(json['level'] as String?),
      adminId: json['adminId'] as String?,
      logoUrl: json['logoUrl'] as String?,
      studentCount: json['studentCount'] as int? ?? 0,
      customTheme: parsedTheme,
    );
  }

  /// 🔹 Convert sang JSON (app → backend)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'address': address,
      'phone': phone,
      'description': description,
      'level': level?.asString,
      'adminId': adminId,
      'logoUrl': logoUrl,
      'studentCount': studentCount,
      'customTheme': customTheme,
    };
  }

  /// 🔹 Model → Entity (dùng trong Domain/Bloc)
  SchoolDataEntity toEntity() {
    return SchoolDataEntity(
      id: id,
      name: name,
      code: code,
      address: address,
      phone: phone,
      description: description,
      level: level,
      adminId: adminId,
      logoUrl: logoUrl,
      studentCount: studentCount,
      customTheme: customTheme,
    );
  }

  /// 🔹 Entity → Model (dùng trong Data Layer)
  factory SchoolModel.fromEntity(SchoolDataEntity entity) {
    return SchoolModel(
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
}
