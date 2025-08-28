import '../../domain/entities/role_specific.dart';

class RoleSpecificModel {
  final Map<String, dynamic> map;
  const RoleSpecificModel(this.map);

  factory RoleSpecificModel.fromEntity(RoleSpecificEntity e) =>
      RoleSpecificModel(e.map);
  Map<String, dynamic> toJson() => map;
}
