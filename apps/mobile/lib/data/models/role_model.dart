import '../../domain/entities/role.dart';

class RoleModel extends RoleEntity {
  const RoleModel({
    required super.id,
    required super.name,
    required super.description,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'description': description,
  };

  /// Chuyển RoleModel sang RoleEntity để dùng trong Domain layer / Bloc
  RoleEntity toEntity() {
    return RoleEntity(id: id, name: name, description: description);
  }
}
