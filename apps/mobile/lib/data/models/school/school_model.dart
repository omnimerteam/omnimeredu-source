import 'dart:convert';

import 'package:flutter_ios_android_platforms/domain/entities/school/school_data_entity.dart';

class SchoolModel extends SchoolDataEntity {
  const SchoolModel({
    String? id,
    String? name,
    String? code,
    String? address,
    String? phone,
    String? description,
    String? level,
    String? adminId,
    String? logoUrl,
    int studentCount = 0,
    Map<String, dynamic>? customTheme,
  }) : super(
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

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    // Parse customTheme
    Map<String, dynamic>? customTheme;
    final rawTheme = json['customTheme'];
    if (rawTheme is Map<String, dynamic>) {
      customTheme = rawTheme;
    } else if (rawTheme is String && rawTheme.isNotEmpty) {
      // Thử parse từ JSON string nếu server trả về string JSON
      try {
        customTheme = Map<String, dynamic>.from(jsonDecode(rawTheme));
      } catch (_) {
        customTheme = null;
      }
    } else {
      customTheme = null;
    }

    return SchoolModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      level: json['level'] as String?,
      adminId: json['adminId'] as String?,
      logoUrl: json['logoUrl'] as String?,
      studentCount: json['studentCount'] as int? ?? 0,
      customTheme: customTheme,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'address': address,
      'phone': phone,
      'description': description,
      'level': level,
      'adminId': adminId,
      'logoUrl': logoUrl,
      'studentCount': studentCount,
      'customTheme': customTheme,
    };
  }

  /// Chuyển từ Model sang Entity để dùng trong domain
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
