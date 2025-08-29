import '../../domain/entities/school_data.dart';

class SchoolDataModel {
  final String name;
  final String code;
  final String address;
  final String level;
  final String? logoUrl;

  SchoolDataModel({
    required this.name,
    required this.code,
    required this.address,
    required this.level,
    this.logoUrl,
  });

  factory SchoolDataModel.fromEntity(SchoolDataEntity e) => SchoolDataModel(
    name: e.name,
    code: e.code,
    address: e.address,
    level: e.level,
    logoUrl: e.logoUrl,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'address': address,
    'level': level,
    if (logoUrl != null) 'logoUrl': logoUrl,
  };
}
