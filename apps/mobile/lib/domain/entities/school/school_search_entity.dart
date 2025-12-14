import 'package:equatable/equatable.dart';

class SchoolSearchEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String address;

  const SchoolSearchEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
  });

  @override
  List<Object?> get props => [id, name, code, address];
}