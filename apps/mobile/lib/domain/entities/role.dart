class RoleEntity {
  final String id;
  final String name;
  final String description;

  const RoleEntity({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  String toString() {
    return 'RoleEntity(id: $id, name: $name, description: $description)';
  }
}
