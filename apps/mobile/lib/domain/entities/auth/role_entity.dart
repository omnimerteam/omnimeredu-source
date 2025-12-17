import 'package:equatable/equatable.dart';

class RoleEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String group;

  const RoleEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.group,
  });

  @override
  List<Object?> get props => [id, name, description, group];
}
