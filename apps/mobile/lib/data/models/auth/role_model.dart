import '../../../domain/entities/auth/role_entity.dart';

class RoleModel {
  final String id;
  final String name;
  final String description;
  final String group;

  const RoleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.group,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      group: json['group'] ?? '',
    );
  }

  RoleEntity toEntity() {
    return RoleEntity(
      id: id,
      name: name,
      description: description,
      group: group,
    );
  }
}
