import '../../../domain/entities/school/school_selector_entity.dart';

class SchoolSelectorModel extends SchoolSelectorEntity {
  const SchoolSelectorModel({
    required super.id,
    required super.name,
    required super.code,
    required super.address,
  });

  factory SchoolSelectorModel.fromJson(Map<String, dynamic> json) {
    return SchoolSelectorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      address: json['address'] as String? ?? '',
    );
  }
}
