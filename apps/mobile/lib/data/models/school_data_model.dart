import 'package:flutter_ios_android_platforms/domain/entities/school_data.dart';

class SchoolDataModel extends SchoolDataEntity {
  const SchoolDataModel({
    required super.id,
    required super.name,
    required super.code,
    required super.address,
    super.phone,
    super.description,
    required super.level,
    super.adminId,
    super.logoUrl,
    super.studentCount = 0,
    super.customTheme,
  });

  factory SchoolDataModel.fromJson(Map<String, dynamic> json) {
    return SchoolDataModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'],
      description: json['description'],
      level: json['level'] ?? '',
      adminId: json['adminId'],
      logoUrl: json['logoUrl'],
      studentCount: json['studentCount'] ?? 0,
      customTheme: json['customTheme'],
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
}
