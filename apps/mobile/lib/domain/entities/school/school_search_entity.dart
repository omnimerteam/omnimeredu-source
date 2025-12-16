// domain/entities/school/school_search_entity.dart
import 'package:equatable/equatable.dart';

class SchoolSearchEntity extends Equatable {
  final String? id;
  final String? name;
  final String? address;
  final String? logoUrl;

  const SchoolSearchEntity({
    this.id,
    this.name,
    this.address,
    this.logoUrl,
  });

  @override
  List<Object?> get props => [id, name, address, logoUrl];
}
